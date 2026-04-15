#!/usr/bin/env bash
# One-time setup script for Claude Code settings template
# Run this after cloning dotfiles on a new machine

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

# Auto-detect Claude Code unless forced
if [[ "$FORCE" -ne 1 ]]; then
    echo "🔍 Checking for Claude Code installation..."

    if ! check_claude_installed; then
        echo -e "${YELLOW}⚠️  Claude Code not detected${NC}"
        echo "   Skipping Claude Code template setup."
        echo ""
        echo "To force setup anyway, run:"
        echo "   make claude-force"
        exit 0
    fi

    echo -e "${GREEN}✓ Claude Code detected${NC}"
else
    echo -e "${BLUE}🔧 Force mode: setting up Claude Code templates regardless${NC}"
fi

echo ""
echo "Setting up Claude Code configuration..."

# Check for environment variables
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

# Refresh external (clone/update claude-config)
echo ""
echo "📦 Updating Claude Code configuration from external repo..."
chezmoi apply --refresh-externals --force

# Apply chezmoi templates
echo ""
echo "🚀 Applying chezmoi templates..."
if chezmoi apply --force; then
    echo -e "${GREEN}✓ Templates applied successfully${NC}"
else
    echo -e "${RED}✗ Failed to apply templates${NC}"
    exit 1
fi

# Verify the generated file
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
