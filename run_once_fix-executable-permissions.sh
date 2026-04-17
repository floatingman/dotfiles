#!/bin/sh
# Fix executable permissions that chezmoi may not preserve
chmod +x "$HOME/.claude/hooks/rtk-rewrite.sh" 2>/dev/null
# Make all scripts in ~/.local/bin executable (except README)
find "$HOME/.local/bin" -maxdepth 1 -type f ! -name 'README.md' -exec chmod +x {} + 2>/dev/null
