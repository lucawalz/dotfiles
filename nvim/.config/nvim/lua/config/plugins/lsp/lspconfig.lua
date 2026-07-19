return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    { "antosha417/nvim-lsp-file-operations", config = true },
    { "folke/lazydev.nvim", ft = "lua", opts = {} },
    "saghen/blink.cmp",
  },
  config = function()
    local capabilities = require("blink.cmp").get_lsp_capabilities()

    vim.lsp.config("*", {
      capabilities = capabilities,
    })

    vim.lsp.config("gopls", {
      settings = {
        gopls = {
          gofumpt = true,
          staticcheck = true,
          analyses = {
            unusedparams = true,
            nilness = true,
            unusedwrite = true,
            useany = true,
          },
          hints = {
            assignVariableTypes = true,
            compositeLiteralFields = true,
            constantValues = true,
            functionTypeParameters = true,
            parameterNames = true,
            rangeVariableTypes = true,
          },
        },
      },
    })

    vim.lsp.config("ruff", {
      on_attach = function(client) client.server_capabilities.hoverProvider = false end,
    })

    if vim.fn.executable("nixd") == 1 then
      vim.lsp.enable("nixd")
    end
  end,
}
