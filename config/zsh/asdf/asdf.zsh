#!/bin/zsh
# vim :set ts=2 sw=2 sts=2 et :

# Initialise asdf-vm
if [ -e "/usr/bin/asdf" ]; then
    export ASDF_DATA_DIR="${HOME}/.asdf"
    export PATH="$ASDF_DATA_DIR/shims:$PATH"
fi
