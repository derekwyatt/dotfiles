
export AUTO_DIRSTACK_LIMIT=${AUTO_DIRSTACK_LIMIT:-15}

function echoerr
{
  echo $@ 1>&2
}

function pd
{
  local dirname="${1-}"

  if [ "$dirname" = "" ]; then
    local firstdir="$PWD"
    if [ ${#AUTO_DIRSTACK[*]} = 0 ]; then
      echoerr "Stack is empty.  Cannot swap."
      return 1
    fi
    local seconddir=$(popStack)
    pushStack "$firstdir"
    "cd" "$seconddir"
    return $?
  else
    if [ -d "$dirname" ]; then
      if [ "$dirname" != '.' ]; then
        pushStack "$PWD"
      fi
      "cd" "$dirname"
      return $?
    else
      echoerr "zsh: $dirname: not found"
      return 1
    fi
  fi
} 

function cd_
{
  local ret=0

  if [ $# = 0 ]; then
    pd "$HOME"
    local ret=$?
  elif [[ $# == 1 && "$1" == "-" ]]; then
    pd
    local ret=$?
  elif [ $# -gt 1 ]; then
    local from="$1"
    local to="$2"
    local c=0
    local mypath=""
    local numberOfFroms=$(echo $PWD | tr '/' '\n' | grep "^$from$" | wc -l)
    while [ $c -lt $numberOfFroms ]
    do
      local mypath=""
      local subc=$c
      local tokencount=0
      for subdir in $(echo $PWD | tr '/' '\n' | tail -n +2)
      do
        if [[ "$subdir" == "$from" ]]; then
          if [ $subc -eq $tokencount ]; then
            local mypath="$mypath/$to"
            local subc=$((subc+1))
          else
            local mypath="$mypath/$from"
            local tokencount=$((tokencount+1))
          fi
        else
          local mypath="$mypath/$subdir"
        fi
      done
      if [ -d "$mypath" ]; then
        break
      fi
      local c=$((c=c+1))
    done
    if [ "$mypath" == "$PWD" ]; then
      echoerr "Bad substitution"
      local ret=1
    else
      pd "$mypath"
      local ret=$?
    fi
  else
    pd "$1"
    local ret=$?
  fi

  return $ret
} 

function popStack
{
  if [[ ${#AUTO_DIRSTACK[*]} == 0 ]]; then
    echoerr "Cannot pop stack.  No elements to pop."
    return 1
  fi
  local retv="${AUTO_DIRSTACK[1]}"
  set -A AUTO_DIRSTACK ${AUTO_DIRSTACK[2,-1]}

  echo $retv
}

function pushStack
{
  set -A AUTO_DIRSTACK "$1" ${AUTO_DIRSTACK[1,$((AUTO_DIRSTACK_LIMIT-1))]}
} 

function ss
{
  local c=1
  local collimit=$((${COLUMNS-80}-10))
  for f in $AUTO_DIRSTACK
  do
    if (( ${#f} > $collimit )); then
      local x="...$(echo $f | cut -c$((${#f}-$collimit))-)"
    else
      local x=$f
    fi
    echo "$c) $x"
    ((c=c+1))
  done
} 

function csd
{
  local num="${1-}"

  if ! echo "$num" | grep -q '^[0-9][0-9]*$'; then
    local c=1
    local re=$num
    local num=1
    while [ "$c" -le "${#AUTO_DIRSTACK[*]}" ]
    do
      if echo "${AUTO_DIRSTACK[$c]}" | grep -q $re; then
        local num=$c
        break
      fi
      ((c=c+1))
    done
  fi
  if [ $num = 0 ]; then
    echoerr "usage: csd <number greater than 0 | regex>"
    return 1
  elif [ $num -gt ${#AUTO_DIRSTACK[*]} ]; then
    echoerr "$num is beyond the stack size."
    return 1
  else
    local dir=${AUTO_DIRSTACK[$num]}
    set -A AUTO_DIRSTACK ${AUTO_DIRSTACK[1,$((num-1))]} ${AUTO_DIRSTACK[$((num+1)),-1]}
    cd_ "$dir"
    return $?
  fi
} 

alias cd=cd_
