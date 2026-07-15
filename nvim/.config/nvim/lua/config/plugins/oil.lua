return {
  "stevearc/oil.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  lazy = false,
  opts = {
    default_file_explorer = false,
    view_options = {
      show_hidden = true,
    },
    keymaps = {
      ["<Esc>"] = "actions.close",
      ["q"] = "actions.close",
    },
  },
  keys = {
    { "-", "<cmd>Oil<cr>", desc = "Open parent directory (oil)" },
  },
}
