.DEFAULT_GOAL := help
PACKAGES := $(patsubst %/,%,$(filter-out docs/,$(wildcard */)))

.PHONY: help brew brew-personal stow unstow restow lint bootstrap

help:
	@echo "targets: brew brew-personal stow unstow restow lint bootstrap"

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
	shellcheck -x -e SC1091 borders/.config/borders/bordersrc aerospace/.config/aerospace/scripts/focus.sh

bootstrap: brew stow
	@echo "Remaining manual steps:"
	@echo "  1. Grant Accessibility to AeroSpace and borders in System Settings."
	@echo "  2. Disable automatic menu bar hiding in System Settings."
