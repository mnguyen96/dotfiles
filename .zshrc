# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi


# Set the directory we want to store zinit and plugins
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# Download Zinit, if it's not there yet
if [ ! -d "$ZINIT_HOME" ]; then
   mkdir -p "$(dirname $ZINIT_HOME)"
   git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# Source/Load zinit
source "${ZINIT_HOME}/zinit.zsh"

# Add in Powerlevel10k
zinit ice depth=1; zinit light romkatv/powerlevel10k

# Add in zsh plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
ZSH_AUTOSUGGEST_STRATEGY=(history completion)


# Add in snippets
zinit snippet OMZP::git
zinit snippet OMZP::kubectl
zinit snippet OMZP::command-not-found

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'


# Load completions
autoload -Uz compinit && compinit
zinit light Aloxaf/fzf-tab

zinit cdreplay -q

# History
HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# Keybindings
bindkey -e
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward
bindkey -r '\eh'

alias status="git status"
alias push="git push"
alias pull="git pull"
alias pullr="git pull --rebase"
alias ac="git add-commit"
alias aca="git add -A && git commit --amend --no-edit"
alias grsoft="git reset --soft HEAD^"
alias grhard="git reset --hard HEAD^"
alias lsa="ls -lahA --color"
alias ls="ls --color"
alias da="direnv allow"
alias hg="history | grep"
alias eg="env | grep"
alias kube="kubectl"
alias vim='nvim'
alias c='clear'
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

export PATH="$HOME/bin:$PATH"

system_type=$(uname -s)
if [ "$system_type" = "Darwin" ]; then
  . $(brew --prefix asdf)/libexec/asdf.sh
elif [ "$system_type" = "Linux" ]; then
  # Brew for linux
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
  # asdf
  . /home/linuxbrew/.linuxbrew/opt/asdf/libexec/asdf.sh
fi

# Shell integrations
eval "$(fzf --zsh)"
eval "$(zoxide init --cmd cd zsh)"
