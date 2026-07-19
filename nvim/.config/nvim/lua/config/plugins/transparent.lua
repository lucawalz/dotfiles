return {
  "xiyaowong/transparent.nvim",
  lazy = false,
  priority = 999,
  opts = {
    extra_groups = {
      "NormalFloat",
      "FloatBorder",
      "FloatTitle",
      "Pmenu",
      "PmenuSbar",
      "PmenuThumb",
      "StatusLine",
      "StatusLineNC",
      "WhichKeyFloat",
      "MasonNormal",
      "LazyNormal",
      "CursorLine",
      "SignColumn",
    },
  },
  config = function(_, opts)
    local transparent = require("transparent")
    transparent.setup(opts)
    for _, prefix in ipairs({ "lualine", "BufferLine", "Telescope", "NvimTree", "Notify", "Noice", "Hydra" }) do
      transparent.clear_prefix(prefix)
    end
    transparent.toggle(true)
  end,
}
