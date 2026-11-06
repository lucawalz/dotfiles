---
status: accepted
date: 2026-11-05
---

# 0011. Manage Neovim plugins with vim.pack

## Context

The Neovim configuration began as a copy of another author's setup and grew by accretion. It ran 65 plugins including dependencies, spread over 44 specification files, with overlap in every area: two pickers, two file explorers, four git interfaces, and three message layers. Each overlap was a second tool to learn, configure, and keep updated for a job one tool already did.

The way the editor is used has also changed. Claude Code now edits files in its own Ghostty split while Neovim is used to read, review, and commit. That makes reviewing agent changes the main job: seeing the whole change set, stepping through hunks in a file, committing from lazygit, and sending a file location or selection back to the agent. Buffers also have to pick up edits made from outside the editor.

Neovim 0.12 covers several things that previously needed plugins. `vim.pack` installs, updates, and locks plugins, `vim.lsp.enable` with `after/lsp/<server>.lua` configures language servers, `:restart` reloads the editor, and `gc` comments lines. The package manager, lazy.nvim, no longer earns its place for a configuration this size.

## Decision

Plugins are managed with `vim.pack`, declared in a single `vim.pack.add` call in `nvim/.config/nvim/lua/config/plugins/init.lua`. The lockfile `nvim-pack-lock.json` is committed in the `nvim` package, so a fresh machine installs the exact revisions recorded in the repository. Nothing is lazy-loaded; deferral is added only if startup proves measurably slow.

The set follows one tool per job and stays at 35 plugins, at a cap of 35 (raised to 36 by [ADR 0012](0012-adopt-tmux-for-terminal-splits.md) for smart-splits.nvim). The five mini modules come from the single `nvim-mini/mini.nvim` repository. snacks.nvim provides the picker, dashboard, indent guides, zoom, and lazygit float. nvim-tree is the sidebar file explorer on `<leader>e`, oil.nvim edits a directory as a buffer on `-`, blink.cmp the completion engine, and conform.nvim and nvim-lint handle formatting and linting.

The visual plugins are kept for the owner's look: noice with nvim-notify and nui.nvim own the command line and messages, smear-cursor animates the cursor, tiny-inline-diagnostic draws diagnostics, and bufferline shows tabs. The built-in ui2 message layer is not used, and the snacks notifier is disabled so nvim-notify is the only notification view. Highlight backgrounds are cleared on every colorscheme change, which keeps the transparent UI without a transparency plugin.

The agent stays in its own Ghostty split. No in-editor agent plugin is added, because the split already works and the editor only needs to hand context to it.

Review uses two plugins and one external tool. gitsigns.nvim covers in-file hunks: signs, navigation on `]h` and `[h`, staging, blame, and inline preview. mini.diff was considered for its overlay and not added, since gitsigns already covers that ground. codediff.nvim shows whole change sets and file or repository history, and lazygit opens in a snacks float for committing. The `]c` and `[c` keys remain treesitter class motions. Three helpers in `lua/config/agent.lua` send context back to the agent: `<leader>yf` and `<leader>yp` yank a relative or absolute path with a line number, and `<leader>cc` yanks a visual selection as a fenced Markdown block with its file and line range.

A new `lazygit` Stow package configures delta as the diff renderer and turns `autoFetch` off, and the Brewfile gains `lazygit`. A headless smoke test, run with `make check-nvim`, loads every module, checks the expected mappings, and fails if a removed plugin loads or the plugin count passes the cap.

## Consequences

Plugin rollback runs through git. Reverting `nvim-pack-lock.json`, restarting, and running `vim.pack.update(nil, { target = "lockfile" })` followed by confirming the buffer restores the previous revisions, which replaces `lazy-lock.json` and `:Lazy restore`. `vim.pack` does not prune lockfile entries for removed plugins, so removing a plugin also means deleting its lockfile entry or regenerating the lockfile.

`vim.pack` is still marked experimental in Neovim 0.12, so its interface may change in a later release. The configuration depends on it directly, and an upgrade may require a small edit to the plugin list or the build hooks.

The visual plugins and the nvim-tree sidebar add seven entries to the lockfile and keep the lazy.nvim-era look, at the cost of a larger plugin set than the one-tool-per-job rule alone would allow.

Several plugins were dropped. The debugger stack (dap) and the test runner stack (neotest) had no evidence of use and can be re-added if missed. obsidian.nvim was removed because notes are edited in the Obsidian app. telescope, neogit, diffview, and the other overlapping tools were removed in favour of their single replacements, and the mappings that belonged to them moved to the replacement. The git and resize hydras are gone: their actions are plain mappings under `<leader>g` and `<leader>h`, and the `<C-arrow>` keys resize splits.

The configuration is smaller and starts from one lockfile, but it now owns responsibilities lazy.nvim handled, such as build hooks for plugins that compile or download on install. Those hooks live above the `vim.pack.add` call.
