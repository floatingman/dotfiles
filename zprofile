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
