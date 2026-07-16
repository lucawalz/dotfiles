return {
  "nvimtools/hydra.nvim",
  event = "VeryLazy",
  config = function()
    local Hydra = require("hydra")
    local gs = require("gitsigns")

    local git_hint = [[
                    Git

    _J_: next hunk     _d_: show deleted
    _K_: prev hunk     _u_: undo last stage
    _s_: stage hunk    _/_: show base file
    _p_: preview hunk  _S_: stage buffer
    _b_: blame line    _B_: blame show full
  ^
    _<Enter>_: Neogit       _<Esc>_: Exit
]]

    Hydra({
      name = "Git",
      hint = git_hint,
      config = {
        color = "red",
        invoke_on_body = true,
        hint = { position = "middle", float_opts = { border = "solid" } },
        on_enter = function()
          vim.cmd("silent! mkview")
          vim.cmd("silent! %foldopen!")
          gs.toggle_linehl(true)
        end,
        on_exit = function()
          local pos = vim.api.nvim_win_get_cursor(0)
          vim.cmd("silent! loadview")
          pcall(vim.api.nvim_win_set_cursor, 0, pos)
          vim.cmd("normal! zv")
          gs.toggle_linehl(false)
          gs.toggle_deleted(false)
        end,
      },
      mode = { "n", "x" },
      body = "<leader>g",
      heads = {
        { "J", function()
          if vim.wo.diff then
            return "]c"
          end
          vim.schedule(function() gs.next_hunk() end)
          return "<Ignore>"
        end, { expr = true, desc = "next hunk" } },
        { "K", function()
          if vim.wo.diff then
            return "[c"
          end
          vim.schedule(function() gs.prev_hunk() end)
          return "<Ignore>"
        end, { expr = true, desc = "prev hunk" } },
        { "s", ":Gitsigns stage_hunk<CR>", { silent = true, desc = "stage hunk" } },
        { "u", function() gs.undo_stage_hunk() end, { desc = "undo last stage" } },
        { "S", function() gs.stage_buffer() end, { desc = "stage buffer" } },
        { "p", function() gs.preview_hunk() end, { desc = "preview hunk" } },
        { "d", function() gs.toggle_deleted() end, { nowait = true, desc = "toggle deleted" } },
        { "b", function() gs.blame_line() end, { desc = "blame" } },
        { "B", function() gs.blame_line({ full = true }) end, { desc = "blame show full" } },
        { "/", function() gs.show() end, { exit = true, desc = "show base file" } },
        { "<Enter>", function() vim.cmd("Neogit") end, { exit = true, desc = "Neogit" } },
        { "<Esc>", nil, { exit = true, nowait = true } },
      },
    })

    local resize_hint = [[
                  Resize
    _h_: narrower   _j_: shorter
    _l_: wider      _k_: taller
  ^
    _b_: balance    _<Esc>_: exit
]]

    Hydra({
      name = "Resize",
      hint = resize_hint,
      config = {
        color = "red",
        invoke_on_body = true,
        hint = { position = "middle", float_opts = { border = "solid" } },
      },
      mode = "n",
      body = "<leader>sr",
      heads = {
        { "h", "<C-w>3<", { desc = "narrower" } },
        { "j", "<C-w>2-", { desc = "shorter" } },
        { "k", "<C-w>2+", { desc = "taller" } },
        { "l", "<C-w>3>", { desc = "wider" } },
        { "b", "<C-w>=", { desc = "balance" } },
        { "<Esc>", nil, { exit = true, nowait = true } },
      },
    })
  end,
}
