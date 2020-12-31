#!/bin/sh

if hash antibody 2> /dev/null; then
    antibody bundle < ~/.dotfiles/zsh_plugins.txt > ~/.zsh_plugins.sh
fi
