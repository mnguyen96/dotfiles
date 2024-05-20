# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

setopt EXTENDED_HISTORY
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_FIND_NO_DUPS
setopt HIST_SAVE_NO_DUPS
setopt HIST_BEEP



bindkey "\eh" backward-word
bindkey "\el" forward-word

[[ -f $HOME/.oh-my-zsh/custom/plugins/zsh-snap/znap.zsh ]] ||
    git clone --depth 1 -- \
        https://github.com/marlonrichert/zsh-snap.git $HOME/.oh-my-zsh/custom/plugins/zsh-snap
source $HOME/.oh-my-zsh/custom/plugins/zsh-snap/znap.zsh

znap source marlonrichert/zsh-autocomplete
znap source zsh-users/zsh-autosuggestions
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#ff00ff,bold"
znap source zsh-users/zsh-syntax-highlighting
znap source romkatv/powerlevel10k
znap source rupa/z

zstyle ':omz:update' mode reminder
# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME=""
ZSH_DISABLE_COMPFIX=true
DISABLE_AUTO_TITLE="true"

plugins=(git)

source $ZSH/oh-my-zsh.sh

bindkey "\eh" backward-char
bindkey "\el" forward-char
bindkey "\eH" backward-word
bindkey "\eL" forward-word

alias status="git status"
alias push="git push"
alias pull="git pull"
alias pullr="git pull --rebase"
alias ac="git add-commit"
alias aca="git add -A && git commit --amend --no-edit"
alias grsoft="git reset --soft HEAD^"
alias grhard="git reset --hard HEAD^"
alias da="direnv allow"
alias hg="history | grep"
alias eg="env | grep"
alias kube="kubectl"
eval "$(direnv hook zsh)"

function aws-login() {
  SSO_FILE=$(ls -tr "${HOME}/.aws/sso/cache" | tail -n1)
  echo $SSO_FILE
  if [[ ! -z "$SSO_FILE" && -f ${HOME}/.aws/sso/cache/${SSO_FILE} ]]; then
    EXPIRATION=$(cat $HOME/.aws/sso/cache/${SSO_FILE} | jq -r '.expiresAt')
    NOW=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
    # echo $EXPIRATION
    # echo $NOW
    if [[ $NOW > $EXPIRATION ]]; then
      echo "SSO expired"
      aws sso login --profile $1
    fi
  else
    aws sso login --profile $1
  fi

  JSON_BASEPATH="${HOME}/.aws/cli/cache"
  AWS_CREDENTIALS_PATH="${HOME}/.aws/credentials"

  if [ -f ${AWS_CREDENTIALS_PATH} ]; then
      echo "backing up existing credentials"
      if [[ -f ${HOME}/.aws/backup ]]; then
        mkdir ${HOME}/.aws/backup
      fi
      cp -rf ${AWS_CREDENTIALS_PATH} ${HOME}/.aws/backup/$(date +"%s")
      currdir=$PWD
      dirs=($(find ${HOME}/.aws/backup -type d))
      for dir in "${dirs[@]}"; do
        cd "$dir"
        ls -pt | grep -v / | tail -n +10 | xargs rm -f
        cd $currdir
      done
  fi

  # find the latest CLI JSON file
  json_file=$(ls -tr "${JSON_BASEPATH}" | tail -n1)
  if [[ ! -z "$json_file" && -f ${JSON_BASEPATH}/${json_file} ]]; then
    echo "Found cli cache file"
    EXPIRATION=$(cat ${JSON_BASEPATH}/${json_file} | jq -r '.Credentials.Expiration')
    NOW=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
    # echo $EXPIRATION
    # echo $NOW
    if [[ $NOW > $EXPIRATION ]]; then
      echo "CLI cache expired"
      rm ${JSON_BASEPATH}/${json_file}
      unset AWS_ACCESS_KEY_ID && unset AWS_SECRET_ACCESS_KEY && unset AWS_SESSION_TOKEN
      aws sts get-caller-identity --no-cli-pager --profile $1 &
      PID=$!
      wait $PID
    fi
  else
    aws sts get-caller-identity --no-cli-pager --profile $1 &
    PID=$!
    wait $PID
  fi
  json_file=$(ls -tr "${JSON_BASEPATH}" | tail -n1)
  # use jq to dump stuff in the right place
  unset AWS_DEFAULT_PROFILE && unset AWS_PROFILE
  unset AWS_ACCESS_KEY_ID && export AWS_ACCESS_KEY_ID=$(cat ${JSON_BASEPATH}/${json_file} | jq -r '.Credentials.AccessKeyId')
  unset AWS_SECRET_ACCESS_KEY && export AWS_SECRET_ACCESS_KEY=$(cat ${JSON_BASEPATH}/${json_file} | jq -r '.Credentials.SecretAccessKey')
  unset AWS_SESSION_TOKEN && export AWS_SESSION_TOKEN=$(cat ${JSON_BASEPATH}/${json_file} | jq -r '.Credentials.SessionToken')
  unset AWS_REGION && export AWS_REGION=$(aws configure get region --profile $1)
  unset AWS_DEFAULT_REGION && export AWS_DEFAULT_REGION=$(aws configure get region --profile $1)
}

