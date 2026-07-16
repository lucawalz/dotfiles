---
status: accepted
date: 2026-07-16
---

# 0004. Adopt AeroSpace with Leader Key and Karabiner

Supersedes [ADR 0003](0003-tile-windows-with-yabai-without-the-scripting-addition.md).

## Context

Living with the yabai configuration surfaced costs that the original evaluation missed. Switching spaces flickers the JankyBorders border, worse with two displays, and the issue is open upstream with no fix in sight. yabai tracks each macOS release closely and macOS 26 carries several open regressions for it, so every OS update risks a broken window manager. Space focus rides on native Spaces, which macOS animates and which cannot be created from the keyboard without the scripting addition.

The ground on which ADR 0003 rejected AeroSpace also did not survive re-testing. That record states AeroSpace "has no binary space partitioning layout at all" and accumulates windows in a single row. Exercised side by side, the difference is smaller than the wording suggests: bsp splits along the longer axis and produces a spiral, not a grid, so a two by two layout needs a manual warp under yabai exactly as it needs a manual join under AeroSpace. Both reach the grid in one keystroke; neither reaches it automatically.

AeroSpace emulates workspaces instead of using native Spaces, which makes switching instant and animation free, needs no scripting addition and no Accessibility hack, and ships its own binding system, which removes the skhd dependency. Workspaces are virtual, exist lazily, and can be pinned to displays.

Two auxiliary tools complete the setup. Global hotkeys are a scarce resource, so only focus, move, workspace, and resize bindings stay global; every rarer window command lives behind Leader Key, a sequence launcher. Leader Key needs a trigger key, which Karabiner provides by remapping Caps Lock to F19. Karabiner grabs the keyboard through a virtual HID device, which bypasses the modifier remapping configured in System Settings, so the command and option swap on the external keyboard moves into Karabiner as well.

Focus movement should not care whether the boundary being crossed is a Neovim split, a window, or a display. The only existing bridge, coxley/aerospace-focus.nvim, is an unmaintained two star plugin with a dead health check and no recovery from a stale RPC socket, and its default scheme surrenders ctrl h, j, k, and l globally, killing readline bindings in every application.

## Decision

AeroSpace tiles windows, configured through the `aerospace` Stow package. Workspaces 1 to 5 are pinned to displays through `workspace-to-monitor-force-assignment`. Gaps come from the `[gaps]` table, and the top gap reserves the SketchyBar strip, replacing yabai's `external_bar`.

The global binding surface stays minimal: `alt` with a direction moves the window, `alt shift` with a direction focuses, `alt` with a digit switches workspace, `alt shift` with a digit sends a window to one, and `alt r` enters a resize mode. Moving got the lighter chord because it is the more frequent action here. Everything else, application launching, join, layout, fullscreen, balance, lives in Leader Key sequences stored in the `leader-key` package.

Karabiner remaps Caps Lock to F19 as the Leader Key trigger and carries the command and option swap for the external keyboard, stored in the `karabiner` package. Both remaps live in one tool because the virtual keyboard makes Karabiner the only layer that still sees the physical keys.

Seamless focus is a local module rather than the plugin: around fifty lines in `nvim/.config/nvim/lua/config/aerospace-focus.lua` plus `aerospace/.config/aerospace/scripts/focus.sh`. A focused Neovim instance records its RPC socket in a lock file; the script forwards `alt` direction presses into it with `nvim --server --remote-expr`, and Neovim walks its splits first and falls back to `aerospace focus` at the edge. A stale lock self-heals, headless instances never claim the lock, and no ctrl key is sacrificed.

The `yabai` and `skhd` packages are removed.

## Options considered

- Keep yabai, rejected. The border flicker and the macOS 26 regression tail are ongoing costs, and space creation still needs Mission Control.
- yabai with the scripting addition, rejected for the reasons in ADR 0003, all of which still hold.
- AeroSpace with the ctrl based navigation scheme from aerospace-focus.nvim, rejected. Binding ctrl h, j, k, and l globally destroys backspace, kill line, and clear screen in every application.
- Adopting coxley/aerospace-focus.nvim as a dependency, rejected. The mechanism is sound but the project is unmaintained, spawns a headless Neovim per keypress, and fails open when the recorded socket is dead. Fifty lines of local code replace it.

## Consequences

Workspace switching is instant and flicker free, and workspaces need no Mission Control setup. skhd is gone; Karabiner and Leader Key arrive, so the tool count is unchanged. Karabiner brings a DriverKit extension that must be approved by hand in System Settings, and only AeroSpace needs Accessibility permission.

AeroSpace workspaces exist lazily, so `aerospace list-workspaces --all` omits empty ones. The SketchyBar workspace items are therefore hardcoded to 1 through 5 rather than enumerated at bar startup, which is also the set the bindings and display pins define.

Minimized and hidden windows kept their slot in the tile tree and left holes in the layout; `automatically-unhide-macos-hidden-apps` handles the hidden case, and minimizing is replaced by sending the window to another workspace.

The modifier swap on the external keyboard now lives in `karabiner/.config/karabiner/karabiner.json` instead of System Settings. Reverting to yabai means restoring the two packages from git history and re-running their services; nothing outside the repository needs to change back except the Karabiner driver approval.
