local RESIZE_STEP = 2

require("smart-splits").setup({ default_amount = RESIZE_STEP, at_edge = "stop" })

local splits = require("smart-splits")
local function map(lhs, fn, desc) vim.keymap.set("n", lhs, fn, { desc = desc, silent = true }) end

map("<C-h>", splits.move_cursor_left, "Go to left window or pane")
map("<C-j>", splits.move_cursor_down, "Go to lower window or pane")
map("<C-k>", splits.move_cursor_up, "Go to upper window or pane")
map("<C-l>", splits.move_cursor_right, "Go to right window or pane")

map("<C-Up>", splits.resize_up, "Increase window height")
map("<C-Down>", splits.resize_down, "Decrease window height")
map("<C-Left>", splits.resize_left, "Decrease window width")
map("<C-Right>", splits.resize_right, "Increase window width")
