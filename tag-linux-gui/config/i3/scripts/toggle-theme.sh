#!/usr/bin/env bash
#
# Theme toggle script for i3
# Switches between light and dark themes across all applications
#
# Usage: toggle-theme.sh [light|dark]
#   If no argument provided, toggles between current and opposite theme

set -euo pipefail

# Paths
THEME_STATE_FILE="${XDG_CACHE_HOME:-$HOME/.cache}/i3/current-theme"
THEME_SCRIPT_DIR="$(dirname "$0")"
DOTFILES_DIR="$(git -C "$THEME_SCRIPT_DIR" rev-parse --show-toplevel 2>/dev/null || echo "$HOME/.dotfiles")"
I3_CONFIG_SOURCE="$DOTFILES_DIR/tag-linux-gui/config/i3/config"

# Ensure cache directory exists
mkdir -p "$(dirname "$THEME_STATE_FILE")"

# Colors for output
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly NC='\033[0m' # No Color

log_info() {
    echo -e "${BLUE}ℹ${NC} $*"
}

log_success() {
    echo -e "${GREEN}✓${NC} $*"
}

log_warning() {
    echo -e "${YELLOW}⚠${NC} $*"
}

log_error() {
    echo -e "${RED}✗${NC} $*"
}

# Get current theme or default to dark
get_current_theme() {
    if [[ -f "$THEME_STATE_FILE" ]]; then
        cat "$THEME_STATE_FILE"
    else
        echo "dark"
    fi
}

# Set new theme
set_theme() {
    local theme="$1"
    echo "$theme" > "$THEME_STATE_FILE"
    log_success "Theme state saved: $theme"
}

# Update i3 theme
update_i3_theme() {
    local theme="$1"
    local theme_file

    if [[ "$theme" == "light" ]]; then
        theme_file="$DOTFILES_DIR/tag-linux-gui/config/i3/themes/catpuccin-latte"
    else
        theme_file="$DOTFILES_DIR/tag-linux-gui/config/i3/themes/catpuccin-macchiato"
    fi

    if [[ -f "$theme_file" ]]; then
        # Update i3 config in dotfiles source (for rcup compatibility)
        if [[ -f "$I3_CONFIG_SOURCE" ]]; then
            # Escape slashes for sed
            local escaped_theme_file="${theme_file//\//\\/}"
            sed -i "s|^include .*themes/catpuccin-.*|include $theme_file|" "$I3_CONFIG_SOURCE"
            log_success "i3 theme updated (source): $theme"
            log_info "Updated: $I3_CONFIG_SOURCE"
        else
            log_warning "i3 config source not found: $I3_CONFIG_SOURCE"
        fi

        # Reload i3 (non-invasive)
        if command -v i3-msg &> /dev/null; then
            i3-msg reload &> /dev/null || true
            log_info "i3 reloaded"
        fi
    else
        log_warning "i3 theme file not found: $theme_file"
    fi
}

