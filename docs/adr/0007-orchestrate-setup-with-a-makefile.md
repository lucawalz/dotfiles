---
status: accepted
date: 2026-07-18
---

# 0007. Orchestrate setup with a Makefile

## Context

[ADR 0001](0001-deploy-configs-with-gnu-stow.md) rejected an install script because the one the README once documented copied configuration into place. That copying was the source of the drift Stow was adopted to remove: a snapshot step sat between the repository and the machine, and skipping it let the live files and the tracked files diverge. The lesson recorded there was that nothing should copy configuration.

Fresh setup still takes several ordered steps: install the Homebrew dependencies, link the Stow packages, and complete the parts Homebrew cannot reach, such as building SbarLua and installing SF Pro. Those steps live in the README as prose, so a new machine is brought up by reading and retyping them, and the Stow package list is repeated wherever the link command appears.

Orchestrating the existing steps is a different thing from copying configuration. A command that runs `brew bundle`, calls Stow, and prints the manual reminders never writes a configuration file. Stow still owns every symlink, and the working copy stays live. The rule from ADR 0001 was about snapshot drift, not about whether a runner may sequence commands.

## Decision

A root Makefile orchestrates deployment. It auto-discovers the Stow packages from the top-level directories, excluding `docs`, so adding a package needs no edit to an install list. It exposes `brew`, `stow`, `unstow`, `restow`, `lint`, and `bootstrap`, where `bootstrap` runs `brew` and `stow` and then prints the manual steps Homebrew cannot perform.

Stow still owns the symlinks. The Makefile calls `stow -t ~` rather than moving files itself, so the live configuration remains a set of links into the repository.

## Consequences

Fresh setup becomes `make bootstrap` followed by the printed manual steps, and the Stow package list is defined once. Adding a new configuration still means adding a top-level directory; the Makefile discovers it with no further change.

The "no install script" rule stands in spirit. Nothing copies configuration, so the drift ADR 0001 guarded against cannot return. The rule is refined to allow orchestration: a runner may sequence the existing steps as long as Stow keeps ownership of the symlinks and no configuration is copied.
