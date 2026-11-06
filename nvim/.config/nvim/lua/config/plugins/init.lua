local specs = {
  "https://github.com/EdenEast/nightfox.nvim",
  { src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" },
  { src = "https://github.com/nvim-treesitter/nvim-treesitter-textobjects", version = "main" },
  "https://github.com/windwp/nvim-ts-autotag",
  { src = "https://github.com/mrjones2014/smart-splits.nvim", version = "v2.1.1-final" },
  "https://github.com/folke/snacks.nvim",
  "https://github.com/nvim-lualine/lualine.nvim",
  "https://github.com/b0o/incline.nvim",
  "https://github.com/folke/which-key.nvim",
  "https://github.com/nvim-mini/mini.nvim",
  "https://github.com/folke/todo-comments.nvim",
  "https://github.com/MeanderingProgrammer/render-markdown.nvim",
  "https://github.com/folke/trouble.nvim",
  { src = "https://github.com/saghen/blink.cmp", version = vim.version.range("1.*") },
  "https://github.com/rafamadriz/friendly-snippets",
  "https://github.com/stevearc/conform.nvim",
  "https://github.com/mfussenegger/nvim-lint",
  "https://github.com/MagicDuck/grug-far.nvim",
  "https://github.com/nvim-lua/plenary.nvim",
  { src = "https://github.com/ThePrimeagen/harpoon", version = "harpoon2" },
  "https://github.com/stevearc/oil.nvim",
  "https://github.com/nvim-tree/nvim-tree.lua",
  "https://github.com/rmagatti/auto-session",
  "https://github.com/neovim/nvim-lspconfig",
  "https://github.com/mason-org/mason.nvim",
  "https://github.com/mason-org/mason-lspconfig.nvim",
  "https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim",
  "https://github.com/folke/lazydev.nvim",
  "https://github.com/lewis6991/gitsigns.nvim",
  "https://github.com/esmuellert/codediff.nvim",
  "https://github.com/sphamba/smear-cursor.nvim",
  "https://github.com/folke/noice.nvim",
  "https://github.com/MunifTanjim/nui.nvim",
  "https://github.com/rcarriga/nvim-notify",
  "https://github.com/rachartier/tiny-inline-diagnostic.nvim",
  { src = "https://github.com/akinsho/bufferline.nvim", version = vim.version.range("*") },
}

vim.api.nvim_create_autocmd("PackChanged", {
  callback = function(ev)
    local data = ev.data
    if data.spec.name == "nvim-treesitter" and (data.kind == "install" or data.kind == "update") then
      if not data.active then
        vim.cmd.packadd("nvim-treesitter")
      end
      vim.cmd("TSUpdate")
    end
  end,
})

vim.pack.add(specs, { confirm = false })

require("config.plugins.ui")
require("config.plugins.treesitter")
require("config.plugins.editor")
require("config.plugins.lsp")
require("config.plugins.git")
require("config.plugins.nav")
