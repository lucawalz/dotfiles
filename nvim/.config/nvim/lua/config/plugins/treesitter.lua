local ensure_installed = {
  "lua",
  "luadoc",
  "vim",
  "vimdoc",
  "python",
  "java",
  "go",
  "gomod",
  "gosum",
  "gowork",
  "javascript",
  "typescript",
  "tsx",
  "jsdoc",
  "nix",
  "bash",
  "dockerfile",
  "yaml",
  "json",
  "toml",
  "markdown",
  "markdown_inline",
  "gitignore",
  "git_config",
  "git_rebase",
  "gitcommit",
  "query",
  "regex",
  "c",
  "hcl",
  "terraform",
}

return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter").setup()

      vim.treesitter.language.register("bash", "zsh")

      require("nvim-treesitter").install(ensure_installed)

      vim.api.nvim_create_autocmd("FileType", {
        callback = function(args)
          local buf = args.buf
          local ok = pcall(vim.treesitter.start, buf)
          if ok then
            vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          end
        end,
      })
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    branch = "main",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function()
      require("nvim-treesitter-textobjects").setup({
        select = { lookahead = true },
        move = { set_jumps = true },
      })

      local select = require("nvim-treesitter-textobjects.select")
      local move = require("nvim-treesitter-textobjects.move")

      local function sel(key, obj)
        vim.keymap.set(
          { "x", "o" },
          key,
          function() select.select_textobject(obj, "textobjects") end,
          { silent = true, desc = "Select " .. obj }
        )
      end

      sel("af", "@function.outer")
      sel("if", "@function.inner")
      sel("ac", "@class.outer")
      sel("ic", "@class.inner")
      sel("aa", "@parameter.outer")
      sel("ia", "@parameter.inner")

      local function mv(key, fn, obj)
        vim.keymap.set({ "n", "x", "o" }, key, function() fn(obj, "textobjects") end, { silent = true, desc = obj })
      end

      mv("]f", move.goto_next_start, "@function.outer")
      mv("]c", move.goto_next_start, "@class.outer")
      mv("[f", move.goto_previous_start, "@function.outer")
      mv("[c", move.goto_previous_start, "@class.outer")
    end,
  },
}
