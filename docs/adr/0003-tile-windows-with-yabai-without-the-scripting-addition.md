---
status: superseded by 0004
date: 2026-07-16
---

# 0003. Tile windows with yabai without the scripting addition

Superseded by [ADR 0004](0004-adopt-aerospace-with-leader-key-and-karabiner.md).

## Context

Adding SketchyBar exposed a gap that no status bar can close on its own. A bar drawn by a third party occupies screen area that macOS does not know is taken, so a maximised window either covers the bar or, with the bar forced above windows, is overlapped by it and shows through its translucent background. Neither state is correct. Only a window manager that owns the layout can reserve the strip, which made window management a prerequisite for the bar rather than a separate concern.

System Integrity Protection is enabled on this machine, an Apple Silicon MacBook Pro running macOS 26.5.2. This constrains the options, because macOS exposes no public API for moving windows between spaces, setting window opacity, or animating windows. yabai reaches those through a scripting addition that injects code into Dock.app, which is precisely what SIP prevents, so the addition requires partially disabling SIP and reducing the boot security policy.

That cost is not abstract here. This machine holds the SOPS age key that decrypts the cluster's secrets, a kubeconfig, and a Tailscale route into the trusted server VLAN. Disabling SIP removes a layer that constrains what a compromised dependency can reach on the one machine that can decrypt the infrastructure. The addition also carries an open upstream issue for macOS 26 support and a report of breakage after 26.2, so the security reduction may not even buy working features on this version.

The decisive question was therefore which yabai features survive with SIP enabled. Rather than infer this from the upstream list of features that require the addition, each was exercised on this machine. Binary space partitioning works. `external_bar` works: with four windows open the tiling area began at y=50, the 42 pixel bar offset plus 8 pixels of padding, so the strip was genuinely reserved. Focusing a space works, and so does moving a window to another space, both of which the wording of the upstream list suggests otherwise until read closely, since it names moving, swapping, creating, and destroying a space rather than focusing one. Creating a space fails with an explicit scripting-addition error. Animations, opacity, and shadow control require the addition.

The surviving set is therefore large enough that the addition buys only animations, opacity, and creating spaces from the keyboard.

## Decision

yabai tiles windows with the scripting addition absent and SIP left enabled, configured through `yabai/.config/yabai/yabairc` as a Stow package. `layout bsp` partitions the space, `external_bar main:42:0` reserves the SketchyBar strip, and `window_gap 8` with matching padding leaves gaps between windows and against the screen edges.

skhd binds the keys, because yabai has no binding system of its own. The modifier is `alt`, since `cmd` collides with both macOS shortcuts and the Ghostty split bindings already in use.

The configuration is limited to commands that were confirmed to function without the scripting addition: focus, warp, resize, fullscreen zoom, float toggle, rotate, mirror, balance, focusing a space, and moving a window to a space. Creating a space is absent, because it fails without the addition, so spaces are created through Mission Control and the bindings address the ones that exist.

## Options considered

- yabai with the scripting addition and SIP partially disabled, rejected for now. It is the only configuration that provides window animations, window opacity, and moving windows between spaces. It requires a recoveryOS boot, a reduced boot security policy, and a sudoers entry re-run after every yabai upgrade, on a machine holding infrastructure credentials. Its macOS 26 support is unresolved upstream. This record does not foreclose the change; it records that the price was not worth paying while the benefit is uncertain.
- AeroSpace, rejected. It is SIP-safe, has a binding system built in, and needs no scripting addition, which makes it the cheaper option on paper. It has no binary space partitioning layout at all, only horizontal tiles, vertical tiles, and two accordions, so windows accumulate in a single row rather than partitioning the space. Testing confirmed eight windows produced a single row of eight columns. It also emulates workspaces by moving windows off-screen rather than using native spaces.
- Retaining Raycast for window management, rejected. It snaps a window on request and maintains no layout, so it cannot reserve the bar strip. It was also the only remaining use of Raycast on this machine.

## Consequences

The bar strip is reserved and windows tile below it, with gaps, and SIP stays enabled. Raycast is no longer needed for anything.

skhd is a new dependency, so the count of window management tools did not drop. It is a small hotkey daemon whose configuration is a text file in this repository, which is a better trade than a closed application, but it is a trade rather than a removal.

Spaces are focused with `alt` and a digit, and a window is sent to one with `shift` and the same, both of which work with the addition absent. Spaces themselves cannot be created from the keyboard, so they are added through Mission Control and the bindings then address them. Animations and window opacity are unavailable, which on this machine is a minor loss: it already sustains high GPU utilisation driving two 144 Hz displays, so additional per-frame compositing would be unwelcome.

Binary space partitioning splits the focused window along its longer axis, so opening four windows in sequence produces a spiral rather than a grid: the first window keeps half the screen and each subsequent window subdivides the previous one. This is how partitioning works, and dwindle layouts elsewhere behave the same way. A two by two grid is reachable, but it is arranged rather than automatic: warping a window across the tree with `shift + alt` and a direction rebalances the partition into quadrants. No layout in yabai produces a grid without that step.

Both yabai and skhd require Accessibility permission, which must be granted through System Settings and cannot be scripted.
