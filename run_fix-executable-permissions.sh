#!/bin/sh
# Fix executable permissions that chezmoi may not preserve from submodules
chmod +x "$HOME/.claude/hooks/rtk-rewrite.sh" 2>/dev/null
