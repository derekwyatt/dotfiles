# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh
ZSH_THEME=""
# Set to this to use case-sensitive completion
# CASE_SENSITIVE="true"

# Comment this out to disable weekly auto-update checks
# DISABLE_AUTO_UPDATE="true"

# Uncomment following line if you want to disable colors in ls
# DISABLE_LS_COLORS="true"

# Uncomment following line if you want to disable autosetting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment following line if you want red dots to be displayed while waiting for completion
COMPLETION_WAITING_DOTS="true"

if [[ -z ${MY_SHELL_LEVEL:-0} ]]; then
  export MY_SHELL_LEVEL=0
else
  export MY_SHELL_LEVEL=$(($MY_SHELL_LEVEL+1))
fi

export SS_DISPLAY_LIMIT=25
export ZSH_CUSTOM=~/.dotfiles/zsh_custom
plugins=(git regex-dirstack vim-interaction)
source $ZSH/oh-my-zsh.sh
source $ZSH_CUSTOM/themes/gnzh.zsh-theme

bindkey -v
bindkey -M viins 'jj' vi-cmd-mode
setopt auto_pushd
setopt pushd_silent
setopt pushd_ignore_dups
setopt ignore_eof
setopt rm_star_silent
unsetopt nomatch
unsetopt correct_all

if [ $(uname) = Darwin ]; then
  export PATH=.:~/bin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
else
  alias open=gnome-open
  export PATH=.:buildutil:/home/dwyatt/local/bin:/home/dwyatt/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/opt/qnx650/host/linux/x86/usr/bin:/etc/qnx/bin
fi

export GPGKEY=B2F6D883
export GPG_TTY=$(tty)

export EDITOR=vim

if which dircolors > /dev/null; then
  test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
  alias ls='ls --color=auto -F'
  alias grep='grep --color=auto'
  alias fgrep='fgrep --color=auto'
  alias egrep='egrep --color=auto'
fi

function eecho
{
  echo $@ 1>&2
}

function findWithSpec
{
  local dirs=
  local egrepopts="-v '\\.sw[po]\\$|/\\.git/|^\\.git/'"
  local nullprint=
  while [[ $# != 0 ]];
  do
    if [[ "$1" == "-Z" ]]; then
      egrepopts="-Zz $egrepopts"
      nullprint="-print0"
      shift
    elif [[ -d "$1" ]]; then
      dirs="$dirs '$1'"
      shift
    else
      break
    fi
  done
  if [[ -z "$dirs" ]]; then
    dirs=.
  fi
  eval "find $dirs $nullprint $@ | egrep $egrepopts"
}

function findsrc
{
  findWithSpec "$@" '-name \*.java -o -name \*.scala -o -name Makefile -o -name \*.h -o -name \*.cpp -o -name \*.c'
}
alias findsrcz="findsrc -Z"

function findj
{
  findWithSpec "$@" '-name \*.java'
}
alias findjz="findj -Z"

function finds
{
  findWithSpec "$@" '-name \*.scala'
}
alias findsz="finds -Z"

function findsj
{
  (finds "$@"; findj "$@")
}
alias findsjz="findsj -Z"

function findh
{
  findWithSpec "$@" '-name \*.h -o -name \*.hpp'
}
alias findhz="findh -Z"

function findc
{
  findWithSpec "$@" '-name \*.cpp -o -name \*.c'
}
alias findcz="findc -Z"

function findch
{
  (findc "$@"; findh "$@")
}
alias findchz="findch -Z"

function findf
{
  findWithSpec "$@" "-type f"
}
alias findfz="findf -Z"

function findm
{
  findWithSpec "$@" "-name Makefile"
}
alias findmz="findm -Z"

alias f=findWithSpec

function findClass
{
  local pattern="${1-}"
  if [ -z "$pattern" ]; then
    eecho "No pattern supplied" 1>&2
    return 1
  fi
  echo $CLASSPATH | tr ':' '\n' | grep -v '^ *$' | \
    while read entry
    do
      echo "====== $entry ======"
      if [ "${entry%.jar}" != "$entry" ]; then
        if [ -f "$entry" ]; then
          jar tf "$entry" | egrep $pattern
        fi
      elif [ -d "$entry" ]; then
        find "$entry" | egrep -i $pattern
      fi
    done
}

function ff
{
  if [ $# = 0 ]; then
    eecho "usage: ff <file>" 1>&2
    return 1
  fi
  if [ -d "$1" ]; then
    eecho "That's a directory, dumbass." 1>&2
    return 1
  elif [ "${1%/*}" = "$1" ]; then
    firefox -new-tab "file://$(pwd)/$1"
  else
    "cd" "${1%/*}"
    local dir="$(pwd)"
    "cd" - >/dev/null
    firefox -new-tab "file://$dir/${1##*/}"
  fi
  return 0
}

function gitall
{
  find . -type d -a -name .git | while read d
  do
    local x=${d%.git}
    echo ========= $x
    (cd $x; git "$@")
  done
}

# Assorted
alias swps='find . -name .\*.sw[op]'
alias rmstd='xargs rm -vf'
alias xag='xargs -0 egrep'
alias pd="cd -"
alias grss='for f in $(find . -type d -a -name .git); do x=${f%/.git}; echo ==== $x; (cd $x; gss); done'
alias gd='git diff'
alias gdc='git diff --cached'
alias o=octave

alias sc=screen
alias scl="screen -list"

test -f ~/.zshrc_local && . ~/.zshrc_local
