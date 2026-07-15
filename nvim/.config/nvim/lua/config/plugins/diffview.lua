return {
  "sindrets/diffview.nvim",
  cmd = { "DiffviewOpen", "DiffviewFileHistory", "DiffviewClose" },
  keys = {
    { "<leader>Vd", "<cmd>DiffviewOpen<cr>", desc = "Diffview open" },
    { "<leader>Vh", "<cmd>DiffviewFileHistory %<cr>", desc = "File history" },
    { "<leader>VH", "<cmd>DiffviewFileHistory<cr>", desc = "Branch history" },
    { "<leader>Vq", "<cmd>DiffviewClose<cr>", desc = "Diffview close" },
  },
}
