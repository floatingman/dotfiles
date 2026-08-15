# Dotfiles

Machine-specific dotfiles managed with [Chezmoi](https://www.chezmoi.io).

## Features

**Cross-platform** (works everywhere):
- Shell: Zsh framework with Starship prompt
- Editors: Neovim (LazyVim), Vim
- Terminal: Tmux, Yazi file manager
- CLI tools: Atuin shell history, Git configs
- AI coding: [pi-agent](https://github.com/earendil-works/pi-coding-agent) skills + config (conditional — see [pi-agent Configuration](#pi-agent-configuration-optional))

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
  - `pi.enabled` / `pi.repo` / `pi.reviewerRepo` — gate the [pi-agent config](#pi-agent-configuration-optional)
    and select the skills/reviewer repos to clone (prompted once per machine; when
    `enabled=false` all pi entries are skipped via `.chezmoiignore`)

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

# Re-prompt for pi.enabled / pi.repo, then regenerate
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
    enabled = true                # set false on machines that don't use pi-agent
    repo = "git@github.com:floatingman/pi-dotfiles.git"  # or your fork
    reviewerRepo = "git@github.com:floatingman/pi-reviewer.git"  # or your fork
EOF
chezmoi apply
```

The templates are defensive — they work with empty data and fall back to environment variables. But you need *some* config file for chezmoi to process templates correctly.

### pi-agent Configuration (Optional)

[pi](https://github.com/earendil-works/pi-coding-agent) reads skills from
`~/.pi/agent/skills/` and config from `~/.pi/agent/{settings,mcp}.json`. Chezmoi
provisions all of it directly under `~/.pi/agent/` — **no symlinks, no separate
`~/dotfiles` repo** — but only on machines where you opt in.

`chezmoi init` prompts:

```
Enable pi-agent config (skills + settings via ~/dotfiles) on this machine?
pi-dotfiles repo URL (set to YOUR fork if you have one)?
```

- **Yes** → `chezmoi apply` provisions pi under `~/.pi/agent/`:
  - `run_once_install-pi-agent.sh` clones the skills repo **in place** to
    `~/.pi/agent/skills/` — a normal git checkout, so you edit and push right
    there (`cd ~/.pi/agent/skills && git commit && git push`).
  - `dot_pi/agent/create_settings.json` creates `~/.pi/agent/settings.json` once
    (chezmoi `create_` — then pi owns it; pi adds `lastChangelogVersion`, theme
    changes, etc. on top of the static config).
  - `dot_pi/agent/create_mcp.json` creates `~/.pi/agent/mcp.json` once (chezmoi
    `create_` — then you own it; safe to add machine-local secrets like webhook
    URLs, since chezmoi never overwrites it).
  - `dot_pi/agent/run_onchange_install-pi-packages.sh.tmpl` reconciles the
    baseline extension list into `settings.json`'s `packages` array (additive —
    never removes locally-added packages; re-runs when you edit the list).
  - `run_once_install-pi-reviewer.sh` clones `pi-reviewer` to `~/git/pi-reviewer`
    (so the settings.json package `../../git/pi-reviewer` resolves).
- **No** → chezmoi leaves pi untouched (all pi entries are skipped via `.chezmoiignore`).

Each install script **probes its repo and skips gracefully** if unreachable (no
clone, `chezmoi apply` continues — nothing breaks). Forkers: set `[data.pi] repo`
/ `reviewerRepo` to your fork URLs in `~/.config/chezmoi/chezmoi.toml`, then
re-run `chezmoi init && chezmoi apply`.

To change your answers later, edit `pi.enabled` / `pi.repo` in
`~/.config/chezmoi/chezmoi.toml` (or re-run `chezmoi init`) and `chezmoi apply`.

### omp (oh-my-pi) Configuration

[oh-my-pi](https://github.com/can1357/oh-my-pi) (`omp`, successor to pi) keeps global
settings in `~/.omp/agent/config.yml`. Unlike pi's `settings.json`, omp's config is
pure portable settings with no machine-local runtime state, and omp writes it in place
through a symlink — so it syncs with a `symlink_` entry instead of `create_`:

- `files/omp/agent/config.yml` — the real settings content (committed; never applied
  as a target — `files/` is ignored)
- `dot_omp/agent/symlink_config.yml.tmpl` — renders to
  `{{ .chezmoi.sourceDir }}/files/omp/agent/config.yml`, so `chezmoi apply` installs
  `~/.omp/agent/config.yml` as a symlink into this repo

Workflow: `/settings` or `omp config set` edits land **directly in the repo copy** —
commit and push them. `chezmoi update` on other machines picks them up (live on the
next `omp` launch). `chezmoi diff` never reports drift (it compares the link target,
not the contents).

On a machine where omp already created a regular `config.yml`: merge any local
differences into `files/omp/agent/config.yml` first, then `chezmoi apply` replaces
the file with the symlink.

Never sync (machine-local state): `agent.db`, `models.db`, `history.db`, `sessions/`,
`terminal-sessions/`, `last-changelog-version`. Keep credentials out of `config.yml`
(env vars / auth store) — through the symlink they would sync straight into the repo.

Future: `models.yml`, `SYSTEM.md`, `RULES.md`, `keybindings.*` follow the same
content + `symlink_` pair; `mcp.json` should use `create_` (may hold machine-local
secrets).

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
├── dot_omp/agent/symlink_config.yml.tmpl  # ~/.omp/agent/config.yml → symlink into this repo
├── files/omp/agent/config.yml             # omp settings content (symlink target; ignored as target)
├── dot_pi/agent/                    # pi-agent config (conditional on pi.enabled)
│   ├── create_settings.json         #   ~/.pi/agent/settings.json (create-once; pi owns runtime state)
│   ├── create_mcp.json              #   ~/.pi/agent/mcp.json (create-once; safe for machine-local secrets)
│   └── run_onchange_install-pi-packages.sh.tmpl  # additive reconcile of baseline packages
├── run_once_install-pi-agent.sh.tmpl   # Conditional: clones skills repo → ~/.pi/agent/skills
├── run_once_install-pi-reviewer.sh.tmpl# Conditional: clones pi-reviewer → ~/git/pi-reviewer
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

**pi skills/config not present?**
- Confirm `pi.enabled = true` in `~/.config/chezmoi/chezmoi.toml`
- Skills: check `~/.pi/agent/skills/.git` exists; if not, the clone script skipped
  (`data.pi.repo` unreachable) — run `chezmoi init && chezmoi apply`
- settings.json/mcp.json are create-once (chezmoi seeds them; you/pi own runtime
  state after). The extension list lives in `run_onchange_install-pi-packages.sh.tmpl`.
- `chezmoi apply` prompting "has changed since last wrote it"? Answer yes (or use
  `--force`) — it's chezmoi protecting a file modified outside chezmoi

**Template errors on new machine (`map has no entry for key`)?**
- Chezmoi needs config data before processing templates
- Re-run: `chezmoi init --apply git@github.com:floatingman/dotfiles.git`
- Or create `~/.config/chezmoi/chezmoi.toml` with a `[data]` section (see New Machine Bootstrap above)

## License

MIT © floatingman
