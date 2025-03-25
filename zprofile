#!/bin/zsh

source ~/.profile

# Ensure path arrays do not contain duplicates.
typeset -gU cdpath fpath mailpath path


# if [ -d "$HOME/.pyenv" ]; then
#   # Add pyenv to path if installed via Git
#   if ! command -v pyenv >/dev/null; then
#     export PYENV_ROOT="$HOME/.pyenv"
#     export PATH="$PYENV_ROOT/bin:$PATH"
#   fi
#   eval "$(pyenv init --path)"
# fi

if [ -d "/opt/homebrew" ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [ -d "~/.linuxbrew" ]; then
  eval "$(~/.linuxbrew/bin/brew shellenv)"
elif [ -d "/home/linuxbrew" ]; then
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

