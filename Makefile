.PHONY: help install update apply clean

help: ## Show this help message
	@echo "Available targets:"
	@echo "  make install    - Initial installation on a new machine"
	@echo "  make update     - Update submodules and apply changes"
	@echo "  make apply      - Apply chezmoi templates"
	@echo "  make clean      - Clean generated files"
	@echo ""
	@echo "Claude Code setup (optional):"
	@echo "  make claude       - Auto-detects Claude, sets up if found"
	@echo "  make claude-force - Force Claude setup (skip detection)"

install: ## Initial installation
	@echo "📦 Installing dotfiles..."
	@chezmoi init --apply
	@echo "✅ Installation complete"

update: ## Update submodules and apply changes
	@echo "📦 Updating submodules..."
	@git submodule update --init --recursive --remote
	@echo "🚀 Applying changes..."
	@chezmoi apply
	@echo "✅ Update complete"

apply: ## Apply chezmoi templates
	@chezmoi apply

clean: ## Clean generated files
	@echo "🧹 Cleaning generated files..."
	@chezmoi forget --exact $(chezmoi managed --include=files | xargs)
	@rm -rf $(chezmoi managed --include=files | xargs)
	@echo "✅ Clean complete"

claude: ## One-time Claude Code template setup (auto-detects Claude)
	@./scripts/setup-claude-template.sh

claude-force: ## Force Claude Code template setup (even if Claude not detected)
	@./scripts/setup-claude-template.sh --force
