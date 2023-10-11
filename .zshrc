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


# z
[[ -f $HOME/tools/z/z.sh ]] ||
    git clone --depth 1 -- \
        https://github.com/rupa/z.git $HOME/tools/z
. $HOME/tools/z/z.sh

# znap source marlonrichert/zsh-autocomplete
# ZSH_AUTOSUGGEST_STRATEGY=( history )
znap source zsh-users/zsh-autosuggestions
znap source zsh-users/zsh-syntax-highlighting
znap source romkatv/powerlevel10k

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
zstyle ':omz:update' mode reminder
# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="powerlevel10k/powerlevel10k"
ZSH_DISABLE_COMPFIX=true
DISABLE_AUTO_TITLE="true"

plugins=(git)

source $ZSH/oh-my-zsh.sh

alias status="git status"
alias push="git push"
alias pull="git pull"
alias pullr="git pull --rebase"
alias ac="git add-commit"
alias aca="git add -A && git commit --amend --no-edit"
alias grsoft="git reset --soft HEAD^"
alias grhard="git reset --hard HEAD^"
alias hg="history | grep"
alias eg="env | grep"
eval "$(direnv hook zsh)"

function ssh_tunnel(){
    # ssh_tunnel [jumphost] [target-server-name-or-ip] [target-server-port] [local-server-port]
     if [ -z "$1" ] || [ -z "$2" ] || [ -z "$3" ] || [ -z "$4" ]; then
        echo "USAGE: ssh_tunnel jumphost target-server-name-or-ip target-server-port local-server-port"
        return 1;
    fi
    ssh -v -N -L $4:$2:$3 $1
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

export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"
