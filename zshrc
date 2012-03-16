# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh
ZSH_THEME="gnzh"
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

plugins=(git)

source $ZSH/oh-my-zsh.sh
bindkey -v
bindkey -M viins 'jj' vi-cmd-mode
unsetopt nomatch

if [ $(uname) = Darwin ]; then
  export PATH=.:~/bin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
else
  export PATH=.:buildutil:/home/dwyatt/local/bin:/home/dwyatt/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/opt/qnx650/host/linux/x86/usr/bin:/etc/qnx/bin
fi

export GPGKEY=B2F6D883
export GPG_TTY=$(tty)

export EDITOR=/usr/local/bin/vim
export JAVA_HOME=/usr/local/jdk

if which dircolors > /dev/null; then
  test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
  alias ls='ls --color=auto -F'
  alias grep='grep --color=auto'
  alias fgrep='fgrep --color=auto'
  alias egrep='egrep --color=auto'
fi

function gg
{
  if uname | grep -q Darwin; then
    mvim --remote-silent $@
  else
    gvim --remote-silent $@
  fi
}

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

# Assorted
alias swps='find . -name .\*.sw[op]'
alias rmstd='xargs rm -vf'
alias xag='xargs -0 egrep'

alias open=gnome-open
alias sc=screen
alias scl="screen -list"

function eecho
{
  echo $@ 1>&2
}

function pd
{
  local dirname="${1-}"
  local firstdir seconddir ret p oldDIRSTACK

  if [ "$dirname" = "" ]; then
    firstdir=$(pwd)
    if [ ${#DS[*]} = 0 ]; then
      eecho "Stack is empty.  Cannot swap."
      return 1
    fi
    seconddir=$(popStack)
    pushStack "$firstdir"
    "cd" "$seconddir"
    ret=$?
    return $ret
  else
    if [ -d "$dirname" ]; then
      if [ "$dirname" != '.' ]; then
        pushStack "$(pwd)"
      fi
      "cd" "$dirname"
      ret=$?
      return $ret
    else
      eecho "zsh: $dirname: not found"
      return 1
    fi
  fi
} 

function cd_
{
  local ret=0

  if [ $# = 0 ]; then
    pd "$HOME"
    ret=$?
  elif [[ $# == 1 && "$1" == "-" ]]; then
    pd
    ret=$?
  elif [ $# -gt 1 ]; then
    local from="$1"
    local to="$2"
    local c=0
    local path=
    local x=$(pwd)
    local numberOfFroms=$(echo $x | tr '/' '\n' | grep "^$from$" | wc -l)
    while [ $c -lt $numberOfFroms ]
    do
      path=
      local subc=$c
      local tokencount=0
      for subdir in $(echo $x | tr '/' '\n' | tail -n +2)
      do
        if [[ "$subdir" == "$from" ]]; then
          if [ $subc -eq $tokencount ]; then
            path="$path/$to"
            subc=$((subc+1))
          else
            path="$path/$from"
            tokencount=$((tokencount+1))
          fi
        else
          path="$path/$subdir"
        fi
      done
      if [ -d "$path" ]; then
        break
      fi
      c=$((c=c+1))
    done
    if [ "$path" == "$x" ]; then
      eecho "Bad substitution"
      ret=1
    else
      pd "$path"
      ret=$?
    fi
  else
    pd "$1"
    ret=$?
  fi

  return $ret
} 

function popStack
{
  if [[ ${#DS[*]} == 0 ]]; then
    eecho "Cannot pop stack.  No elements to pop."
    return 1
  fi
  local retv="${DS[1]}"
  set -A DS ${DS[2,-1]}

  echo $retv
}

function pushStack
{
  set -A DS "$1" ${DS[1,-1]}
} 

function ss
{
  local c=1
  for f in $DS
  do
    if (( ${#f} > 100 )); then
      x="...$(echo $f | cut -c$((${#f}-100))-)"
    else
      x=$f
    fi
    echo "$c) $x"
    ((c=c+1))
  done
} 

function csd
{
  local num="${1-}"

  if ! echo "$num" | grep -q '^[0-9][0-9]*$'; then
    c=1
    re=$num
    num=1
    while [ "$c" -le "${#DS[*]}" ]
    do
      if echo "${DS[$c]}" | grep -q $re; then
        num=$c
        break
      fi
      ((c=c+1))
    done
  fi
  if [ $num = 0 ]; then
    eecho "usage: csd <number greater than 0 | regex>"
    return 1
  elif [ $num -gt ${#DS[*]} ]; then
    eecho $num is beyond the stack size.
    return 1
  else
    local dir=${DS[$num]}
    set -A DS ${DS[1,$((num-1))]} ${DS[$((num+1)),-1]}
    cd_ "$dir"
    return $?
  fi
} 

alias cd=cd_

test -f ~/.zshrc_local && . ~/.zshrc_local
