---
status: accepted
date: 2026-09-03
---

# 0010. Balance workspaces evenly across two displays

## Context

ADR 0004 introduced `workspace-to-monitor-force-assignment` and pinned five workspaces to displays, three to the main one and two to the second. ADR 0005 restated that arrangement. Both records are superseded, ADR 0009 replaced 0005 on the status bar alone and did not carry the workspace decision forward, so no accepted record states the layout.

The split is also lopsided. Three rooms on one display and two on the other does not reflect how the displays are used, and the second display runs out of workspaces first.

The machine is used with at most two displays, in one of two shapes: the built-in panel with one external, or two externals with the lid closed. Monitors are swapped from time to time, so the assignment must not depend on a display name, a resolution, or an orientation. It also has to degrade sensibly when only one display is attached.

## Decision

Eight workspaces are pinned in two even halves, 1 to 4 on `main` and 5 to 8 on `secondary`. The `[mode.main.binding]` table gains `alt-6`, `alt-7` and `alt-8` to focus the new workspaces and their shifted forms to send a window to one. None of those keys was bound before.

`main` and `secondary` are AeroSpace's own monitor patterns and carry no hardware identity. `main` is the display macOS puts the menu bar on and `secondary` is the other one, so the configuration holds no monitor name and survives any change of hardware.

The halves stay contiguous rather than interleaved, so a digit's position in the number row maps to a position on screen.

## Consequences

Which physical display holds 1 to 4 becomes a System Settings choice rather than a configuration edit. Dragging the menu bar between displays swaps the halves, and that setting is not controlled by anything in this repository.

`secondary` resolves only when exactly two displays are connected. On a single display it matches nothing and every workspace falls back to the one screen, which is the wanted behaviour for a laptop on its own. A third display would leave 5 to 8 unpinned rather than assigning them somewhere arbitrary, an acceptable limit for a setup that never exceeds two.

Reconnecting a display does not pull an already focused workspace onto its assigned monitor. Focusing any other workspace first applies the pins correctly. This is upstream behaviour and it applied to the previous five workspace arrangement too.

Three more workspaces cost nothing until they are used, because AeroSpace creates workspaces lazily and an empty one holds no state.

ADRs 0004 and 0005 keep their original text. They record what was decided when it was decided, and this record carries the change instead.
