---
status: accepted
date: 2026-07-16
---

# 0001. Deploy configurations with GNU Stow

## Context

The repository was a snapshot rather than a deployment. Files were copied in by hand, and nothing linked them back to the machine: `~/.config` held real directories, not symlinks. The README documented an `install.sh` that would create those symlinks, but the script was never written, so the only path from repository to machine was a manual copy that nobody performed on a schedule.

The two copies drifted for roughly six months. By the time the drift was measured, 25 Neovim files differed between the repository and the live configuration, and 18 plugins existed only on the machine. The repository described a machine that no longer existed. A snapshot repository fails this way by construction: correctness depends on a manual step that carries no feedback when skipped, and the drift is silent until someone reads both copies side by side.

## Decision

Each top-level directory becomes a GNU Stow package whose interior mirrors the path it targets under `~`. `ghostty/.config/ghostty/config` links to `~/.config/ghostty/config`, and `zsh/.zshrc` links to `~/.zshrc`. Deployment is `brew bundle && stow -t ~ aerospace ghostty starship btop fastfetch nvim zsh sketchybar borders`, and `stow` itself is a Brewfile entry.

The live files are the repository files. Editing `~/.config/nvim/init.lua` edits the repository through the symlink, and `git status` in the clone reports the change. No copy step exists, so no copy step can be skipped, and drift is not a risk to manage but a state the layout cannot represent.

## Options considered

- A hand-written `install.sh`, rejected. It is exactly what the README promised and never delivered, and writing it now means owning bespoke symlink logic: conflict detection, backup of existing files, removal on uninstall, and idempotent re-runs. Stow is a packaged, documented implementation of that logic with a decade of use behind it.
- nix-darwin with home-manager, rejected. It solves drift more thoroughly than Stow and would manage the packages as well as the configuration, but it is a large migration that would subsume the Brewfile and rewrite every configuration into Nix expressions. Nix is installed on this Mac but manages nothing on it today, so the move would start from zero. The cost is not justified by the problem in front of it, and Stow does not foreclose the migration later.
- A bare git repository with `--git-dir` pointing at `$HOME`, rejected. It needs no symlinks and no extra dependency, but it makes `$HOME` a working tree, which turns every untracked file in the home directory into noise and makes the repository opaque to anyone reading it. The package boundaries that Stow makes explicit disappear.
- GNU Stow, chosen. It is one dependency, the package layout is self-documenting, and `stow -D` and `stow -R` cover removal and relinking.

## Consequences

Drift between the repository and the machine becomes structurally impossible rather than merely discouraged, and the six-month failure that motivated this record cannot recur in the same form. Deployment gains a dependency on `stow`, which the Brewfile installs. Entries under `~/.config` become symlinks, which some tools notice: a program that replaces a config file by writing a new inode rather than editing in place will break the link, and the package must be restowed afterwards.

The clone location becomes load-bearing, since the symlinks point back into it and moving the clone breaks every one of them. Adding a tool now means adding a package directory that mirrors the target path, rather than copying a file to the repository root. The pre-existing configuration in `~/.config` has to be moved aside once, because Stow refuses to overwrite a real file at a target path.