# Update kitty theme
update_kitty_theme() {
    local theme="$1"
    local kitty_theme_dir="$DOTFILES_DIR/config/kitty/themes"
    local kitty_current_source="$DOTFILES_DIR/config/kitty/current-theme.conf"
    local kitty_current_target="$HOME/.config/kitty/current-theme.conf"

    # Create themes directory if it doesn't exist
    mkdir -p "$kitty_theme_dir"

    # Define theme files
    local light_theme="$kitty_theme_dir/catppuccin-latte.conf"
    local dark_theme="$kitty_theme_dir/catppuccin-macchiato.conf"

    # Create light theme if it doesn't exist
    if [[ ! -f "$light_theme" ]]; then
        cat > "$light_theme" << 'EOF'
# Catppuccin Latte (Light)
foreground              #4C4F69
background              #EFF1F5
selection_foreground    #EFF1F5
selection_background    #DC8A78
cursor                  #DC8A78
cursor_text_color       #EFF1F5
url_color               #DC8A78
active_border_color     #7287FD
inactive_border_color   #9CA0B0
bell_border_color       #DF8E1D
active_tab_foreground   #EFF1F5
active_tab_background   #8839EF
inactive_tab_foreground #4C4F69
inactive_tab_background #9CA0B0
tab_bar_background      #BCC0CC
color0 #5C5F77
color8 #6C6F85
color1 #D20F39
color9 #D20F39
color2  #40A02B
color10 #40A02B
color3  #DF8E1D
color11 #DF8E1D
color4  #1E66F5
color12 #1E66F5
color5  #EA76CB
color13 #EA76CB
color6  #179299
color14 #179299
color7  #ACB0BE
color15 #BCC0CC
EOF
    fi

    # Create dark theme if it doesn't exist
    if [[ ! -f "$dark_theme" ]]; then
        cat > "$dark_theme" << 'EOF'
# Catppuccin Macchiato (Dark)
foreground              #CAD3F5
background              #24273A
selection_foreground    #24273A
selection_background    #F4DBD6
cursor                  #F4DBD6
cursor_text_color       #24273A
url_color               #F4DBD6
active_border_color     #B7BDF8
inactive_border_color   #6E738D
bell_border_color       #EED49F
active_tab_foreground   #24273A
active_tab_background   #B7BDF8
inactive_tab_foreground #CAD3F5
inactive_tab_background #363A4F
tab_bar_background      #181926
color0 #494D64
color8 #5B6078
color1 #ED8796
color9 #ED8796
color2  #A6DA95
color10 #A6DA95
color3  #EED49F
color11 #EED49F
color4  #8AADF4
color12 #8AADF4
color5  #C6A0F6
color13 #C6A0F6
color6  #8BD5CA
color14 #8BD5CA
color7  #B8C0E0
color15 #A5ADCB
EOF
    fi

    # Copy the appropriate theme to the dotfiles source (for rcup)
    local target_theme
    if [[ "$theme" == "light" ]]; then
        target_theme="$light_theme"
    else
        target_theme="$dark_theme"
    fi

    cp "$target_theme" "$kitty_current_source"
    log_success "kitty theme updated (source): $theme"

    # If the target is managed by rcup (symlink), it should already be synced
    # If not, copy to target as well for immediate effect
    if [[ ! -L "$kitty_current_target" && -d "$(dirname "$kitty_current_target")" ]]; then
        cp "$target_theme" "$kitty_current_target"
        log_info "Also updated: $kitty_current_target"
    fi

    # Signal running kitty instances to reload
    if command -v kitty &> /dev/null; then
        kitty @ set-colors --all --configured "$kitty_current_target" 2>/dev/null || true
        log_info "kitty reloaded"
    fi
}

# Update ghostty theme
update_ghostty_theme() {
    local theme="$1"
    local ghostty_config="$HOME/.config/ghostty/config"

    if [[ -f "$ghostty_config" ]]; then
        local ghostty_theme
        if [[ "$theme" == "light" ]]; then
            ghostty_theme="Spring"
        else
            ghostty_theme="Catppuccin Mocha"
        fi

        if [[ "$OSTYPE" == "darwin"* ]]; then
            sed -i '' "s/^theme = .*/theme = \"$ghostty_theme\"/" "$ghostty_config"
        else
            sed -i "s/^theme = .*/theme = \"$ghostty_theme\"/" "$ghostty_config"
        fi
        log_success "ghostty theme updated: $theme"

        # Ghostty requires manual reload or restart
        log_warning "ghostty requires manual reload (Ctrl+Shift+,)"
    fi
}

# Update wezterm theme (wezterm auto-detects, but we can override)
update_wezterm_theme() {
    local theme="$1"
    local wezterm_config="$HOME/.wezterm.lua"

    # Wezterm can auto-detect, but we can set environment variable for manual override
    if [[ "$theme" == "light" ]]; then
        export WEZTERM_THEME="light"
    else
        export WEZTERM_THEME="dark"
    fi

    # Add to shell profile for persistence
    local env_file="$HOME/.config/zsh/env.zsh"
    mkdir -p "$(dirname "$env_file")"
    echo "export WEZTERM_THEME=\"$theme\"" > "$env_file"

    log_success "wezterm theme preference set: $theme"
    log_info "wezterm may require reload (Ctrl+Shift+R)"
}

# Update neovim theme (for active instances)
update_nvim_theme() {
    local theme="$1"

    if command -v nvim &> /dev/null; then
        # Set background option for new instances
        local nvim_config_dir="$HOME/.config/nvim"
        local env_file="$nvim_config_dir/lua/config/theme.lua"

        mkdir -p "$(dirname "$env_file")"

        cat > "$env_file" << EOF
-- Auto-generated by toggle-theme.sh
local M = {
    theme = "$theme",
}

function M.set_background()
    if M.theme == "light" then
        vim.o.background = "light"
    else
        vim.o.background = "dark"
    end
end

return M
EOF

        log_success "neovim theme config updated: $theme"

        # Try to signal running nvim instances with named pipes
        local nvim_server="/tmp/nvimsocket"
        if [[ -S "$nvim_server" ]]; then
            if command -v nvim &> /dev/null; then
                nvim --server "$nvim_server" --remote-send ":set background=$theme<CR>" 2>/dev/null || true
                log_info "neovim background set: $theme"
            fi
        fi
    fi
}

