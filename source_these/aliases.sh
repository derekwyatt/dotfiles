#!/bin/bash

# Reload these aliases
alias ra='for f in ~/.bash/*; do . $f; done'

# Code related aliases
alias gdb="gdb --quiet"
if ! uname | grep -q Darwin; then
  alias open=gnome-open
fi
alias sc=screen
alias scl="screen -list"

function findWithSpec
{
  typeset dirs=
  typeset egrepopts="-v '\\.sw[po]\\$|/\\.git/|^\\.git/'"
	typeset nullprint=
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
  typeset pattern="${1-}"
  if [ -z "$pattern" ]; then
    echo "No pattern supplied" 1>&2
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

# Assorted
alias swps='find . -name .\*.sw[op]'
alias rmstd='xargs rm -vf'
alias xag='xargs -0 egrep'

# some ls aliases
alias ll='ls -halF'
alias la='ls -A'
alias l='ls -CF'

# programs
alias firefox='firefox -P default'
function ff
{
  if [ $# = 0 ]; then
    echo "usage: ff <file>" 1>&2
    return 1
  fi
  if [ -d "$1" ]; then
    echo "That's a directory, dumbass." 1>&2
    return 1
  elif [ "${1%/*}" = "$1" ]; then
    firefox -new-tab "file://$(pwd)/$1"
  else
    \cd "${1%/*}"
    typeset dir="$(pwd)"
    \cd - >/dev/null
    firefox -new-tab "file://$dir/${1##*/}"
  fi
  return 0
}

alias pg='ps -ef | grep '
