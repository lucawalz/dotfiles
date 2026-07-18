.DEFAULT_GOAL := help
PACKAGES := $(patsubst %/,%,$(filter-out docs/,$(wildcard */)))

.PHONY: help brew stow unstow restow lint bootstrap

help:
	@echo "targets: brew stow unstow restow lint bootstrap"

brew:
	brew bundle

stow:
	stow -t ~ $(PACKAGES)

unstow:
	stow -D -t ~ $(PACKAGES)

restow:
	stow -R -t ~ $(PACKAGES)

lint:
	shellcheck -x -e SC1091 sketchybar/.config/sketchybar/helpers/cpu.sh borders/.config/borders/bordersrc aerospace/.config/aerospace/scripts/focus.sh

bootstrap: brew stow
	@echo "Remaining manual steps:"
	@echo "  1. Build SbarLua from source (needs lua and clang)."
	@echo "  2. Install SF Pro into ~/Library/Fonts."
	@echo "  3. Grant Accessibility to AeroSpace and borders in System Settings."