# Update VS Code theme
update_vscode_theme() {
    local theme="$1"
    local vscode_settings="$HOME/.config/Code/User/settings.json"

    if [[ -f "$vscode_settings" ]]; then
        local vscode_theme
        if [[ "$theme" == "light" ]]; then
            vscode_theme="'Catppuccin Latte'"
        else
            vscode_theme="'Catppuccin Macchiato'"
        fi

        # Use jq to update JSON if available, otherwise use Python
        if command -v jq &> /dev/null; then
            jq --arg theme "$vscode_theme" '.["workbench.colorTheme"] = $theme' "$vscode_settings" > "${vscode_settings}.tmp" && \
                mv "${vscode_settings}.tmp" "$vscode_settings"
        elif command -v python3 &> /dev/null; then
            python3 << EOF
import json
try:
    with open('$vscode_settings', 'r') as f:
        settings = json.load(f)
    settings['workbench.colorTheme'] = $vscode_theme
    with open('$vscode_settings', 'w') as f:
        json.dump(settings, f, indent=2)
except Exception as e:
    print(f"Warning: Could not update VS Code settings: {e}")
EOF
        fi
        log_success "VS Code theme updated: $theme"
    fi
}

# Update GTK theme (for Thunar and other GTK apps)
update_gtk_theme() {
    local theme="$1"

    if command -v gsettings &> /dev/null; then
        local gtk_theme
        local color_scheme

        if [[ "$theme" == "light" ]]; then
            gtk_theme="Catppuccin-Latte-Standard-Blue-Light"
            color_scheme="default"
        else
            gtk_theme="Catppuccin-Macchiato-Standard-Blue-Dark"
            color_scheme="prefer-dark"
        fi

        gsettings set org.gnome.desktop.interface gtk-theme "$gtk_theme" 2>/dev/null || true
        gsettings set org.gnome.desktop.interface color-scheme "$color_scheme" 2>/dev/null || true
        log_success "GTK theme updated: $theme"
    fi
}

# Send notification
send_notification() {
    local theme="$1"
    local icon
    local message

    if [[ "$theme" == "light" ]]; then
        icon="preferences-color-symbolic"
        message="Switched to light theme"
    else
        icon="preferences-color-symbolic"
        message="Switched to dark theme"
    fi

    if command -v notify-send &> /dev/null; then
        notify-send -i "$icon" "Theme Switch" "$message" 2>/dev/null || true
    fi
}

# Main toggle logic
toggle_theme() {
    local current_theme
    local new_theme

    # Determine new theme
    if [[ -n "${1:-}" ]]; then
        new_theme="$1"
        current_theme="$(get_current_theme)"
    else
        current_theme="$(get_current_theme)"
        if [[ "$current_theme" == "light" ]]; then
            new_theme="dark"
        else
            new_theme="light"
        fi
    fi

    # Validate theme
    if [[ "$new_theme" != "light" && "$new_theme" != "dark" ]]; then
        log_error "Invalid theme: $new_theme. Use 'light' or 'dark'."
        exit 1
    fi

    # Skip if already set to this theme (when explicit argument provided)
    if [[ -n "${1:-}" && "$current_theme" == "$new_theme" ]]; then
        log_info "Already using $new_theme theme"
        exit 0
    fi

    log_info "Switching theme: $current_theme → $new_theme"
    echo ""

    # Update all applications
    update_i3_theme "$new_theme"
    update_kitty_theme "$new_theme"
    update_ghostty_theme "$new_theme"
    update_wezterm_theme "$new_theme"
    update_nvim_theme "$new_theme"
    update_vscode_theme "$new_theme"
    update_gtk_theme "$new_theme"

    # Save theme state
    set_theme "$new_theme"

    # Send notification
    send_notification "$new_theme"

    echo ""
    log_success "Theme switch complete: $new_theme"
}

# Show usage
show_usage() {
    cat << EOF
Usage: $(basename "$0") [light|dark]

Switch between light and dark themes across all configured applications.

Arguments:
  light    Switch to light theme
  dark     Switch to dark theme
  (none)   Toggle between current and opposite theme

Applications configured:
  - i3 window manager
  - kitty terminal
  - ghostty terminal
  - wezterm terminal
  - neovim editor
  - VS Code editor
  - GTK applications (Thunar, etc.)

Current theme: $(get_current_theme)

EOF
}

# Parse arguments
case "${1:-}" in
    light|dark)
        toggle_theme "$1"
        ;;
    -h|--help)
        show_usage
        ;;
    "")
        toggle_theme
        ;;
    *)
        log_error "Unknown option: $1"
        show_usage
        exit 1
        ;;
esac
