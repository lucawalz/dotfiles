return {
  "echasnovski/mini.ai",
  event = { "BufReadPre", "BufNewFile" },
  opts = function()
    local gen_spec = require("mini.ai").gen_spec
    return {
      custom_textobjects = {
        f = false,
        F = gen_spec.function_call(),
      },
    }
  end,
}
