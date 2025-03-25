[ -f "$HOME/.profile" ] && source "$HOME/.profile"

[ -f "$HOME/.bashrc" ] && source "$HOME/.bashrc"

# Added by LM Studio CLI (lms)
[[ -d "$HOME/.lmstudio/bin" ]] && export PATH="$PATH:$HOME/.lmstudio/bin"
