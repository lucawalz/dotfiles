require("lazydev").setup()

require("mason").setup({
  ui = {
    icons = {
      package_installed = "✓",
      package_pending = "➜",
      package_uninstalled = "✗",
    },
  },
})

require("mason-lspconfig").setup({
  ensure_installed = {
    "lua_ls",
    "gopls",
    "pyright",
    "ruff",
    "ts_ls",
    "jdtls",
    "bashls",
    "dockerls",
    "docker_compose_language_service",
    "yamlls",
    "jsonls",
    "marksman",
    "terraformls",
  },
})

require("mason-tool-installer").setup({
  ensure_installed = {
    "stylua",
    "ruff",
    "gofumpt",
    "goimports",
    "google-java-format",
    "prettier",
    "shfmt",
    "shellcheck",
    "yamlfmt",
    "yamllint",
  },
})

vim.lsp.config("*", { capabilities = require("blink.cmp").get_lsp_capabilities() })

if vim.fn.executable("nixd") == 1 then
  vim.lsp.enable("nixd")
end
