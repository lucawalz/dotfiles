---
status: accepted
date: 2026-09-01
---

# 0009. Remove SketchyBar and use the native menu bar

Supersedes [ADR 0005](0005-adopt-aerospace-with-raycast-and-sketchybar-via-sbarlua.md).

## Context

ADR 0005 adopted AeroSpace with Raycast and a SketchyBar status bar built on SbarLua. The bar proved inconvenient in daily use, and it carried a setup cost out of proportion to what it returned. SbarLua is not packaged by Homebrew and has to be compiled from source, SF Pro has to be installed by hand because Apple does not ship it as a cask, and the bar needed its own brew service started before it would appear at all. The `sketchybar/` package was 29 files, the largest in the repository.

AeroSpace, Raycast and JankyBorders were never the problem. Nothing in this record concerns them beyond the gap and binding details the bar imposed on the AeroSpace configuration.

## Decision

SketchyBar is removed and the native macOS menu bar takes its place. The `sketchybar/` Stow package is deleted. The `sketchybar`, `nowplaying-cli` and `lua` formulae and the `font-sketchybar-app-font` cask leave the Brewfile. The `FelixKratz/formulae` tap stays, because JankyBorders is published there.

AeroSpace keeps tiling windows along with its resize and service modes. The nine keybindings that also notified the bar collapse to their window management command alone, and the `outer.top` gap drops from 54 to 12 because there is no bar strip left to reserve.

## Consequences

The native menu bar has to be visible again. Automatic menu bar hiding was enabled by hand so that the two bars would not stack, and that setting is not controlled by anything in this repository, so restoring it is a manual step in System Settings. Without it the machine shows no top bar at all.

Bootstrap gets shorter. Two of the three manual steps documented in ADR 0007 disappear, leaving Accessibility permissions and the menu bar setting. That weakens but does not invalidate the reasoning in ADR 0007, since the Makefile still orchestrates brew and stow.

The Carbonfox exception recorded in ADR 0006 is void. That record documented one deliberate deviation from the palette, a warning yellow, and it lived in `sketchybar/.config/sketchybar/colors.lua`. With that file gone the repository has no non-Carbonfox colour left.

ADR 0008 justified keeping `nowplaying-cli` in the core Brewfile because the SketchyBar media widget called it. That justification no longer applies and the formula is removed. The ownership rule ADR 0008 established is unaffected.

Status information the bar displayed is no longer surfaced on screen: battery, CPU, media, Wi-Fi, GitHub notifications, and the AeroSpace workspace and mode indicators. The workspace indicator is the notable loss, since AeroSpace has no built-in equivalent. `btop` and `fastfetch` remain available in a terminal.

ADRs 0006, 0007 and 0008 keep their original text. They record what was decided when it was decided, and this record carries the reversal instead.
