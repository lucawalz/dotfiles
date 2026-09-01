---
status: accepted
date: 2026-09-01
---

# 0008. Split the Brewfile into core and personal layers

## Context

The Brewfile had no stated scope, so its maintenance move became reconciling it against whatever happened to be installed on the machine. Commit 062d3f0 on 2026-07-19 did exactly that and grew the file from 28 entries to 87 in a single pass, sweeping in personal desktop software such as Affinity, OrcaSlicer, the DisplayLink drivers, MacTeX, PostgreSQL and Mosquitto.

Setting up a second Apple Silicon Mac for work surfaced the problem: there was no way to install the terminal environment without also installing the personal desktop. Trimming individual entries would not hold, because the next reconcile would sweep them back in. The missing thing was an ownership rule.

## Decision

`Brewfile` is the core manifest and covers exactly two things: the dependencies the configurations in this repository need in order to work, and the shared development toolchain wanted on every machine. `Brewfile.personal` holds the personal machine layer and is never installed by default. `make bootstrap` installs the core only, and a new `make brew-personal` target installs the layer on the personal machine.

The layer file lives at the repository root as a plain file rather than inside a `profiles/` directory, because the Makefile derives its Stow package list from `$(wildcard */)` and a new top-level directory would be silently linked into the home directory.

Two entries look optional and are not. `nowplaying-cli` is called by the SketchyBar media widget through `sketchybar/.config/sketchybar/bin.lua`, as recorded in [ADR 0005](0005-adopt-aerospace-with-raycast-and-sketchybar-via-sbarlua.md). `node` is required because the Neovim Mason configuration installs `ts_ls`, `bashls`, `dockerls`, `docker_compose_language_service`, `yamlls`, `jsonls` and `prettier`, all of which are distributed through npm. Both stay in the core manifest.

The split also fixed a latent defect. `make lint` calls `shellcheck`, which was never declared in the Brewfile and existed on the machine only as a transitive dependency, so linting would have failed on a clean install. It is now declared. `terraform` and `flux` were installed but untracked and belong to the cloud and kubernetes groups, so they are now declared through the `hashicorp/tap` and `fluxcd/tap` taps.

## Consequences

The core manifest is deliberately a subset of what is installed on the personal machine, so `brew bundle cleanup` must never be run against it: it would uninstall everything outside the manifest. Reconciling the Brewfile against the installed packages is no longer a valid maintenance operation, and new entries are classified by the ownership rule instead.

Untracked leaves remain untracked by choice rather than oversight, specifically tmux, vivid, curl, nano, telnet, watch, leiningen, libomp, e2fsprogs and argparse, along with the casks cap, codex, fluidvoice, libreoffice, font-hack-nerd-font and font-meslo-lg-nerd-font.

The split enables a second Apple Silicon Mac and nothing broader, because `sketchybar/`, `aerospace/` and `zsh/` hardcode the `/opt/homebrew` prefix, so an Intel Mac still would not work. [ADR 0001](0001-deploy-configs-with-gnu-stow.md) recorded that Stow owns deployment and that no install script copies configuration; that still holds, since the layer is another declarative manifest rather than logic.
