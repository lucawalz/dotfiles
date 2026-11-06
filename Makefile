.DEFAULT_GOAL := help
PACKAGES := $(patsubst %/,%,$(filter-out docs/,$(wildcard */)))

.PHONY: help brew brew-personal stow unstow restow lint check-nvim check-tmux check-focus bootstrap

help:
	@echo "targets: brew brew-personal stow unstow restow lint check-nvim check-tmux check-focus bootstrap"

brew:
	brew bundle

brew-personal:
	brew bundle --file=Brewfile.personal

stow:
	stow -t ~ $(PACKAGES)

unstow:
	stow -D -t ~ $(PACKAGES)

restow:
	stow -R -t ~ $(PACKAGES)

lint:
	shellcheck -x -e SC1091 borders/.config/borders/bordersrc aerospace/.config/aerospace/scripts/focus.sh aerospace/.config/aerospace/scripts/test-focus.sh tmux/.config/tmux/tests/check.sh

check-nvim:
	XDG_CONFIG_HOME=$(CURDIR)/nvim/.config nvim --headless -c "lua local ok, e = pcall(dofile, 'nvim/.config/nvim/tests/smoke.lua') if not ok then io.stderr:write(tostring(e) .. '\\n') vim.cmd('cquit 1') end"

check-tmux:
	tmux/.config/tmux/tests/check.sh

check-focus:
	aerospace/.config/aerospace/scripts/test-focus.sh

bootstrap: brew stow
	@echo "Remaining manual steps:"
	@echo "  1. Grant Accessibility to AeroSpace and borders in System Settings."
	@echo "  2. Disable automatic menu bar hiding in System Settings."
