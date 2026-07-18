---
status: accepted
date: 2026-07-18
---

# 0006. Adopt Carbonfox as the theme

Supersedes [ADR 0002](0002-derive-oxocarbon-theming-from-base16.md).

## Context

ADR 0002 made canonical base16-oxocarbon the single source of truth and, because Ghostty's bundled Oxocarbon is more saturated than canonical, overrode Ghostty's ANSI palette by hand to hold the terminal in line. Oxocarbon has maintained ports only for Ghostty and Neovim, and the two came from different authors: Ghostty's bundled theme and oxocarbon.nvim did not match, which is what forced the override. Every other tool was hand-derived from the palette.

Carbonfox, the IBM Carbon variant of nightfox.nvim, removes that seam. nightfox generates every output from one palette file: the Neovim colorscheme and a set of exports, including a Ghostty theme that Ghostty bundles byte-for-byte. The terminal and the editor cannot drift, and the palette keeps the near-black background and cool accents that Oxocarbon was chosen for.

## Decision

The theme is Carbonfox. Neovim loads it through nightfox.nvim with `colorscheme carbonfox`, and Ghostty runs its bundled `theme = Carbonfox`, which is identical to nightfox's export, so no ANSI override is needed. starship, btop, SketchyBar, JankyBorders, fzf, and LS_COLORS have no Carbonfox port, so they name Carbonfox's base16 values directly. bat, delta, eza, and fastfetch carry no theme of their own and inherit the terminal palette. No tool uses a hand-invented approximation.

## Consequences

The Ghostty ANSI override from ADR 0002 is gone: one source drives the terminal and the editor with no seam. The tools without a port still carry hand-written hex, but from the exact Carbonfox base16 values rather than an eyeballed approximation, and they no longer disagree with what the terminal inherits. Switching themes later means changing the nightfox variant and re-deriving that same handful of port-less files. Oxocarbon leaves, and the base16 derivation approach of ADR 0002 is superseded.
