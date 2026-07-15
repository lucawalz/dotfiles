return {
  "MagicDuck/grug-far.nvim",
  cmd = "GrugFar",
  opts = {},
  keys = {
    { "<leader>rf", function() require("grug-far").open() end, desc = "Find & replace in files" },
  },
}
