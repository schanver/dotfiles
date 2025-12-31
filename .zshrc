#Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.

if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

HISTFILE=~/.histfile
HISTSIZE=10000
SAVEHIST=10000
unsetopt beep
bindkey -e

zstyle :compinstall filename "$HOME/.zshrc"

autoload -Uz compinit && compinit
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

source /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

export EDITOR="nvim"
export PATH="$HOME/.scripts:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"

# Aliases 

alias npc="rmpc"
alias f="fzf"
alias ff="fastfetch"
alias n="nvim"
alias nv="nvim"
alias nvi="nvim"
alias ls="ls --color=always"
alias la="ls -a --color=always"
alias lg="lazygit"
alias doom="~/.config/emacs/bin/doom" 
alias gs="git status"
alias gc="git checkout"
alias gsw="git switch"
alias gb="git branch"
alias gpl="git pull"
alias gps="git push"
alias o="xdg-open"
alias ..="cd ../$1"
alias ...="cd ../../$1"
alias ....="cd ../../../$1"
alias c="cd ~/.config/"
alias sl="ls --color=always"
alias up="sudo pacman -Syu"
alias p="sudo pacman"
alias dot="cd ~/dotfiles/"
alias i3="nvim ~/.config/i3/config"
alias e="exit"
alias org="cd ~/org/roam"
alias za="zathura"
alias tkill="tmux kill-session -t $1"
alias tms="tmux switch-client -t $1"
alias p3="python3"

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

eval "$(zoxide init zsh)"

