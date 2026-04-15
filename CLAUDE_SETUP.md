# Claude Code Settings Template

## Overview

The Claude Code settings are managed via a Chezmoi template that generates `~/.claude/settings.json` from environment variables and configuration.

## File Structure

```
~/.local/share/chezmoi/
└── dot_claude/                    # Git submodule (private repo: floatingman/claude-config)
    ├── .agents/
    ├── agents/
    ├── commands/
    ├── ecc/
    ├── hooks/
    ├── rules/
    ├── scripts/
    ├── skills/
    └── settings.json.tmpl         # Template file (chezmoi processes this)
```

The **entire** `dot_claude/` directory is a git submodule containing your Claude Code configuration. Chezmoi uses `settings.json.tmpl` to generate `~/.claude/settings.json`.

## How It Works

1. **Submodule**: The `dot_claude/` directory is a git submodule pointing to `git@github.com:floatingman/claude-config.git`

2. **Template**: `settings.json.tmpl` contains chezmoi template variables

3. **Generation**: When you run `chezmoi apply`, it:
   - Reads `dot_claude/settings.json.tmpl`
   - Substitutes variables from environment and config
   - Generates `~/.claude/settings.json`

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

# 2. Update submodules (includes dot_claude)
git submodule update --init --remote

# 3. Set your API token
export ANTHROPIC_AUTH_TOKEN="sk-ant-..."

# 4. Apply the template
make claude
# or: ./scripts/setup-claude-template.sh
```

### Updating Settings

```bash
# Option 1: Edit the template (for hook changes)
cd ~/.local/share/chezmoi/dot_claude
nvim settings.json.tmpl
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

# 2. Update submodules
git submodule update --init --recursive

# 3. Run setup script
make claude
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
- Private submodule keeps your hooks/agents/skills private

## Troubleshooting

### File not generating

```bash
# Check if template exists
ls -la ~/.local/share/chezmoi/dot_claude/settings.json.tmpl

# Check submodule status
cd ~/.dotfiles
git submodule status

# Re-initialize if needed
git submodule update --init --remote --depth 1
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

### Submodule issues

```bash
# Remove and re-initialize submodule
git submodule deinit -f dot_claude
rm -rf .git/modules/dot_claude
git submodule update --init --remote
```
