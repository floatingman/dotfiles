# Dotfiles

Machine-specific dotfiles managed with [Chezmoi](https://www.chezmoi.io).

## Features

**Cross-platform** (works everywhere):
- Shell: Zsh framework with Starship prompt
- Editors: Neovim (LazyVim), Vim
- Terminal: Tmux, Yazi file manager
- CLI tools: Atuin shell history, Git configs
- AI coding: [pi-agent](https://github.com/earendil-works/pi-coding-agent) config + skills (conditional — see [pi-agent Configuration](#pi-agent-configuration-optional))

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
3. Checks out git submodules (Neovim, Tmux, bin)
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
- `[data]` — per-machine variables consumed by templates and conditional rules:
  - `anthropic.token` / `claude.api_timeout_ms` — API credentials/timeouts
    (defined for reuse; no managed template currently consumes them)
  - `pi.enabled` — gates the [pi-agent config](#pi-agent-configuration-optional)
    (prompted once per machine; when `false`, the pi symlinks and clone script
    are skipped via `.chezmoiignore`)

#### Secrets handling

The Anthropic token is **never committed**. The template resolves
`data.anthropic.token` at `chezmoi init` time, in this order:

1. `ANTHROPIC_AUTH_TOKEN` environment variable (preferred), then
2. an interactive prompt, cached in chezmoi's local state
   (`~/.config/chezmoi/chezmoistate.boltdb` — local only, never in the repo)

Leaving it blank is harmless — no managed template currently consumes
`data.anthropic.token` (it's retained for reuse by any future template needing
an Anthropic API key).

#### Regenerating / rotating the config

`promptStringOnce` / `promptBoolOnce` only run during `chezmoi init`, so the
generated config only updates when you re-init:

```bash
# Write the regenerated config to ~/.config/chezmoi/chezmoi.toml
chezmoi init

# Re-prompt for a cached value (e.g. to rotate the token), then regenerate
chezmoi state delete --bucket=configState --key=anthropic.token
chezmoi init

# Re-prompt for pi.enabled, then regenerate
chezmoi state delete --bucket=configState --key=pi.enabled
chezmoi init
```

> Only files named `.chezmoi.<format>.tmpl` (e.g. `.chezmoi.toml.tmpl`) are read
> by `chezmoi init`. A plain `.chezmoi.toml` in the source root is ignored.

### New Machine Bootstrap

`chezmoi init --apply` generates `~/.config/chezmoi/chezmoi.toml` from
`.chezmoi.toml.tmpl` automatically (see [Chezmoi Configuration](#chezmoi-configuration)).
You should only need the manual fallback below if `chezmoi apply` fails with
template errors (e.g., `map has no entry for key "pi"`), meaning the config
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

  [data.pi]
    enabled = true        # set false on machines that don't use pi-agent
EOF
chezmoi apply
```

The templates are defensive — they work with empty data and fall back to environment variables. But you need *some* config file for chezmoi to process templates correctly.

### pi-agent Configuration (Optional)

[pi](https://github.com/earendil-works/pi-coding-agent) reads skills and config from
`~/.agents/skills` and `~/.pi/agent/`. This repo wires those locations to a separate
private working repo at `~/dotfiles` (remote: `pi-dotfiles`) — but **only on machines
where you opt in**.

`chezmoi init` prompts once:

```
Enable pi-agent config (skills + settings via ~/dotfiles) on this machine?
```

- **Yes** → `chezmoi apply` clones `pi-dotfiles` into `~/dotfiles` (if missing) and
  creates three symlinks:
  - `~/.agents/skills` → `~/dotfiles/agents/skills`
  - `~/.pi/agent/settings.json` → `~/dotfiles/pi/settings.json`
  - `~/.pi/agent/mcp.json` → `~/dotfiles/pi/mcp.json`
- **No** → chezmoi leaves pi untouched on that machine (the entries are ignored via
  `.chezmoiignore`).

`~/dotfiles` stays a normal git repo you edit and push independently; chezmoi only
ensures the clone exists and the symlinks point at it. To change your answer later,
set `pi.enabled` in `~/.config/chezmoi/chezmoi.toml` (or re-run `chezmoi init`) and
`chezmoi apply`.

> The Claude Code bundle (`dot_claude` submodule + `make claude`) was removed when
> moving off Claude Code. The pi-agent skills were migrated from `~/.claude/skills`
> into the `pi-dotfiles` repo.

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

## Bundled Submodules

A few configs are pulled in as git submodules (see `.gitmodules`), pinned to the
commits recorded in this repo (so they advance only when this repo bumps the
pointer — there are no chezmoi `external_` entries):

- **Neovim:** [LazyVim](https://github.com/floatingman/lazyvim) → `dot_config/nvim`
- **Tmux:** [.tmux config](https://github.com/floatingman/.tmux) → `dot_config/tmux`
- **Personal scripts:** [bin](https://github.com/floatingman/bin) → `dot_local/bin`

`chezmoi init` / `chezmoi update` (a.k.a. `make update`) checks each submodule out
at its recorded commit. To advance a submodule to its latest upstream and record it:

```bash
chezmoi cd
git submodule update --remote --merge
git add .gitmodules dot_config/nvim dot_config/tmux dot_local/bin
git commit -m "Bump submodules"
```

## Structure

```
~/.local/share/chezmoi/            # Source directory (your dotfiles repo)
├── dot_config/                      # Application configs
│   ├── nvim/                        # Neovim (submodule: lazyvim)
│   ├── tmux/                        # Tmux (submodule: .tmux)
│   ├── i3/                          # Linux desktop only
│   ├── karabiner/                   # macOS only
│   └── ...
├── dot_local/bin/                   # Personal scripts (submodule: bin)
├── dot_zshrc                        # Zsh configuration
├── dot_zsh/                         # Zsh framework
├── dot_agents/symlink_skills.tmpl          # → ~/dotfiles/agents/skills (pi; conditional)
├── dot_pi/agent/symlink_settings.json.tmpl # → ~/dotfiles/pi/settings.json (pi; conditional)
├── dot_pi/agent/symlink_mcp.json.tmpl      # → ~/dotfiles/pi/mcp.json (pi; conditional)
├── run_once_install-pi-agent.sh.tmpl       # Clones ~/dotfiles when pi.enabled (conditional)
├── .chezmoi.toml.tmpl              # Template → ~/.config/chezmoi/chezmoi.toml
├── .chezmoiignore                  # Per-target + conditional ignore rules
└── Makefile                        # Convenience targets (update, apply, add, …)
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

**Submodules missing or empty (e.g. empty `dot_config/nvim`)?**
- Init/update submodules: `chezmoi cd && git submodule update --init --recursive`
- Then `chezmoi apply`

**pi-agent symlinks not created?**
- Confirm `pi.enabled = true` in `~/.config/chezmoi/chezmoi.toml`
- Ensure `~/dotfiles` is cloned (re-run `chezmoi apply`, or clone it manually)
- Check the wiring: `ls -l ~/.agents/skills ~/.pi/agent/settings.json ~/.pi/agent/mcp.json`

**Template errors on new machine (`map has no entry for key`)?**
- Chezmoi needs config data before processing templates
- Re-run: `chezmoi init --apply git@github.com:floatingman/dotfiles.git`
- Or create `~/.config/chezmoi/chezmoi.toml` with a `[data]` section (see New Machine Bootstrap above)

## License

MIT © floatingman
