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
# Clone and install in one command
chezmoi init --apply git@github.com:floatingman/dotfiles.git
```

That's it! Everything is configured automatically.

### First-time Setup Details

The `chezmoi init --apply` command:
1. Clones this repository to `~/.local/share/chezmoi` (chezmoi's source directory)
2. Executes `.chezmoi.toml.tmpl` to generate `~/.config/chezmoi/chezmoi.toml` (see [Chezmoi Configuration](#chezmoi-configuration) below)
3. Downloads external dependencies (submodules)
4. Generates all config files in your home directory

After installation:
```bash
# Reload shell
source ~/.zshrc
```

### Chezmoi Configuration

Chezmoi's own config lives at `~/.config/chezmoi/chezmoi.toml`. It is **not** a
managed dotfile — chezmoi reads it on startup, so it can't be managed like the
rest. Instead it is generated from a template committed to this repo:

> **`.chezmoi.toml.tmpl`** (in the source root)

When you run `chezmoi init`, chezmoi executes this template and writes the
result to `~/.config/chezmoi/chezmoi.toml`. The template sets:

- `[merge]`, `[diff]`, `[add]` — tool preferences (nvim for merges, the `delta`
  pager, follow symlinks when adding)
- `[data]` — variables consumed by other templates (e.g.
  `dot_claude/settings.json.tmpl` reads `.anthropic.token` and
  `.claude.api_timeout_ms`)

#### Secrets handling

The Anthropic token is **never committed**. The template resolves
`data.anthropic.token` at `chezmoi init` time, in this order:

1. `ANTHROPIC_AUTH_TOKEN` environment variable (preferred), then
2. an interactive prompt, cached in chezmoi's local state
   (`~/.config/chezmoi/chezmoistate.boltdb` — local only, never in the repo)

Leaving it blank defers to `ANTHROPIC_AUTH_TOKEN` at `chezmoi apply` time, which
the downstream templates handle gracefully.

#### Regenerating / rotating the config

`promptStringOnce` only runs during `chezmoi init`, so the generated config only
updates when you re-init:

```bash
# Write the regenerated config to ~/.config/chezmoi/chezmoi.toml
chezmoi init

# Re-prompt for a cached value (e.g. to rotate the token), then regenerate
chezmoi state delete --bucket=configState --key=anthropic.token
chezmoi init
```

> Only files named `.chezmoi.<format>.tmpl` (e.g. `.chezmoi.toml.tmpl`) are read
> by `chezmoi init`. A plain `.chezmoi.toml` in the source root is ignored.

### New Machine Bootstrap

`chezmoi init --apply` generates `~/.config/chezmoi/chezmoi.toml` from
`.chezmoi.toml.tmpl` automatically (see [Chezmoi Configuration](#chezmoi-configuration)).
You should only need the manual fallback below if `chezmoi apply` fails with
template errors (e.g., `map has no entry for key "claude"`), meaning the config
data isn't being loaded:

```bash
# Option 1: Re-init (recommended)
chezmoi init --apply git@github.com:floatingman/dotfiles.git

# Option 2: Manually create config with data section
mkdir -p ~/.config/chezmoi
cat > ~/.config/chezmoi/chezmoi.toml << 'EOF'
[data]
  [data.anthropic]
    token = ""

  [data.claude]
    api_timeout_ms = "3000000"
EOF
chezmoi apply
```

The templates are defensive — they work with empty data and fall back to environment variables. But you need *some* config file for chezmoi to process templates correctly.

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

The Claude Code configuration is managed as an [external](https://www.chezmoi.io/user-guide/include-files-from-elsewhere/) git repository, automatically cloned to `dot_claude/` in chezmoi's source directory.

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

## External Dependencies

Configurations are managed from external repositories using chezmoi's [external](https://www.chezmoi.io/user-guide/include-files-from-elsewhere/) functionality:

- **Neovim:** [LazyVim](https://github.com/floatingman/lazyvim) - Updated weekly
- **Tmux:** [tmux-plugin-manager](https://github.com/gpakosz/tmux-plugin-manager) - Updated weekly
- **Claude Config:** [Private settings](https://github.com/floatingman/claude-config) - Updated weekly

Externals are automatically cloned to `~/.local/share/chezmoi/` and refreshed weekly (or manually with `chezmoi apply -R`).

**To update externals:**
```bash
# Via Makefile
make update

# Or manually (with force refresh)
chezmoi apply --refresh-externals
```

## Structure

```
~/.local/share/chezmoi/          # Source directory (your dotfiles repo)
├── dot_config/                    # Application configs
│   ├── nvim/                      # Neovim (external: lazyvim)
│   ├── tmux/                      # Tmux (external: tpm)
│   ├── i3/                        # Linux desktop only
│   ├── karabiner/                 # macOS only
│   └── ...
├── dot_zshrc                       # Zsh configuration
├── dot_zsh/                        # Zsh framework
├── dot_claude/                     # Claude Code (external: claude-config)
├── .chezmoi.toml.tmpl             # Template → ~/.config/chezmoi/chezmoi.toml (see Chezmoi Configuration)
├── .chezmoiexternal.toml          # External repo definitions
└── .chezmoiignore                 # Per-target ignore rules
```

## Daily Operations

All chezmoi operations are available via `make` for convenience:

```bash
make update      # Pull latest + apply (recommended workflow)
make apply       # Apply templates without pulling
make status       # See what's managed
make diff        # Preview changes before applying
```

### File Management

```bash
make add FILE=~/.zshrc              # Track new file
make edit FILE=~/.config/nvim/init.lua  # Edit in chezmoi source
```

### Maintenance

```bash
make doctor      # Check chezmoi health
make verify      # Check for uncommitted changes
make clean       # Remove all managed files (with confirmation)
```

### Direct Chezmoi Commands (Advanced)

If you prefer direct chezmoi commands (not required with Makefile):

```bash
# Apply all configs
chezmoi apply

# Apply specific config
chezmoi apply ~/.config/nvim

# Check what would change
chezmoi diff

# Edit a file
chezmoi edit ~/.config/nvim/init.lua

# See all managed files
chezmoi managed

# Enter source directory (for git operations)
chezmoi cd
git pull
git status
```

## Chezmoi Workflow

The proper chezmoi workflow for development:

1. **Edit source files:**
   ```bash
   chezmoi edit ~/.zshrc    # Opens file in source directory
   # Make your changes, save and exit
   ```

2. **Apply changes:**
   ```bash
   chezmoi apply ~/.zshrc   # Apply single file
   chezmoi apply             # Apply all changes
   ```

3. **Commit and push:**
   ```bash
   make commit              # Or: chezmoi cd && git commit
   make push                # Or: chezmoi cd && git push
   ```

4. **Pull on other machines:**
   ```bash
   chezmoi update            # Pull + apply in one command
   ```

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

**External repos not updating?**
- Check external definitions: `cat ~/.local/share/chezmoi/.chezmoiexternal.toml`
- Force refresh: `chezmoi apply -R`

**Template errors on new machine (`map has no entry for key`)?**
- Chezmoi needs config data before processing templates
- Re-run: `chezmoi init --apply git@github.com:floatingman/dotfiles.git`
- Or create `~/.config/chezmoi/chezmoi.toml` with `[data]` section (see New Machine Bootstrap above)

**Claude Code config not found?**
- Check external was cloned: `ls ~/.local/share/chezmoi/dot_claude/settings.json.tmpl`
- Force refresh: `chezmoi apply -R`

## License

MIT © floatingman
