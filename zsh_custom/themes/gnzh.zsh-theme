# ZSH Theme - Preview: http://dl.dropbox.com/u/4109351/pics/gnzh-zsh-theme.png
# Based on bira theme

# load some modules
autoload -U colors zsh/terminfo # Used in the colour alias below
colors
setopt prompt_subst

function limitStringToWidthByMidpoint
{
  local string="$1"
  local width=$2
  if (( ${#string} > $width )); then
    local splitnum=$((width/2))
    echo "$(echo $string | cut -c1-$splitnum) ... $(echo $string | cut -c$((${#string}-$splitnum))-)"
  else
    echo $string
  fi
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
  eval PR_HOST='${PR_GREEN}%m${PR_NO_COLOR}' # no SSH
fi

local return_code="%(?..%{$PR_RED%}%? ↵%{$PR_NO_COLOR%})"

local git_branch='$(git_prompt_info)%{$PR_NO_COLOR%}'
local user_host='${PR_USER}${PR_CYAN}@${PR_HOST}'
local prompty_stuff_so_far="$(git_prompt_info)$(print -P %n)$(print -P %m)"
local len_so_far=$((${#prompty_stuff_so_far}+20))
local current_dir='%{$PR_BOLD$PR_BLUE%}$(limitStringToWidthByMidpoint "$(print -P %~)" $((COLUMNS-$len_so_far)))%{$PR_NO_COLOR%}'

#PROMPT="${user_host} ${current_dir} ${rvm_ruby} ${git_branch}$PR_PROMPT "
PROMPT="╭─${user_host} ${current_dir} ${git_branch}
╰─$PR_PROMPT "
RPS1="${return_code}"

ZSH_THEME_GIT_PROMPT_PREFIX="%{$PR_YELLOW%}‹"
ZSH_THEME_GIT_PROMPT_SUFFIX="› %{$PR_NO_COLOR%}"
