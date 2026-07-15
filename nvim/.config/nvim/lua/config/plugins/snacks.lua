return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  opts = {
    bigfile = { enabled = true },
    quickfile = { enabled = true },
    scroll = { enabled = true },
    words = { enabled = true },
    zen = { enabled = true },
  },
  keys = {
    { "<leader>z", function() Snacks.zen() end, desc = "Zen mode" },
  },
}