# this goes with awsp function
if [ -f $HOME/.aws/.env ]; then
  export $(cat ~/.aws/.env | xargs)
fi

function awsp() {
	if [[ -d $HOME/.aws ]] && [[ -f $HOME/.aws/config ]]; then
		case $# in
		1)
      PFF=$(grep "profile" $HOME/.aws/config | sed 's/\[profile \(.*\)\]/\1/' | grep $1)
      if [ -z "$PFF" ]; then
        echo "Unknow profile $1"
        unset AWS_DEFAULT_PROFILE && unset AWS_PROFILE
        exit 1
      fi
      unset AWS_ACCESS_KEY_ID && unset AWS_SECRET_ACCESS_KEY && unset AWS_SESSION_TOKEN && unset AWS_PROMPT
      export AWS_DEFAULT_PROFILE=$1
      export AWS_PROFILE=$1
      echo "AWS CLI Profile: $1"
      ;;
		2)
			unset AWS_ACCESS_KEY_ID && unset AWS_SECRET_ACCESS_KEY && unset AWS_SESSION_TOKEN && unset AWS_DEFAULT_PROFILE && unset AWS_PROFILE && unset AWS_REGION && unset AWS_DEFAULT_REGION
			export AWS_DEFAULT_PROFILE=$1
			export AWS_PROFILE=$1
			if [ -z "$1" ]; then
				echo "No MFA device. Make sure your local CLI profile and/or MFA device in AWS Console are configured."
				return
			fi
			MFA_DEVICE=$(aws iam list-mfa-devices | jq -r '.MFADevices|first.SerialNumber')
			echo "Found device: $MFA_DEVICE"
			echo ''
			echo 'MFA Token: '
			read MFA_TOKEN
			echo "Entered token: $MFA_TOKEN"
			MFA_SESSION=$(aws sts get-session-token --serial-number $MFA_DEVICE --token-code $MFA_TOKEN --duration-seconds 43200)
			unset AWS_DEFAULT_PROFILE && unset AWS_PROFILE

			echo '' > ~/.aws/.env

			AWS_ACCESS_KEY_ID=$(echo $MFA_SESSION | jq -r '.Credentials.AccessKeyId')
			echo "AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}" >> ~/.aws/.env

			AWS_SECRET_ACCESS_KEY=$(echo $MFA_SESSION | jq -r '.Credentials.SecretAccessKey')
			echo "AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY" >> ~/.aws/.env

			AWS_SESSION_TOKEN=$(echo $MFA_SESSION | jq -r '.Credentials.SessionToken')
			echo "AWS_SESSION_TOKEN=$AWS_SESSION_TOKEN" >> ~/.aws/.env

			AWS_REGION=$(aws configure get region --profile $1)
			echo "AWS_REGION=$AWS_REGION" >> ~/.aws/.env

			AWS_DEFAULT_REGION=$(aws configure get region --profile $1)
			echo "AWS_DEFAULT_REGION=$AWS_DEFAULT_REGION" >> ~/.aws/.env

			export $(cat ~/.aws/.env | xargs)
			;;
		*)
			grep "profile" $HOME/.aws/config | sed 's/\[profile \(.*\)\]/\1/'
			;;
		esac
	else
		echo "AWS CLI is not configured on this machine!"
	fi
}

if [ -f $HOME/.asdf/asdf.sh ]; then
    . $HOME/.asdf/asdf.sh
else
    . $(brew --prefix asdf)/libexec/asdf.sh
fi

# tmux
if [ ! "$TMUX" = "" ]; then export TERM=xterm-256color; fi

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('$HOME/anaconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "$HOME/anaconda3/etc/profile.d/conda.sh" ]; then
        . "$HOME/anaconda3/etc/profile.d/conda.sh"
    else
        export PATH="$HOME/anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# pnpm
export PNPM_HOME="$HOME/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

# bun completions
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
