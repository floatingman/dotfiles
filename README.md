# Dotfiles

Machine-specific dotfiles managed with [Chezmoi](https://www.chezmoi.io).

## Features

**Cross-platform** (works everywhere):
- Shell: Zsh framework with Starship prompt
- Editors: Neovim (LazyVim), Vim
- Terminal: Tmux, Yazi file manager
- CLI tools: Atuin shell history, Git configs

**Linux desktop** (GUI apps only):
- Window managers: i3, bspwm, Awesome
- Bars: Polybar, Waybar
- Launchers: Rofi, Fuzzel, Wofi
- Notifications: Dunst
- Themes: Gruvbox (light/dark), theme switching scripts
- Media: MPV, CMus
- Display: Autorandr (multi-monitor configs)

**macOS** (Mac-specific):
- Input: Karabiner key remapping

**Terminal emulators** (desktop only):
- Kitty, Ghostty, Alacritty, Wezterm

## Installation

### Prerequisites

```bash
# Install chezmoi
# macOS
brew install chezmoi

# Arch Linux
pacman -S chezmoi

# Other Linux
cargo install chezmoi
```

### Quick Start

```bash
# Clone repository (replace with your fork)
git clone https://github.com/floatingman/dotfiles.git ~/.dotfiles
cd ~/.dotfiles

# Initialize chezmoi
chezmoi init --apply

# Or use encrypted dotfiles (optional)
# chezmoi init
# chezmoi generate
# chezmoi apply
```

### First-time Setup

1. **Install chezmoi** (see Prerequisites above)
2. **Clone repository** to `~/.dotfiles` or any location
3. **Initialize chezmoi:**
   ```bash
   chezmoi init --apply
   ```
   This automatically:
   - Installs all configs
   - Clones git submodules (LazyVim, tmux)
   - Sets up symlinks
4. **Reload shell:** `source ~/.zshrc`

**That's it!** Everything is configured automatically.

### Claude Code Configuration (Optional)

If you use Claude Code with custom hooks and settings:

```bash
# Auto-detects Claude and sets up if found (skips if not detected)
make claude

# Force setup even if Claude not detected
make claude-force

# Set your API credentials (add to ~/.zshrc)
export ANTHROPIC_AUTH_TOKEN='your-token'
export ANTHROPIC_BASE_URL='https://api.z.ai/api/anthropic'

# Apply the template
chezmoi apply
```

The setup script automatically detects if Claude Code is installed and skips setup if not found.

See [CLAUDE_SETUP.md](CLAUDE_SETUP.md) for details.

## Machine-Specific Configurations

Configs are automatically filtered based on:

- **Operating system:** Linux, macOS, Windows
- **Desktop environment:** Desktop vs headless Linux
- **Display detection:** Checks for i3, gnome-shell, plasma-shell, Hyprland

### What Installs Where

| Config type | Desktop Linux | Headless Linux | macOS | Windows |
|-------------|---------------|----------------|-------|---------|
| **CLI apps** | ✅ | ✅ | ✅ | ✅ |
| **Window managers** | ✅ | ❌ | ❌ | ❌ |
| **Terminal emulators** | ✅ | ✅ | ✅ | ❌ |
| **Media apps** | ✅ | ❌ | ❌ | ❌ |
| **Mac-specific** | ❌ | ❌ | ✅ | ❌ |

**CLI apps:** Neovim, Tmux, Yazi, Zsh, Starship, Atuin, Git, etc.

**Desktop apps:** i3, Polybar, Rofi, Kitty, MPV, Autorandr, etc.

## Theme Switching

Toggle between Gruvbox dark/light themes:

```bash
~/.config/i3/scripts/toggle-theme.sh light
~/.config/i3/scripts/toggle-theme.sh dark
```

Updates all supported apps:
- Window manager (i3)
- Terminal emulators (Kitty, Wezterm)
- Editor (Neovim)
- Shell prompt (Starship)
- File manager (Yazi)

## Git Submodules

Chezmoi automatically manages git submodules:

- **Neovim:** [LazyVim](https://github.com/floatingman/LazyVim)
- **Tmux:** [gpakosz/tmux.plugin](https://github.com/gpakosz/tmux-plugin-manager)

Submodules are auto-initialized during `chezmoi init`. No manual git commands needed.

**To update submodules** (optional, when you want latest upstream):
```bash
cd ~/.local/share/chezmoi  # chezmoi source directory
git submodule update --remote --recursive
```

## Structure

```
~/.local/share/chezmoi/
├── dot_config/          # Application configs
│   ├── nvim/            # Cross-platform
│   ├── tmux/            # Cross-platform
│   ├── i3/              # Linux desktop only
│   ├── karabiner/       # macOS only
│   └── ...
├── dot_zshrc             # Zsh configuration
├── dot_zsh/              # Zsh framework
└── .chezmoiignore       # Platform filtering rules
```

## Chezmoi Management

**Apply all configs:**
```bash
chezmoi apply
```

**Apply specific config:**
```bash
chezmoi apply ~/.config/nvim
```

**Check what would change:**
```bash
chezmoi apply --dry-run
```

**Edit a file:**
```bash
chezmoi edit ~/.config/nvim/init.lua
```

**See all managed files:**
```bash
chezmoi managed
```

## Migration from RCM

Previously managed with [RCM](https://thoughtbot.github.io/rcm). Migrated to Chezmoi for:
- Better platform-specific filtering
- Template support
- Built-in encryption
- Active development

**RCM tag structure removed** - replaced with `.chezmoiignore` template-based filtering.

## Troubleshooting

**Desktop configs not installing on headless server?**
- Expected behavior - GUI apps excluded from servers
- Check desktop detection: `ls /usr/bin/i3 /usr/bin/gnome-shell`

**Configs not updating?**
- Run `chezmoi apply` after pulling changes
- Check source directory: `chezmoi source-path`

**Theme switching broken?**
- Ensure scripts have execute permissions
- Check state file: `cat ~/.cache/i3/current-theme`

**Submodules not loading?**
- Should be automatic - re-run `chezmoi init --apply`
- Verify in chezmoi source: `cd ~/.local/share/chezmoi && git submodule status`
- Check external markers: `ls dot_config/nvim.external dot_config/tmux.external`

## License

MIT © floatingman
