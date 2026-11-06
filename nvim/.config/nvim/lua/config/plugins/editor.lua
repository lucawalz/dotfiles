local FORMAT_TIMEOUT_MS = 1000
local FORMAT_ON_SAVE_TIMEOUT_MS = 3000
local HARPOON_SLOTS = 4
local DOCS_AUTO_SHOW_DELAY_MS = 200
local LAZYDEV_SCORE_OFFSET = 100
local EXPLORER_WIDTH = 50

require("blink.cmp").setup({
  keymap = {
    preset = "default",
    ["<C-k>"] = { "select_prev", "fallback" },
    ["<C-j>"] = { "select_next", "fallback" },
    ["<C-b>"] = { "scroll_documentation_up", "fallback" },
    ["<C-f>"] = { "scroll_documentation_down", "fallback" },
    ["<C-Space>"] = { "show", "show_documentation", "hide_documentation" },
    ["<C-e>"] = { "hide", "fallback" },
    ["<CR>"] = { "accept", "fallback" },
    ["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
    ["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
  },
  appearance = { nerd_font_variant = "mono" },
  completion = {
    documentation = { auto_show = true, auto_show_delay_ms = DOCS_AUTO_SHOW_DELAY_MS },
    menu = { border = "rounded" },
    ghost_text = { enabled = true },
  },
  sources = {
    default = { "lsp", "path", "snippets", "buffer", "lazydev" },
    providers = {
      lazydev = {
        name = "LazyDev",
        module = "lazydev.integrations.blink",
        score_offset = LAZYDEV_SCORE_OFFSET,
      },
    },
  },
  signature = { enabled = true },
  fuzzy = { implementation = "prefer_rust_with_warning" },
})

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
    timeout_ms = FORMAT_ON_SAVE_TIMEOUT_MS,
  },
})

vim.keymap.set(
  { "n", "v" },
  "<leader>cf",
  function() conform.format({ lsp_format = "fallback", async = false, timeout_ms = FORMAT_TIMEOUT_MS }) end,
  { desc = "Format file or range" }
)

local lint = require("lint")
lint.linters_by_ft = {
  yaml = { "yamllint" },
  sh = { "shellcheck" },
  bash = { "shellcheck" },
}

vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
  group = vim.api.nvim_create_augroup("lint", { clear = true }),
  callback = function() lint.try_lint() end,
})

vim.keymap.set("n", "<leader>cl", function() lint.try_lint() end, { desc = "Lint current file" })

local gen_spec = require("mini.ai").gen_spec
require("mini.ai").setup({
  custom_textobjects = {
    f = false,
    F = gen_spec.function_call(),
  },
})

require("mini.surround").setup({
  mappings = {
    add = "ys",
    delete = "ds",
    find = "",
    find_left = "",
    highlight = "",
    replace = "cs",
    suffix_last = "",
    suffix_next = "",
  },
  search_method = "cover_or_next",
})
vim.keymap.del("x", "ys")
vim.keymap.set("x", "S", [[:<C-u>lua MiniSurround.add('visual')<CR>]], { silent = true, desc = "Surround selection" })
vim.keymap.set("n", "yss", "ys_", { remap = true, desc = "Surround line" })

require("mini.pairs").setup()

require("mini.operators").setup({
  evaluate = { prefix = "" },
  exchange = { prefix = "" },
  multiply = { prefix = "" },
  replace = { prefix = "<leader>r" },
  sort = { prefix = "" },
})
vim.keymap.set("n", "<leader>R", "<leader>r$", { remap = true, desc = "Replace to end of line" })

require("grug-far").setup({})
vim.keymap.set("n", "<leader>rf", function() require("grug-far").open() end, { desc = "Find & replace in files" })

local harpoon = require("harpoon")
harpoon:setup()
vim.keymap.set("n", "<leader>H", function() harpoon:list():add() end, { desc = "Harpoon add file" })
vim.keymap.set("n", "<C-e>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, { desc = "Harpoon menu" })
for slot = 1, HARPOON_SLOTS do
  vim.keymap.set(
    "n",
    "<leader>" .. slot,
    function() harpoon:list():select(slot) end,
    { desc = "Harpoon file " .. slot }
  )
end

local oil = require("oil")
oil.setup({
  default_file_explorer = false,
  view_options = { show_hidden = true },
  keymaps = {
    ["<Esc>"] = "actions.close",
    ["q"] = "actions.close",
  },
})
vim.keymap.set("n", "-", "<cmd>Oil<cr>", { desc = "Open parent directory (oil)" })
require("nvim-tree").setup({
  disable_netrw = true,
  hijack_netrw = false,
  view = {
    width = EXPLORER_WIDTH,
    relativenumber = true,
  },
  renderer = {
    indent_markers = {
      enable = true,
    },
    icons = {
      glyphs = {
        folder = {
          arrow_closed = "\u{f061}",
          arrow_open = "\u{f063}",
        },
      },
    },
  },
  actions = {
    open_file = {
      window_picker = {
        enable = false,
      },
    },
  },
  filters = {
    custom = { ".DS_Store" },
  },
  git = {
    ignore = false,
  },
})
vim.keymap.set("n", "<leader>e", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle file explorer" })
vim.keymap.set("n", "<leader>E", "<cmd>NvimTreeFindFileToggle<CR>", { desc = "Explorer on current file" })

vim.api.nvim_create_autocmd("User", {
  pattern = "OilActionsPost",
  callback = function(event)
    for _, action in ipairs(event.data.actions) do
      if action.type == "move" then
        Snacks.rename.on_rename_file(action.src_url, action.dest_url)
      end
    end
  end,
})

require("auto-session").setup({
  auto_restore_enabled = false,
  auto_session_suppress_dirs = { "~/", "~/Dev/", "~/Downloads", "~/Documents", "~/Desktop/" },
})
vim.keymap.set("n", "<leader>wr", "<cmd>AutoSession restore<CR>", { desc = "Restore session for cwd" })
vim.keymap.set("n", "<leader>ws", "<cmd>AutoSession save<CR>", { desc = "Save session for auto session root dir" })
