#!/bin/zsh
# vim :set ts=2 sw=2 sts=2 et :

# Initialise asdf-vm
#
# Only take over when a user-local install actually exists. Machines using the
# shared /opt/asdf install set ASDF_DIR/ASDF_DATA_DIR in /etc/zsh/zshrc and
# /etc/profile.d/asdf.sh; clobbering those here makes every asdf shim
# (node, npm, pi, ...) fail with rc=126 because ~/.asdf has no plugins.
if [ -d "${HOME}/.asdf" ] && (( $+commands[asdf] )); then
    export ASDF_DATA_DIR="${HOME}/.asdf"
    export PATH="$ASDF_DATA_DIR/shims:$PATH"
fi
