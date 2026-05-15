# ~/.bashrc - interactive bash settings

# If not running interactively, dont't do anything
case $- in
*i*) ;;
*) return ;;
esac

# History
HISTSIZE=5000
HISTSIZE=10000
HISTCONTROL=ignoredups:erasedups
shopt -s histappend
PROMPT_COMMAND="history -a; history -n"
umask 022

alias ll='ls -lah --color=auto'
alias la='ls -A --color=auto'
alias l='ls -CF --color=auto'
alias ..='cd ..'
alias ...='cd ../..'
alias grep='grep --color=auto'

# Git shortcuts
alias gs='git status'
alias gd='git diff'
alias gl='git log --oneline --decorate --graph'

# Prompt
PS1='(\u@\h)-[\w]\n└─\$ '

# Bash completion if available
if [ -f /usr/share/bash-completion/bash_completion ]; then
  . /usr/share/bash-completion/bash_completion
fi
