require("gitsigns").setup({
  on_attach = function(bufnr)
    local gs = package.loaded.gitsigns

    local function map(mode, l, r, desc) vim.keymap.set(mode, l, r, { buffer = bufnr, desc = desc }) end

    map("n", "]h", function() gs.nav_hunk("next") end, "Next Hunk")
    map("n", "[h", function() gs.nav_hunk("prev") end, "Prev Hunk")

    map("n", "<leader>hs", gs.stage_hunk, "Stage hunk")
    map("n", "<leader>hr", gs.reset_hunk, "Reset hunk")
    map("v", "<leader>hs", function() gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") }) end, "Stage hunk")
    map("v", "<leader>hr", function() gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") }) end, "Reset hunk")

    map("n", "<leader>hS", gs.stage_buffer, "Stage buffer")
    map("n", "<leader>hR", gs.reset_buffer, "Reset buffer")

    map("n", "<leader>hu", gs.stage_hunk, "Toggle stage hunk")

    map("n", "<leader>hp", gs.preview_hunk, "Preview hunk")
    map("n", "<leader>hi", gs.preview_hunk_inline, "Preview hunk inline")

    map("n", "<leader>hb", function() gs.blame_line({ full = true }) end, "Blame line")
    map("n", "<leader>hB", gs.toggle_current_line_blame, "Toggle line blame")

    map("n", "<leader>hd", gs.diffthis, "Diff this")
    map("n", "<leader>hD", function() gs.diffthis("~") end, "Diff this ~")

    map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "Gitsigns select hunk")
  end,
})

require("codediff").setup()

vim.keymap.set("n", "<C-g>", function() Snacks.lazygit() end, { desc = "Open lazygit" })
vim.keymap.set("n", "<leader>gg", function() Snacks.lazygit() end, { desc = "Lazygit" })
vim.keymap.set("n", "<leader>gv", "<cmd>CodeDiff<cr>", { desc = "Toggle CodeDiff" })
vim.keymap.set("n", "<leader>gh", "<cmd>CodeDiff history %<cr>", { desc = "File history" })
vim.keymap.set("n", "<leader>gH", "<cmd>CodeDiff history<cr>", { desc = "Repo history" })
vim.keymap.set("n", "<leader>gp", function() Snacks.picker.git_diff() end, { desc = "Git diff hunks" })
vim.keymap.set(
  "n",
  "<leader>gd",
  function() require("gitsigns").preview_hunk_inline() end,
  { desc = "Show deleted lines inline" }
)
