---
status: accepted
date: 2026-07-18
---

# 0005. Adopt AeroSpace with Raycast and SketchyBar via SbarLua

Supersedes [ADR 0004](0004-adopt-aerospace-with-leader-key-and-karabiner.md).

## Context

The setup recorded in ADR 0004 leaned on two auxiliary tools to reach the rarer window commands. Leader Key held every command that did not earn a global hotkey, and Karabiner supplied its trigger by remapping Caps Lock to F19 while also carrying the command and option swap for the external keyboard. Living with that arrangement showed the trigger chain to be more machinery than the payoff justified: Karabiner grabs the keyboard through a virtual HID device and installs a DriverKit extension, a driver approved by hand and reasserted across updates, in service of turning one key into a sequence launcher. AeroSpace already ships a binding system with named modes, so the same rarer commands fit inside its own configuration without a second daemon or a driver.

JankyBorders draws a colored border around the focused window from the shared palette. It flickered on space switches under the earlier yabai setup, but AeroSpace uses its own virtual workspaces rather than native macOS spaces, so the border stays steady. It is retained as a clear focus cue drawn from the same palette as the rest of the desktop.

SketchyBar had grown past what a shell configuration expresses cleanly. The bar carries workspace items, an AeroSpace mode indicator, and a media widget, and the branching and state that logic needs read poorly as sketchybarrc shell. SbarLua exposes the same bar through a Lua API, which turns event handlers and item definitions into ordinary functions and tables.

ADR 0003 rejected Raycast for window management and recorded that Raycast was no longer needed for anything. That reasoning held only while Raycast was being judged as a tiler. As a launcher on Cmd-Space it replaces the role Leader Key played for launching applications, so the earlier claim no longer describes the machine.

## Decision

AeroSpace continues to tile windows through the `aerospace` Stow package, with workspaces 1 to 5 pinned to displays and the top gap reserving the SketchyBar strip.

Window commands move onto AeroSpace native bindings. The global surface stays small: `alt` with a direction moves the window, `alt shift` with a direction focuses across Neovim splits and windows and displays, `alt` with a digit switches workspace, `alt shift` with a digit sends a window to one, and `alt tab` returns to the previous workspace. Two named modes hold the rest. `alt shift r` enters a resize mode where the direction keys resize, `minus` and `equal` resize smart, `b` balances, and `enter` or `esc` returns to the main mode. `alt shift semicolon` enters a service mode offering join with a direction, the tiles, accordion, and floating layouts, fullscreen, balance, flatten, and config reload, staying active until `enter` or `esc` returns to the main mode. The Leader Key and Karabiner packages are removed.

Raycast is the launcher, bound to Cmd-Space, installed as the `raycast` cask. Its settings are not stowed, so there is no Raycast Stow package.

SketchyBar is configured in Lua through SbarLua, kept in the `sketchybar` package. The bar, its items, and its event handlers are Lua rather than shell.

## Options considered

- Keep Leader Key and Karabiner, rejected. The DriverKit driver and the virtual keyboard are a large mechanism for a sequence launcher, and AeroSpace modes cover the same commands with no extra daemon.
- Keep the SketchyBar shell configuration, rejected. The workspace, mode, and media logic outgrew what sketchybarrc expresses clearly, and SbarLua carries the same bar with real control flow.

## Consequences

SbarLua is a new dependency that Homebrew cannot install: it is built from source and needs `lua` and `clang` present, so it is documented in the README rather than listed in the Brewfile. The media widget reads now playing state through `nowplaying-cli`, added as a brew. The bar renders in SF Pro, which is installed by hand into `~/Library/Fonts` because Apple does not distribute it through a cask.

Removing Karabiner takes its DriverKit extension with it, which may need a reboot to fully unload, and the command and option swap for the external keyboard returns to System Settings, Keyboard, Modifier Keys, where it lived before Karabiner claimed it.

The tool count drops. skhd was already gone, and Leader Key and Karabiner leave with this change, so the desktop runs on AeroSpace, SketchyBar, JankyBorders, and Raycast. Reverting means restoring the removed packages from git history and re-approving the Karabiner driver.
