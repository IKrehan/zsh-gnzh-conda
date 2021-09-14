# Based on bira theme

setopt prompt_subst

() {

local PR_USER PR_USER_OP PR_PROMPT PR_HOST

# Check the UID
if [[ $UID -ne 0 ]]; then # normal user
  PR_USER='%F{green}%n%f'
  PR_USER_OP='%F{green}%#%f'
  PR_PROMPT='%f➤ %f'
else # root
  PR_USER='%F{red}%n%f'
  PR_USER_OP='%F{red}%#%f'
  PR_PROMPT='%F{red}➤ %f'
fi

# Conda info
local conda_info='$(conda_prompt_info)'
conda_prompt_info() {
  if [ -n "$CONDA_DEFAULT_ENV" ]; then
    echo -n "($CONDA_DEFAULT_ENV)"
  else
    # Check if we are on SSH or not
    if [[ -n "$SSH_CLIENT"  ||  -n "$SSH2_CLIENT" ]]; then
      echo -n '%F{red}%M%f' # SSH
    else
      echo -n '%F{green}%M%f' # no SSH
    fi
  fi
}

# virtualenv info
local virtualenv_info='$(virtualenv_prompt_info)'
virtualenv_prompt_info() {
  if [ -n "$VIRTUAL_ENV" ]; then
    VIRTUAL_ENV_NAME=`basename $VIRTUAL_ENV`
    echo -n "($VIRTUAL_ENV_NAME) "
  fi
}

local return_code="%(?..%F{red}%? ↵%f)"

local user_host="${PR_USER}%F{cyan}@${conda_info}${virtualenv_info}"
local current_dir="%B%F{blue}%~%f%b"
local git_branch='$(git_prompt_info)'

PROMPT="╭─${user_host} ${current_dir} \$(ruby_prompt_info) ${git_branch}
╰─$PR_PROMPT "
RPROMPT="${return_code}"

ZSH_THEME_GIT_PROMPT_PREFIX="%F{yellow}‹"
ZSH_THEME_GIT_PROMPT_SUFFIX="› %f"
ZSH_THEME_RUBY_PROMPT_PREFIX="%F{red}‹"
ZSH_THEME_RUBY_PROMPT_SUFFIX="›%f"

}