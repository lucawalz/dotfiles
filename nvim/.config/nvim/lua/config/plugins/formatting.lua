return {
  "stevearc/conform.nvim",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local conform = require("conform")

    conform.setup({
      formatters_by_ft = {
        javascript = { "prettier" },
        typescript = { "prettier" },
        javascriptreact = { "prettier" },
        typescriptreact = { "prettier" },
        css = { "prettier" },
        html = { "prettier" },
        json = { "prettier" },
        jsonc = { "prettier" },
        markdown = { "prettier" },
        graphql = { "prettier" },
        yaml = { "yamlfmt" },
        lua = { "stylua" },
        python = { "ruff_organize_imports", "ruff_format" },
        go = { "goimports", "gofumpt" },
        java = { "google-java-format" },
        nix = { "alejandra" },
        terraform = { "terraform_fmt" },
        hcl = { "terraform_fmt" },
        sh = { "shfmt" },
        bash = { "shfmt" },
      },
      format_on_save = {
        lsp_format = "fallback",
        async = false,
        timeout_ms = 3000,
      },
    })

    vim.keymap.set({ "n", "v" }, "<leader>cf", function()
      conform.format({
        lsp_format = "fallback",
        async = false,
        timeout_ms = 1000,
      })
    end, { desc = "Format file or range" })
  end,
}
