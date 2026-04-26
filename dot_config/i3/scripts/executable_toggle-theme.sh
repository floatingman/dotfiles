#!/usr/bin/env bash
# Simple theme toggle using new theme system
# Usage: toggle-theme.sh [light|dark|toggle]

THEME_STATE="${XDG_CACHE_HOME:-$HOME/.cache}/i3/current-theme"
LIGHT_THEME="github"  # Winner of daylight testing
DARK_THEME="github"

# Get current theme
get_current() {
    if [[ -f "$THEME_STATE" ]]; then
        cat "$THEME_STATE"
    else
        echo "dark"
    fi
}

# Determine target theme
case "${1:-toggle}" in
    light)
        target="light"
        ;;
    dark)
        target="dark"
        ;;
    toggle)
        current=$(get_current)
        if [[ "$current" == "light" ]]; then
            target="dark"
        else
            target="light"
        fi
        ;;
    *)
        echo "Usage: $0 [light|dark|toggle]"
        exit 1
        ;;
esac

# Use new theme switcher
~/.local/bin/theme $LIGHT_THEME $target

# Reload kitty (send signal to all instances)
if pgrep -x kitty > /dev/null; then
    killall -USR1 kitty 2>/dev/null || true
fi

# Save state
echo "$target" > "$THEME_STATE"

# Notify
if command -v notify-send &> /dev/null; then
    notify-send "Theme" "Switched to $target theme
Wezterm: Ctrl+Shift+R"
fi
