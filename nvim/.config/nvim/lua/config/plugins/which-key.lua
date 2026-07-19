return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  init = function()
    vim.o.timeout = true
    vim.o.timeoutlen = 500
  end,
  opts = {
    spec = {
      { "<leader>a", group = "ai" },
      { "<leader>b", group = "buffer" },
      { "<leader>c", group = "code" },
      { "<leader>d", group = "debug" },
      { "<leader>f", group = "find" },
      { "<leader>g", desc = "Git hydra" },
      { "<leader>h", group = "git hunks" },
      { "<leader>V", group = "diff view" },
      { "<leader>o", group = "obsidian" },
      { "<leader>r", group = "rename/replace" },
      { "<leader>s", group = "split" },
      { "<leader>t", group = "test" },
      { "<leader>u", group = "ui/toggle" },
      { "<leader>w", group = "session" },
      { "<leader>x", group = "diagnostics" },
    },
  },
}
