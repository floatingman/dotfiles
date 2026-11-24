#!/usr/bin/env bash
# Rofi theme picker: front-end for ~/.local/bin/theme
# Usage: theme-picker.sh                   (rofi menu with palette swatches)
#        theme-picker.sh <theme> <mode>    (direct apply, e.g. "theme-picker.sh nord dark")
#        theme-picker.sh -f <theme> <mode> (re-apply even if it is the current theme)
#
# Picker ideas from butter's thememenu (justaguy.dev/butter/i3): every row
# previews the theme's real palette, the current theme is preselected and
# marked in the message line, and picking it again is a no-op instead of a
# pointless reload.

set -euo pipefail

THEME_STATE="${XDG_CACHE_HOME:-$HOME/.cache}/i3/current-theme"
I3_CONFIG="$HOME/.config/i3/config"

# display name|theme mode args|i3 theme file (swatch source; the config's
# include line points at it while that combo is active)
entries=(
    "GitHub Light Dim|github light|$HOME/.config/i3/themes/github-light-dim"
    "GitHub Dark|github dark|$HOME/.config/i3/dark-themes/github-dark"
    "Gruvbox Light|gruvbox light|$HOME/.config/i3/themes/gruvbox-light"
    "Gruvbox Dark|gruvbox dark|$HOME/.config/i3/dark-themes/gruvbox-dark"
    "Nord Light|nord light|$HOME/.config/i3/themes/nord-light"
    "Nord Dark|nord dark|$HOME/.config/i3/dark-themes/nord-dark"
    "Aura|aura dark|$HOME/.config/i3/dark-themes/aura"
    "Butterbox|butterbox dark|$HOME/.config/i3/dark-themes/butterbox"
    "Catppuccin|catppuccin dark|$HOME/.config/i3/dark-themes/catppuccin"
    "Dracula|dracula dark|$HOME/.config/i3/dark-themes/dracula"
    "Eldritch|eldritch dark|$HOME/.config/i3/dark-themes/eldritch"
    "Everforest|everforest dark|$HOME/.config/i3/dark-themes/everforest"
    "Kanagawa|kanagawa dark|$HOME/.config/i3/dark-themes/kanagawa"
    "Monokai|monokai dark|$HOME/.config/i3/dark-themes/monokai"
    "Moonfly|moonfly dark|$HOME/.config/i3/dark-themes/moonfly"
    "Retro|retro dark|$HOME/.config/i3/dark-themes/retro"
    "Rose Pine Moon|rose-pine dark|$HOME/.config/i3/dark-themes/rose-pine"
    "Tokyo Night|tokyo-night dark|$HOME/.config/i3/dark-themes/tokyo-night"
)

apply() {
    local theme="$1" mode="$2" label="${3:-$1 $2}"
    ~/.local/bin/theme "$theme" "$mode"
    # Live-reload running kitty instances (same mechanism as toggle-theme.sh)
    if pgrep -x kitty > /dev/null; then
        killall -USR1 kitty 2>/dev/null || true
    fi
    echo "$mode" > "$THEME_STATE"
    if command -v notify-send &> /dev/null; then
        notify-send "Theme" "Switched to $label"
    fi
}

# basename of the file the config's include line points at, e.g. "nord-light";
# this is the ground truth for the active combo, not the mode-only state file
current_file=$(sed -n 's|^include .*/||p' "$I3_CONFIG" | head -n1)

# row FILE LABEL — pango row: the theme's border/background/text/indicator
# colors from its client.focused line as swatch dots, then the display name
row() {
    local border bg text indicator
    read -r border bg text indicator _ < <(awk '$1 == "client.focused" { print $2, $3, $4, $5; exit }' "$1")
    printf '<span background="%s"> <span foreground="%s">●</span> <span foreground="%s">●</span> <span foreground="%s">●</span> </span>  %s' \
        "${bg:-#888888}" "${border:-#aaaaaa}" "${text:-#eeeeee}" "${indicator:-#666666}" "$2"
}

# pick — show the menu; print the picked theme file, or return 1 on Esc/empty
pick() {
    local entry label args file i=0 sel=-1 current_label="" index
    local -a rows=() files=()
    for entry in "${entries[@]}"; do
        IFS='|' read -r label args file <<< "$entry"
        files+=("$file")
        rows+=("$(row "$file" "$label")")
        if [ "$(basename "$file")" = "$current_file" ]; then
            sel=$i
            current_label=$label
        fi
        i=$((i + 1))
    done
    if [ -z "$current_label" ]; then
        # active i3 theme is one of the non-picker ones (catppuccin etc.)
        current_label="$current_file"
    fi

    # One column with all 18 rows: config.rasi sets lines:5, columns:2 and a
    # 360px window, which would wrap entries into a second column
    local -a rofi_flags=(-dmenu -i -markup-rows -no-custom -format i -p "Theme"
        -mesg "Current: $current_label"
        -theme-str "window { width: 620px; height: 850px; } listview { columns: 1; lines: 18; }")
    if [ "$sel" -ge 0 ]; then
        rofi_flags+=(-selected-row "$sel" -a "$sel")
    fi

    index=$(printf '%s\n' "${rows[@]}" | rofi "${rofi_flags[@]}" || true)
    [ -n "$index" ] || return 1
    echo "${files[$index]}"
}

# resolve FILE — print "label|args" for the entry whose i3 file matches
resolve() {
    local entry label args file
    for entry in "${entries[@]}"; do
        IFS='|' read -r label args file <<< "$entry"
        if [ "$file" = "$1" ]; then
            echo "$label|$args"
            return 0
        fi
    done
    return 1
}

force=false
if [ "${1:-}" = "-f" ]; then
    force=true
    shift
fi

if [ $# -eq 2 ]; then
    args="$1 $2"
    label="$args"
    picked_file="unknown"  # unknown combos fall through to theme's own validation
    for entry in "${entries[@]}"; do
        IFS='|' read -r l a f <<< "$entry"
        if [ "$a" = "$args" ]; then
            label=$l
            picked_file=$f
            break
        fi
    done
else
    picked_file=$(pick) || exit 0
    meta=$(resolve "$picked_file")
    IFS='|' read -r label args <<< "$meta"
fi

# already current: no-op, skips the switch and the i3 reload flicker
if [ "$force" = false ] && [ "$(basename "$picked_file")" = "$current_file" ]; then
    if command -v notify-send &> /dev/null; then
        notify-send -u low -t 1500 "Theme" "Already using $label"
    fi
    exit 0
fi

# shellcheck disable=SC2086  # intentional word-split: "nord dark" -> theme mode
apply $args "$label"
