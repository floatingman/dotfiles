#!/usr/bin/env bash
# One-time setup script for Claude Code settings template
# Run this after cloning dotfiles on a new machine
#
# Usage:
#   ./scripts/setup-claude-template.sh          # Auto-detect Claude
#   ./scripts/setup-claude-template.sh --force  # Force setup
#   FORCE=1 ./scripts/setup-claude-template.sh  # Force setup

set -euo pipefail

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Parse arguments
FORCE="${FORCE:-0}"
for arg in "$@"; do
    case $arg in
        --force)
            FORCE=1
            shift
            ;;
        *)
            ;;
    esac
done

# Function to check if Claude Code is installed
check_claude_installed() {
    # Check for ~/.claude directory
    if [[ -d "$HOME/.claude" ]]; then
        return 0
    fi

    # Check for claude command in PATH
    if command -v claude &> /dev/null; then
        return 0
    fi

    return 1
}

# Check if we're in the dotfiles directory
if [[ ! -f ".chezmoi.toml" ]] || [[ ! -d ".git" ]]; then
    echo -e "${RED}Error: Must run this script from the dotfiles root directory${NC}"
    echo "Usage: cd ~/.dotfiles && ./scripts/setup-claude-template.sh"
    exit 1
fi

# Auto-detect Claude Code unless forced
if [[ "$FORCE" -ne 1 ]]; then
    echo "🔍 Checking for Claude Code installation..."

    if ! check_claude_installed; then
        echo -e "${YELLOW}⚠️  Claude Code not detected${NC}"
        echo "   Skipping Claude Code template setup."
        echo ""
        echo "To force setup anyway, run:"
        echo "   ./scripts/setup-claude-template.sh --force"
        echo "   or: FORCE=1 ./scripts/setup-claude-template.sh"
        exit 0
    fi

    echo -e "${GREEN}✓ Claude Code detected${NC}"
else
    echo -e "${BLUE}🔧 Force mode: setting up Claude Code templates regardless${NC}"
fi

echo ""
echo "Setting up Claude Code configuration template..."

# 1. Update submodules (from dotfiles root)
echo "📦 Updating submodules..."
cd "$(git rev-parse --show-toplevel)" || exit 1
if git submodule update --init --remote --depth 1 2>/dev/null; then
    echo -e "${GREEN}✓ Submodules updated${NC}"
else
    echo -e "${YELLOW}⚠️  Submodule update had issues (may be non-critical)${NC}"
fi
cd - > /dev/null || exit 1

# 2. Create chezmoi config directory
echo "📁 Creating chezmoi config directory..."
mkdir -p ~/.config/chezmoi

# 3. Copy chezmoi config if it doesn't exist
if [[ ! -f ~/.config/chezmoi/chezmoi.toml ]]; then
    echo "📝 Copying chezmoi config..."
    cp .chezmoi.toml ~/.config/chezmoi/chezmoi.toml
    echo -e "${GREEN}✓ Created ~/.config/chezmoi/chezmoi.toml${NC}"
else
    echo "ℹ️  ~/.config/chezmoi/chezmoi.toml already exists, skipping..."
fi

# 4. Create symlink for template
echo "🔗 Creating template symlink..."
mkdir -p ~/.local/share/chezmoi/dot_claude

# Create symlink (force overwrite if exists)
ln -sf ../claude-config/dot_claude/settings.json.tmpl \
   ~/.local/share/chezmoi/dot_claude/settings.json.tmpl

if [[ -L ~/.local/share/chezmoi/dot_claude/settings.json.tmpl ]]; then
    echo -e "${GREEN}✓ Created symlink for settings.json template${NC}"
else
    echo -e "${RED}✗ Failed to create symlink${NC}"
    exit 1
fi

# 5. Check for environment variables
echo ""
echo "🔑 Checking for API configuration..."

if [[ -z "${ANTHROPIC_AUTH_TOKEN:-}" ]]; then
    echo -e "${YELLOW}⚠️  ANTHROPIC_AUTH_TOKEN not set${NC}"
    echo "   Set it with: export ANTHROPIC_AUTH_TOKEN='your-token'"
elif [[ -z "${ANTHROPIC_BASE_URL:-}" ]]; then
    echo -e "${YELLOW}⚠️  ANTHROPIC_BASE_URL not set (will use default)${NC}"
    echo "   Set it with: export ANTHROPIC_BASE_URL='https://api.z.ai/api/anthropic'"
else
    echo -e "${GREEN}✓ API credentials found${NC}"
fi

# 6. Apply chezmoi templates
echo ""
echo "🚀 Applying chezmoi templates..."
if chezmoi apply --force; then
    echo -e "${GREEN}✓ Templates applied successfully${NC}"
else
    echo -e "${RED}✗ Failed to apply templates${NC}"
    exit 1
fi

# 7. Verify the generated file
if [[ -f ~/.claude/settings.json ]]; then
    echo ""
    echo -e "${GREEN}✅ Setup complete!${NC}"
    echo "   Generated file: ~/.claude/settings.json"
    echo "   Size: $(wc -l < ~/.claude/settings.json) lines"
else
    echo -e "${RED}✗ Setup failed - settings.json not generated${NC}"
    exit 1
fi

echo ""
echo "📚 Next steps:"
echo "   1. Set your API credentials in ~/.zshrc or ~/.bashrc:"
echo "      export ANTHROPIC_AUTH_TOKEN='your-token'"
echo "      export ANTHROPIC_BASE_URL='https://api.z.ai/api/anthropic'"
echo "   2. Source your shell config: source ~/.zshrc"
echo "   3. Run: chezmoi apply"
echo ""
echo "See ~/.dotfiles/CLAUDE_SETUP.md for full documentation."
