---
status: accepted
date: 2026-07-16
---

# 0002. Derive Oxocarbon theming from the base16 palette

## Context

Oxocarbon is applied across the whole environment, but the upstream ports list covers editors and terminals only. Neovim has oxocarbon.nvim and Ghostty ships an Oxocarbon theme, so those two are handled. Three tools in the environment have no port at all: starship names colors in its own palette table, SketchyBar builds its bar from shell variables, and JankyBorders takes an active and inactive border color as arguments. btop, fzf, and `LS_COLORS` are in the same position, each carrying its own hex values or escape codes.

Without a rule, those tools get hand-picked colors that approximate Oxocarbon and drift from it and from each other. `.zshrc` had already settled the question in practice: its `LS_COLORS` and `FZF_DEFAULT_OPTS` name the canonical [base16-oxocarbon](https://github.com/nyoom-engineering/base16-oxocarbon) dark palette verbatim.

Ghostty complicates the picture. Its built-in Oxocarbon theme uses a more saturated palette than canonical base16, with `#00dfdb`, `#00b4ff`, and `#ff4297` where base16 has `#3ddbd9`, `#78a9ff`, and `#ee5396`. Any tool that inherits color from terminal ANSI therefore lands on different colors than a tool configured with base16 hex values directly, and the two sets sit side by side in the same window.

## Decision

The canonical base16-oxocarbon dark palette is the single source of truth. Every tool without an upstream port names its colors from that palette: starship's palette table, the btop theme, `FZF_DEFAULT_OPTS`, the fzf-tab styles, and `LS_COLORS`. SketchyBar and JankyBorders share one `colors.sh` that exports the sixteen base16 slots as `BASE00` through `BASE0F` and layers semantic names such as `ACCENT`, `WARNING`, and `CRITICAL` on top, so a plugin names a role rather than a hex value.

Ghostty keeps `theme = Oxocarbon` for the parts of its surface the theme covers, but overrides the 16 ANSI entries to the canonical base16 values. Everything that inherits color through terminal ANSI then agrees with everything configured from base16 directly. This also settles bat: `BAT_THEME="base16"` maps through terminal ANSI rather than carrying its own hex values, so pinning the ANSI palette renders bat as Oxocarbon with no bat-specific theme to install or maintain.

## Options considered

- Hand-pick colors per tool to approximate the theme, rejected. It needs no upstream reference and each tool can be tuned in isolation, but it is unprincipled: there is no answer to what a given color should be beyond what looked right at the time, and the tools drift from upstream and from each other as they are edited.
- Adopt a different theme that has ports for starship, SketchyBar, and JankyBorders, rejected. It removes the derivation problem outright, but it abandons Oxocarbon, which is the reason the environment looks the way it does, and trades a solved problem for a full retheme.
- Accept Ghostty's built-in palette as the source and derive the other tools from it, rejected. It makes the terminal authoritative, which is coherent, but it forks the palette away from upstream base16 and leaves `.zshrc` to be rewritten against a palette with no canonical definition to track.
- Derive from canonical base16-oxocarbon and override Ghostty's ANSI entries to match, chosen. It keeps one upstream reference for every tool, and the override is 16 lines in one file.

## Consequences

There is a single palette source of truth, so a color question has one answer and a tool added later has a rule to follow rather than a judgment to make. Upstream base16 changes have to be tracked by hand, since nothing in the repository pins or verifies the palette against its source.

Ghostty's config carries a 16-line ANSI override that will silently diverge if the upstream Ghostty theme changes, and the override is the reason the terminal does not look like stock Oxocarbon. bat needs no theme of its own and follows the terminal. The semantic layer in `colors.sh` means a SketchyBar recolor is one edit rather than one per plugin, at the cost of an indirection to read through.

A tool added to the environment that reads terminal ANSI inherits the palette for free; one that carries its own colors has to name the base16 values explicitly, and there is no mechanism that enforces this beyond review.
