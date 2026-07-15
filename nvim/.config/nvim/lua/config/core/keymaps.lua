vim.g.mapleader = " "
vim.g.maplocalleader = " "

local keymap = vim.keymap

local function map(mode, lhs, rhs, desc, opts)
  opts = vim.tbl_extend("force", { desc = desc, silent = true }, opts or {})
  keymap.set(mode, lhs, rhs, opts)
end

map("i", "jj", "<Esc>", "Exit insert mode")
map("i", "jk", "<Esc>", "Exit insert mode")
map("n", "<Esc>", "<cmd>nohlsearch<CR>", "Clear search highlight")

map({ "n", "i", "x" }, "<C-s>", "<Esc><cmd>write<CR>", "Save file")
map("n", "<leader>q", "<cmd>confirm quit<CR>", "Quit window")
map("n", "<leader>Q", "<cmd>confirm qall<CR>", "Quit all")

map("n", "<C-h>", "<C-w>h", "Go to left window")
map("n", "<C-j>", "<C-w>j", "Go to lower window")
map("n", "<C-k>", "<C-w>k", "Go to upper window")
map("n", "<C-l>", "<C-w>l", "Go to right window")

map("n", "<C-Up>", "<cmd>resize +2<CR>", "Increase window height")
map("n", "<C-Down>", "<cmd>resize -2<CR>", "Decrease window height")
map("n", "<C-Left>", "<cmd>vertical resize -2<CR>", "Decrease window width")
map("n", "<C-Right>", "<cmd>vertical resize +2<CR>", "Increase window width")

map("n", "<leader>sv", "<C-w>v", "Split vertically")
map("n", "<leader>sh", "<C-w>s", "Split horizontally")
map("n", "<leader>se", "<C-w>=", "Equalize splits")
map("n", "<leader>sx", "<cmd>close<CR>", "Close split")

map("n", "<S-l>", "<cmd>BufferLineCycleNext<CR>", "Next buffer")
map("n", "<S-h>", "<cmd>BufferLineCyclePrev<CR>", "Previous buffer")
map("n", "<leader>bd", "<cmd>bdelete<CR>", "Delete buffer")
map("n", "<leader>bb", "<cmd>e #<CR>", "Switch to other buffer")

map("n", "<C-p>", "<cmd>Telescope find_files<CR>", "Find files")

map("n", "<C-/>", "gcc", "Toggle comment", { remap = true })
map("x", "<C-/>", "gc", "Toggle comment", { remap = true })
map("n", "<C-_>", "gcc", "Toggle comment", { remap = true })
map("x", "<C-_>", "gc", "Toggle comment", { remap = true })

map("v", "<", "<gv", "Indent left")
map("v", ">", ">gv", "Indent right")
map("v", "J", ":m '>+1<CR>gv=gv", "Move selection down")
map("v", "K", ":m '<-2<CR>gv=gv", "Move selection up")

map("n", "n", "nzzzv", "Next search result")
map("n", "N", "Nzzzv", "Previous search result")
map("n", "<C-d>", "<C-d>zz", "Scroll down centered")
map("n", "<C-u>", "<C-u>zz", "Scroll up centered")

map("x", "<D-c>", '"+y', "Copy selection to clipboard")
map("n", "<D-c>", '"+yy', "Copy line to clipboard")
map("x", "<D-x>", '"+d', "Cut selection to clipboard")
map({ "n", "x" }, "<D-v>", '"+p', "Paste from clipboard")
map("i", "<D-v>", "<C-r>+", "Paste from clipboard")
map("c", "<D-v>", "<C-r>+", "Paste from clipboard")
map("n", "<D-a>", "ggVG", "Select all")
map("x", "<D-a>", "<Esc>ggVG", "Select all")
map({ "n", "i", "x" }, "<D-s>", "<Esc><cmd>write<CR>", "Save file")
map({ "n", "x" }, "<D-z>", "u", "Undo")
map("i", "<D-z>", "<C-o>u", "Undo")
map({ "n", "x" }, "<D-Z>", "<C-r>", "Redo")
