# Claude Code Settings Template

## Overview

The Claude Code settings are managed via a Chezmoi template that generates `~/.claude/settings.json` from environment variables and configuration.

## File Structure

```
~/.local/share/chezmoi/
├── claude-config/                    # Git submodule (private repo)
│   └── dot_claude/
│       └── settings.json.tmpl       # Template file (version controlled)
└── dot_claude/
    └── settings.json.tmpl -> ../claude-config/dot_claude/settings.json.tmpl  # Symlink
```

## How It Works

1. **Template Location**: The actual template file lives in the `claude-config` git submodule at `claude-config/dot_claude/settings.json.tmpl`

2. **Symlink**: A symlink in the root chezmoi source directory (`dot_claude/settings.json.tmpl`) points to the template in the submodule

3. **Generation**: When you run `chezmoi apply`, it:
   - Follows the symlink (enabled by `templateSymlinks = true`)
   - Reads the template from the submodule
   - Substitutes variables from environment and config
   - Generates `~/.claude/settings.json` at the correct location

## Configuration

### Environment Variables

Set these in your shell environment:

```bash
export ANTHROPIC_AUTH_TOKEN="sk-ant-..."  # Your API token
export ANTHROPIC_BASE_URL="https://api.anthropic.com"  # Optional: custom base URL
```

### Chezmoi Config

The `~/.config/chezmoi/chezmoi.toml` file defines default values:

```toml
[add]
  templateSymlinks = true  # Required for symlink to work

[data.anthropic]
  token = ""  # Falls back to ANTHROPIC_AUTH_TOKEN env var

[data.claude]
  api_timeout_ms = "3000000"  # API timeout
```

## Usage

### Initial Setup

```bash
# 1. Clone/update dotfiles
cd ~/.dotfiles
git pull
git submodule update --remote

# 2. Set your API token
export ANTHROPIC_AUTH_TOKEN="sk-ant-..."

# 3. Apply the template
chezmoi apply
```

### Updating Settings

```bash
# Option 1: Edit the template (for hook changes)
cd ~/.local/share/chezmoi/claude-config
nvim dot_claude/settings.json.tmpl
git add . && git commit -m "feat: update hooks" && git push

# Option 2: Update environment variables
export ANTHROPIC_AUTH_TOKEN="new-token"
chezmoi apply
```

### On New Machines

```bash
# 1. Clone dotfiles
git clone git@github.com:floatingman/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
git submodule update --init --recursive

# 2. Copy chezmoi config
mkdir -p ~/.config/chezmoi
cp .chezmoi.toml ~/.config/chezmoi/chezmoi.toml

# 3. Set API token
export ANTHROPIC_AUTH_TOKEN="sk-ant-..."

# 4. Apply
chezmoi apply
```

## Template Variables

The template supports the following variables:

| Variable | Source | Default | Description |
|----------|--------|---------|-------------|
| `ANTHROPIC_AUTH_TOKEN` | Environment or `.chezmoi.toml` | Required | Your Anthropic API token |
| `ANTHROPIC_BASE_URL` | Environment or `.chezmoi.toml` | Official API | Custom API base URL |
| `API_TIMEOUT_MS` | `.chezmoi.toml` | `3000000` | Request timeout in milliseconds |
| `{{ .chezmoi.homeDir }}` | Automatic | Your home dir | Used for all file paths |

## Security

- **Never commit** your actual `ANTHROPIC_AUTH_TOKEN` to git
- The template file contains no secrets
- Generated `settings.json` is ignored by git (in `.chezmoiignore`)
- Only the template (without secrets) is version controlled

## Troubleshooting

### File not generating

```bash
# Check if symlink exists
ls -la ~/.local/share/chezmoi/dot_claude/settings.json.tmpl

# Should show: lrwxrwxrwx ... dot_claude/settings.json.tmpl -> ../claude-config/dot_claude/settings.json.tmpl

# If missing, recreate it:
mkdir -p ~/.local/share/chezmoi/dot_claude
ln -s ../claude-config/dot_claude/settings.json.tmpl ~/.local/share/chezmoi/dot_claude/settings.json.tmpl
```

### Template variables not working

```bash
# Check chezmoi data
chezmoi data | jq '.anthropic, .claude'

# Verify environment variables
echo $ANTHROPIC_AUTH_TOKEN

# Test template
chezmoi execute-template < ~/.local/share/chezmoi/dot_claude/settings.json.tmpl | head -20
```

### Wrong file location

If you see files generated at `~/claude-config/.claude/settings.json`, ensure:
1. The symlink exists at `~/.local/share/chezmoi/dot_claude/settings.json.tmpl`
2. `templateSymlinks = true` is set in `~/.config/chezmoi/chezmoi.toml`
3. Run `chezmoi apply --force` to regenerate
