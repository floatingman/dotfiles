# Theme Switching for i3

## Overview

This system provides unified theme switching across all your applications with a single keybinding.

## Keybindings

- **`$mod+Shift+t`** - Toggle between light and dark themes
- **`$mod+Shift+[`** - Switch to dark theme
- **`$mod+Shift+]`** - Switch to light theme

## Supported Applications

| Application | Status | Notes |
|------------|--------|-------|
| **i3 WM** | ✅ Full | Colors, borders, bar |
| **kitty** | ✅ Full | Live reload via RPC |
| **ghostty** | ⚠️ Partial | Manual reload required (Ctrl+Shift+,) |
| **wezterm** | ⚠️ Partial | Sets preference, manual reload (Ctrl+Shift+R) |
| **neovim** | ✅ Full | Background setting + named pipe signaling |
| **VS Code** | ✅ Full | Settings.json update |
| **GTK apps** (Thunar) | ✅ Full | gsettings theme change |

## How It Works

1. **State Storage**: Current theme stored in `~/.cache/i3/current-theme`
2. **Script Execution**: Toggle script updates all application configs
3. **Live Reload**: Apps that support RPC get immediate updates
4. **Persistent Changes**: Configs updated so new windows use correct theme

## Manual Usage

```bash
# Toggle theme
~/.config/i3/scripts/toggle-theme.sh

# Set specific theme
~/.config/i3/scripts/toggle-theme.sh light
~/.config/i3/scripts/toggle-theme.sh dark

# Show help
~/.config/i3/scripts/toggle-theme.sh --help
```

## Theme Locations

- **i3**: `~/.dotfiles/tag-linux-gui/config/i3/themes/catpuccin-{latte,macchiato}`
- **kitty**: `~/.dotfiles/config/kitty/themes/catppuccin-{latte,macchiato}.conf`
- **kitty active**: `~/.config/kitty/current-theme.conf`
- **ghostty**: `~/.config/ghostty/config` (theme = "...")
- **neovim**: `~/.config/nvim/lua/config/theme.lua`

## Adding More Applications

To add support for additional applications, edit `toggle-theme.sh` and add a function:

```bash
update_myapp_theme() {
    local theme="$1"
    # Your app's theme switching logic here
    log_success "myapp theme updated: $theme"
}
```

Then call it from the `toggle_theme()` function.

## Troubleshooting

### kitty doesn't update live
Make sure `allow_remote_control yes` is in your kitty.conf.

### neovim doesn't update in existing sessions
The script tries to use `/tmp/nvimsocket` for signaling. If you use a different socket path, update the script.

### GTK apps don't change
Make sure you have the Catppuccin GTK themes installed:
```bash
# Check available themes
ls /usr/share/themes | grep -i catppuccin

# Install if needed (varies by distro)
```

### ghostty/wezterm require manual reload
These terminals don't support runtime theme changes via RPC. Use the indicated keybindings to reload configs.

## Default Theme

The default theme is **dark** (Catppuccin Macchiato). This is set when:
- First run
- State file is missing
- Theme state is corrupted

## Requirements

- `bash` 4.0+
- `notify-send` (optional, for notifications)
- `gsettings` (for GTK themes)
- `nvim` (optional, for neovim support)
- `jq` or `python3` (for VS Code support)

## License

Same as your dotfiles repository.
