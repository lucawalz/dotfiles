return {
  "folke/sidekick.nvim",
  opts = {
    nes = { enabled = false },
    cli = {
      watch = true,
    },
  },
  keys = {
    { "<leader>aa", function() require("sidekick.cli").toggle() end, mode = { "n", "v" }, desc = "Sidekick toggle" },
    {
      "<leader>ac",
      function() require("sidekick.cli").toggle({ name = "claude", focus = true }) end,
      mode = { "n", "v" },
      desc = "Sidekick Claude",
    },
    {
      "<leader>ap",
      function() require("sidekick.cli").prompt() end,
      mode = { "n", "v" },
      desc = "Sidekick ask prompt",
    },
    {
      "<leader>at",
      function() require("sidekick.cli").send({ msg = "{this}" }) end,
      mode = { "n", "x" },
      desc = "Sidekick send this",
    },
    {
      "<leader>av",
      function() require("sidekick.cli").send({ selection = true }) end,
      mode = { "x" },
      desc = "Sidekick send selection",
    },
    { "<leader>af", function() require("sidekick.cli").send({ msg = "{file}" }) end, desc = "Sidekick send file" },
  },
}
