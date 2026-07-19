return {
  {
    "williamboman/mason-lspconfig.nvim",
    opts = {
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
    },
    dependencies = {
      {
        "williamboman/mason.nvim",
        opts = {
          ui = {
            icons = {
              package_installed = "✓",
              package_pending = "➜",
              package_uninstalled = "✗",
            },
          },
        },
      },
      "neovim/nvim-lspconfig",
    },
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    opts = {
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
    },
    dependencies = {
      "williamboman/mason.nvim",
    },
  },
}
