# ZSH Theme - Preview: http://dl.dropbox.com/u/4109351/pics/gnzh-zsh-theme.png
# Based on bira theme

# load some modules
autoload -U colors zsh/terminfo # Used in the colour alias below
colors
setopt prompt_subst

function limitPath
{
  local string="$1"
  local columns=$2
  shift; shift
  local extrainfo="$(echo $* | tr -d '%{}')"
  local width=$((columns-${#extrainfo}-40))
  if (( ${#string} > $width )); then
    local new="$(echo $string | sed 's%/\([^/]\)[^/][^/]*/%/\1/%')"
    if (( ${#new} == ${#string} )); then
      echo $string
    else
      limitPath "$new" $columns
    fi
    # local splitnum=$((width/2))
    # echo "$(echo $string | cut -c1-$splitnum) ... $(echo $string | cut -c$((${#string}-$splitnum))-)"
  else
    echo $string
  fi
}

function limitGitBranch
{
  local br=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
  local colour="$PR_GREEN"
  if [[ $br == "HEAD" ]]; then
    colour="$PR_YELLOW"
    br=$(git for-each-ref --sort=taggerdate --format '%(refname) %(taggerdate)' refs/tags | sed 's%.*/%%' | grep '^v' | head -1 | tr -d ' ')
    if [[ -z $br ]]; then
      br=$(git for-each-ref --sort=taggerdate --format '%(refname) %(taggerdate)' refs/tags | head -1 | tr -d ' ')
    fi
    if [[ -z $br ]]; then
      colour="$PR_GREEN"
      br=HEAD
    fi
  fi
  br=$(echo $br | sed -e 's!\([^/_]\)[^/_]*[/_]!\1/!g' -e 's!\(/[^_]*\)_.*!\1!')
  local dirty=""
  if git status > /dev/null 2>&1; then
    if [[ -n $(git status -s) ]]; then
      echo "$PR_RED$ZSH_THEME_GIT_PROMPT_PREFIX$br$ZSH_THEME_GIT_PROMPT_SUFFIX$PR_NO_COLOR"
    else
      echo "$colour$ZSH_THEME_GIT_PROMPT_PREFIX$br$ZSH_THEME_GIT_PROMPT_SUFFIX$PR_NO_COLOR"
    fi
  else
    echo ""
  fi
}

function getMinikubeContext
{
  local context=$(kubectl config current-context)
  local colour="${PR_MAGENTA}"
  if [[ $context == "minikube" && -z $(ps -ef | grep 'mini[k]ube') ]]; then
    colour="${PR_RED}"
  fi
  echo "${colour}[$context]${PR_NO_COLOR} "
}

# make some aliases for the colours: (coud use normal escap.seq's too)
for color in RED GREEN YELLOW BLUE MAGENTA CYAN WHITE; do
  eval PR_$color='%{$fg[${(L)color}]%}'
done
eval PR_NO_COLOR="%{$terminfo[sgr0]%}"
eval PR_BOLD="%{$terminfo[bold]%}"

# Check the UID
if [[ $UID -ge 1000 ]]; then # normal user
  eval PR_USER='${PR_GREEN}%n${PR_NO_COLOR}'
  eval PR_USER_OP='${PR_GREEN}%#${PR_NO_COLOR}'
  local PR_PROMPT='$PR_NO_COLOR>$PR_NO_COLOR'
elif [[ $UID -eq 0 ]]; then # root
  eval PR_USER='${PR_RED}%n${PR_NO_COLOR}'
  eval PR_USER_OP='${PR_RED}%#${PR_NO_COLOR}'
  local PR_PROMPT='$PR_RED>$PR_NO_COLOR'
fi
if [[ ${MY_SHELL_LEVEL:-0} -gt 1 ]]; then
  local PR_PROMPT="$PR_PROMPT [$(($MY_SHELL_LEVEL-1))]"
fi

# Check if we are on SSH or not
if [[ -n "$SSH_CLIENT"  ||  -n "$SSH2_CLIENT" ]]; then 
  eval PR_HOST='${PR_YELLOW}%m${PR_NO_COLOR}' #SSH
else
  eval PR_HOST='${PR_MAGENTA}%m${PR_NO_COLOR}' # no SSH
fi

local return_code="%(?..%{$PR_RED%}%? ↵%{$PR_NO_COLOR%})"

local mk_context='$(getMinikubeContext)'
local git_branch='$(limitGitBranch)%{$PR_NO_COLOR%}'
local user_host='${PR_USER}${PR_CYAN}@${PR_HOST}'
local current_dir='%{$PR_BOLD$PR_BLUE%}$(limitPath "$(print -P %~)" $COLUMNS "$(print -P @%m)" $(limitGitBranch))%{$PR_NO_COLOR%}'

PROMPT="╭─${mk_context}${git_branch}${current_dir}
╰─$PR_PROMPT "
RPS1="${return_code}"

ZSH_THEME_GIT_PROMPT_PREFIX="‹"
ZSH_THEME_GIT_PROMPT_SUFFIX="› "
