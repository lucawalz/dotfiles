return {
  "obsidian-nvim/obsidian.nvim",
  version = "*",
  ft = "markdown",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  opts = {
    legacy_commands = false,
    workspaces = {
      { name = "notes", path = "~/notes" },
    },
    ui = { enable = false },
  },
  keys = {
    { "<leader>on", "<cmd>Obsidian new<cr>", desc = "New note" },
    { "<leader>oo", "<cmd>Obsidian quick_switch<cr>", desc = "Quick switch note" },
    { "<leader>os", "<cmd>Obsidian search<cr>", desc = "Search notes" },
    { "<leader>ob", "<cmd>Obsidian backlinks<cr>", desc = "Backlinks" },
    { "<leader>ot", "<cmd>Obsidian today<cr>", desc = "Today's note" },
  },
}
