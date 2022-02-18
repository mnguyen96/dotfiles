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

[[ -f ~/.oh-my-zsh/custom/plugins/zsh-snap/znap.zsh ]] ||
    git clone --depth 1 -- \
        https://github.com/marlonrichert/zsh-snap.git ~/.oh-my-zsh/custom/plugins/zsh-snap
source ~/.oh-my-zsh/custom/plugins/zsh-snap/znap.zsh


# z
[[ -f $HOME/tools/z/z.sh/z.sh ]] ||
    git clone --depth 1 -- \
        https://github.com/rupa/z.git $HOME/tools/z/z.sh
. $HOME/tools/z/z.sh

# znap source marlonrichert/zsh-autocomplete
# ZSH_AUTOSUGGEST_STRATEGY=( history )
znap source zsh-users/zsh-autosuggestions
znap source zsh-users/zsh-syntax-highlighting

### Fix slowness of pastes with zsh-syntax-highlighting.zsh
pasteinit() {
  OLD_SELF_INSERT=${${(s.:.)widgets[self-insert]}[2,3]}
  zle -N self-insert url-quote-magic # I wonder if you'd need `.url-quote-magic`?
}

pastefinish() {
  zle -N self-insert $OLD_SELF_INSERT
}
zstyle :bracketed-paste-magic paste-init pasteinit
zstyle :bracketed-paste-magic paste-finish pastefinish
### Fix slowness of pastes

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="powerlevel10k/powerlevel10k"
ZSH_DISABLE_COMPFIX=true
# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in ~/.oh-my-zsh/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS=true

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=()

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

alias status="git status"
alias push="git push"
alias pull="git pull"
alias pullr="git pull --rebase"
alias ac="git add-commit -m"
alias aca="git add -A && git commit --amend --no-edit"
alias grsoft="git reset --soft HEAD^"
alias grhard="git reset --hard HEAD^"
alias start="npm run start -- --watch .env"
alias lint="npm run lint"
alias test="npm run test -- --watch"
alias check="npm run check"
alias sync-tenants="node $HOME/esante/sys/.tenant-configs/sync"
alias da="direnv allow"
alias is="npm i && start"
alias ys="yarn && start"
alias hg="history | grep"
eval "$(direnv hook zsh)"

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
      unset AWS_ACCESS_KEY_ID && unset AWS_SECRET_ACCESS_KEY && unset AWS_SESSION_TOKEN
      export AWS_DEFAULT_PROFILE=$1
      export AWS_PROFILE=$1
      export AWS_REGION=$(aws configure get region --profile $1)
      export AWS_DEFAULT_REGION=$(aws configure get region --profile $1)
      echo "AWS CLI Profile: $1"
      ;;
    2)
      unset AWS_ACCESS_KEY_ID && unset AWS_SECRET_ACCESS_KEY && unset AWS_SESSION_TOKEN
      export AWS_DEFAULT_PROFILE=$1
      export AWS_PROFILE=$1
      if [ -z "$1" ]; then
        echo "No MFA device. Make sure your local CLI profile and/or MFA devicce in AWS Console are configured."
        # exit 1
      fi
      echo 'MFA Token: '
      read MFA_TOKEN
      echo "Entered token: $MFA_TOKEN"
      MFA_DEVICE=$(aws iam list-mfa-devices | jq -r '.MFADevices|first.SerialNumber')
      MFA_SESSION=$(aws sts get-session-token --serial-number $MFA_DEVICE --token-code $MFA_TOKEN --duration-seconds 43200)
      unset AWS_DEFAULT_PROFILE && unset AWS_PROFILE
      unset AWS_ACCESS_KEY_ID && export AWS_ACCESS_KEY_ID=$(echo $MFA_SESSION | jq -r '.Credentials.AccessKeyId') 
      unset AWS_SECRET_ACCESS_KEY && export AWS_SECRET_ACCESS_KEY=$(echo $MFA_SESSION | jq -r '.Credentials.SecretAccessKey') 
      unset AWS_SESSION_TOKEN && export AWS_SESSION_TOKEN=$(echo $MFA_SESSION | jq -r '.Credentials.SessionToken') 
      unset AWS_REGION && export AWS_REGION=$(aws configure get region --profile $1) 
      unset AWS_DEFAULT_REGION && export AWS_DEFAULT_REGION=$(aws configure get region --profile $1) 
      ;;
    *)
      grep "profile" $HOME/.aws/config | sed 's/\[profile \(.*\)\]/\1/'
      ;;
    esac
  else
    echo "AWS CLI is not configured on this machine!"
  fi
}

function pg-tunnel() {
  USAGE="USAGE:\t pg-tunnel <project> [dev|qa|stage|prod]"
  case "$1" in
  "esante")
    jumphost=18.210.203.124
    ssh_key=~/.ssh/jumphost.pem
    dev=esante-dev.cvjgxrxnvk8i.us-east-1.rds.amazonaws.com
    qa=esante-qa.cvjgxrxnvk8i.us-east-1.rds.amazonaws.com
    stage=esante-aurora-postgres-stage-cluster.cluster-cvjgxrxnvk8i.us-east-1.rds.amazonaws.com
    ;;
  "sequoia")
    jumphost=3.213.168.216
    ssh_key=~/.ssh/sequoia.pem
    dev=sequoia-dev.ccqasi2yxz3m.us-east-1.rds.amazonaws.com
    qa=sequoia-qa.ccqasi2yxz3m.us-east-1.rds.amazonaws.com
    stage=sequoia-stage-cluster.cluster-ccqasi2yxz3m.us-east-1.rds.amazonaws.com
    ;;
  *)
    echo "Invalid or missing project [$1] \n$USAGE"
    return 1
    ;;
  esac
  if [[ "$2" =~ ^(dev|qa|stage|prod)$ ]]; then
    eval "dbhost=\$$2"
    if [[ -n "$dbhost" ]]; then
      echo "----- $dbhost -----"
      echo "ssh -i $ssh_key -N -L 5432:$dbhost:5432 ec2-user@$jumphost"
      ssh -i $ssh_key -N -L 5432:$dbhost:5432 ec2-user@$jumphost
    else
      echo "Environment [$2] not configured \n$USAGE"
      return 2
    fi
  else
    echo "Invalid environment [$2] \n$USAGE"
    return 2
  fi
}

. $(brew --prefix asdf)/asdf.sh

# tmux
if [ ! "$TMUX" = "" ]; then export TERM=xterm-256color; fi


# . ~/.asdf/plugins/java/set-java-home.zsh

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('$HOME/anaconda3/bin/conda' 'shell.zsh' 'hook' 2>/dev/null)"
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
