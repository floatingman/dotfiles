.PHONY: help install update apply clean add diff status doctor verify

help: ## Show this help message
	@echo "Available targets:"
	@echo ""
	@echo "Core operations:"
	@echo "  make install    - Initial installation on a new machine"
	@echo "  make update     - Update submodules and apply changes"
	@echo "  make apply      - Apply chezmoi templates"
	@echo ""
	@echo "File management:"
	@echo "  make add <file> - Add file to chezmoi (e.g., make add ~/.zshrc)"
	@echo "  make edit <file>- Edit file in chezmoi source"
	@echo "  make diff        - Show what would change without applying"
	@echo "  make status      - Show chezmoi status"
	@echo ""
	@echo "Maintenance:"
	@echo "  make doctor      - Run chezmoi diagnostics"
	@echo "  make verify      - Verify no uncommitted changes"
	@echo "  make clean       - Remove all managed files"
	@echo ""
	@echo "Claude Code (optional):"
	@echo "  make claude       - Auto-detects Claude, sets up if found"
	@echo "  make claude-force - Force Claude setup (skip detection)"
	@echo ""
	@echo "Examples:"
	@echo "  make add ~/.zshrc"
	@echo "  make edit ~/.zshrc"
	@echo "  make diff"
	@echo "  make status"

install: ## Initial installation on a new machine
	@echo "📦 Installing dotfiles..."
	@chezmoi init --apply
	@echo "✅ Installation complete"
	@echo ""
	@echo "Next steps:"
	@echo "  1. Reload shell: source ~/.zshrc"
	@echo "  2. Optional: make claude (for Claude Code setup)"

update: ## Update submodules and apply changes
	@echo "📦 Updating..."
	@chezmoi update
	@echo "✅ Update complete"

apply: ## Apply chezmoi templates
	@chezmoi apply

add: ## Add file to chezmoi (e.g., make add FILE=~/.zshrc)
	@if [ -z "$(FILE)" ]; then \
			echo "Error: Usage: make add FILE=~/.zshrc"; \
			exit 1; \
		fi
	@echo "📝 Adding $(FILE) to chezmoi..."
	@chezmoi add $(FILE)
	@echo "✓ Added $(FILE)"
	@echo "  Don't forget to commit the changes: make commit"

edit: ## Edit file in chezmoi source (e.g., make edit FILE=~/.zshrc)
	@if [ -z "$(FILE)" ]; then \
			echo "Error: Usage: make edit FILE=~/.zshrc"; \
			exit 1; \
		fi
	@echo "📝 Editing $(FILE)..."
	@chezmoi edit $(FILE)

commit: ## Commit changes to dotfiles repo
	@echo "📝 Committing changes..."
	@chezmoi cd && git commit -m "Update dotfiles"

push: ## Push changes to remote
	@echo "📤 Pushing changes..."
	@chezmoi cd && git push

diff: ## Show what would change without applying
	@chezmoi diff

status: ## Show chezmoi status
	@echo "📊 Chezmoi status:"
	@chezmoi status
	@echo ""
	@echo "📁 Managed files:"
	@chezmoi managed | wc -l | xargs -I {} echo {} files managed

doctor: ## Run chezmoi diagnostics
	@echo "🔍 Running chezmoi diagnostics..."
	@chezmoi doctor

verify: ## Verify no uncommitted changes in source
	@echo "🔍 Verifying chezmoi source..."
	@chezmoi cd && git status --short
	@echo ""
	@echo "To commit changes:"
	@echo "  make commit"

clean: ## Remove all managed files (DANGEROUS!)
	@echo "⚠️  This will remove all managed files from your home directory!"
	@read -p "Continue? [y/N] " -n 1 -r; \
		echo ""; \
		if [[ $$REPLY =~ ^[Yy]$$ ]]; then \
			chezmoi forget --exact $$(chezmoi managed --include=files | xargs); \
			rm -rf $$(chezmoi managed --include=files | xargs); \
			echo "✅ Clean complete"; \
		else \
			echo "Cancelled"; \
		fi

claude: ## One-time Claude Code template setup (auto-detects Claude)
	@./scripts/setup-claude-template.sh

claude-force: ## Force Claude Code template setup (even if Claude not detected)
	@./scripts/setup-claude-template.sh --force
