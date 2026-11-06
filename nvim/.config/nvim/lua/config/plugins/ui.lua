local WHICH_KEY_TIMEOUT_MS = 500
local DASHBOARD_HEADER_PADDING = 2
local SMEAR_STIFFNESS = 0.6
local SMEAR_TRAILING_STIFFNESS = 0.5
local SMEAR_STOP_DISTANCE = 0.3

local BRAILLE_HEADER = table.concat({
  "   ⣴⣶⣤⡤⠦⣤⣀⣤⠆     ⣈⣭⣿⣶⣿⣦⣼⣆          ",
  "    ⠉⠻⢿⣿⠿⣿⣿⣶⣦⠤⠄⡠⢾⣿⣿⡿⠋⠉⠉⠻⣿⣿⡛⣦       ",
  "          ⠈⢿⣿⣟⠦ ⣾⣿⣿⣷    ⠻⠿⢿⣿⣧⣄     ",
  "           ⣸⣿⣿⢧ ⢻⠻⣿⣿⣷⣄⣀⠄⠢⣀⡀⠈⠙⠿⠄    ",
  "          ⢠⣿⣿⣿⠈    ⣻⣿⣿⣿⣿⣿⣿⣿⣛⣳⣤⣀⣀   ",
  "   ⢠⣧⣶⣥⡤⢄ ⣸⣿⣿⠘  ⢀⣴⣿⣿⡿⠛⣿⣿⣧⠈⢿⠿⠟⠛⠻⠿⠄  ",
  "  ⣰⣿⣿⠛⠻⣿⣿⡦⢹⣿⣷   ⢊⣿⣿⡏  ⢸⣿⣿⡇ ⢀⣠⣄⣾⠄   ",
  " ⣠⣿⠿⠛ ⢀⣿⣿⣷⠘⢿⣿⣦⡀ ⢸⢿⣿⣿⣄ ⣸⣿⣿⡇⣪⣿⡿⠿⣿⣷⡄  ",
  " ⠙⠃   ⣼⣿⡟  ⠈⠻⣿⣿⣦⣌⡇⠻⣿⣿⣷⣿⣿⣿ ⣿⣿⡇ ⠛⠻⢷⣄ ",
  "      ⢻⣿⣿⣄   ⠈⠻⣿⣿⣿⣷⣿⣿⣿⣿⣿⡟ ⠫⢿⣿⡆     ",
  "       ⠻⣿⣿⣿⣿⣶⣶⣾⣿⣿⣿⣿⣿⣿⣿⣿⡟⢀⣀⣤⣾⡿⠃     ",
}, "\n")

local function dashboard_button(shortcut, key, icon, desc, action)
  return {
    key = key,
    label = { shortcut, hl = "Comment" },
    icon = { icon, hl = "Normal", width = 2 },
    desc = { desc, hl = "Normal" },
    action = action,
  }
end

local TRANSPARENT_GROUPS = {
  "Normal",
  "NormalNC",
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
  "CursorLine",
  "SignColumn",
  "Todo",
}
local TRANSPARENT_PREFIXES = { "lualine", "BufferLine", "Notify", "Noice", "Snacks", "NvimTree" }
local KEEP_COLOURED_PREFIX = "lualine_a"

local function clear_bg(group)
  local hl = vim.api.nvim_get_hl(0, { name = group, link = false })
  hl.bg = nil
  hl.ctermbg = nil
  -- a default-flagged definition would not override the existing one
  hl.default = nil
  vim.api.nvim_set_hl(0, group, hl)
end

local function apply_transparency()
  for _, group in ipairs(TRANSPARENT_GROUPS) do
    clear_bg(group)
  end
  for group in pairs(vim.api.nvim_get_hl(0, {})) do
    for _, prefix in ipairs(TRANSPARENT_PREFIXES) do
      if vim.startswith(group, prefix) and not vim.startswith(group, KEEP_COLOURED_PREFIX) then
        clear_bg(group)
      end
    end
  end
end

require("nightfox").setup({
  options = { terminal_colors = true, transparent = true },
})

vim.cmd.colorscheme("carbonfox")

vim.keymap.set("n", "<leader>ut", function()
  vim.o.background = vim.o.background == "dark" and "light" or "dark"
  vim.cmd.colorscheme(vim.o.background == "dark" and "carbonfox" or "dayfox")
end, { desc = "Toggle light/dark theme" })

require("mini.icons").setup()
MiniIcons.mock_nvim_web_devicons()

require("snacks").setup({
  bigfile = { enabled = true },
  dashboard = {
    enabled = true,
    preset = {
      header = BRAILLE_HEADER,
      keys = {
        dashboard_button("SPC f f", " ff", "\u{f002}", "Find File", function() Snacks.picker.files() end),
        dashboard_button("SPC f o", " fo", "\u{f017}", "Recent Files", function() Snacks.picker.recent() end),
        dashboard_button("SPC f g", " fg", "\u{f422}", "Live Grep", function() Snacks.picker.grep() end),
        dashboard_button(
          "SPC e",
          " e",
          "\u{f07b}",
          "File Explorer",
          function() require("oil").open_float(vim.uv.cwd()) end
        ),
        dashboard_button("SPC f k", " fk", "\u{f11c}", "Keymaps", function() Snacks.picker.keymaps() end),
        dashboard_button("q", "q", "\u{f011}", "Quit", ":qa"),
      },
    },
    formats = { header = { "%s", align = "center", hl = "Comment" } },
    sections = {
      { section = "header", padding = DASHBOARD_HEADER_PADDING },
      { section = "keys", gap = 1 },
    },
  },
  indent = { enabled = true, indent = { char = "┊" } },
  input = { enabled = true },
  lazygit = { enabled = true },
  picker = { enabled = true },
  quickfile = { enabled = true },
  rename = { enabled = true },
  scroll = { enabled = true },
  words = { enabled = true },
  zen = { enabled = true },
})

require("lualine").setup({
  options = {
    theme = "auto",
    globalstatus = true,
    section_separators = "",
    component_separators = "",
  },
  sections = {
    lualine_a = { "mode" },
    lualine_b = { "branch" },
    lualine_c = { { "filename", path = 1 } },
    lualine_x = { "diagnostics", "filetype" },
    lualine_y = { "progress" },
    lualine_z = { "location" },
  },
})

require("incline").setup({
  window = {
    margin = { vertical = 0, horizontal = 1 },
    padding = 1,
  },
  render = function(props)
    local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":t")
    if filename == "" then
      filename = "[No Name]"
    end
    local icon, color = require("nvim-web-devicons").get_icon_color(filename)
    return {
      icon and { icon .. " ", guifg = color } or "",
      { filename, gui = vim.bo[props.buf].modified and "bold,italic" or "bold" },
    }
  end,
})

vim.o.timeoutlen = WHICH_KEY_TIMEOUT_MS

require("which-key").setup({
  spec = {
    { "<leader>b", group = "buffer" },
    { "<leader>c", group = "code" },
    { "<leader>f", group = "find" },
    { "<leader>g", group = "git" },
    { "<leader>h", group = "git hunks" },
    { "<leader>r", group = "rename/replace" },
    { "<leader>s", group = "split" },
    { "<leader>u", group = "ui/toggle" },
    { "<leader>w", group = "session" },
    { "<leader>x", group = "diagnostics" },
    { "<leader>y", group = "yank" },
  },
})

require("todo-comments").setup()
require("trouble").setup({ focus = true })
require("render-markdown").setup({})

local function map(lhs, rhs, desc) vim.keymap.set("n", lhs, rhs, { desc = desc, silent = true }) end

map("<C-p>", function() Snacks.picker.files() end, "Find files")
map("<leader>ff", function() Snacks.picker.files() end, "Fuzzy find files in cwd")
map("<leader>fr", function() Snacks.picker.recent() end, "Fuzzy find recent files")
map("<leader>fs", function() Snacks.picker.grep() end, "Find string in cwd")
map("<leader>fc", function() Snacks.picker.grep_word() end, "Find string under cursor in cwd")
map("<leader>ft", function() Snacks.picker.todo_comments() end, "Find todos")
map("<leader>fk", function() Snacks.picker.keymaps() end, "Show keymaps")

map("<leader>z", function() Snacks.zen() end, "Zen mode")
map("<leader>sm", function() Snacks.zen.zoom() end, "Maximize/minimize a split")

map("]t", function() require("todo-comments").jump_next() end, "Next todo comment")
map("[t", function() require("todo-comments").jump_prev() end, "Previous todo comment")

map("<leader>xw", "<cmd>Trouble diagnostics toggle<CR>", "Open trouble workspace diagnostics")
map("<leader>xd", "<cmd>Trouble diagnostics toggle filter.buf=0<CR>", "Open trouble document diagnostics")
map("<leader>xq", "<cmd>Trouble quickfix toggle<CR>", "Open trouble quickfix list")
map("<leader>xl", "<cmd>Trouble loclist toggle<CR>", "Open trouble location list")
map("<leader>xt", "<cmd>Trouble todo toggle<CR>", "Open todos in trouble")

require("bufferline").setup({
  options = {
    mode = "tabs",
    separator_style = "thin",
    indicator = { style = "underline" },
    always_show_bufferline = false,
  },
})

require("smear_cursor").setup({
  enabled = true,
  smear_between_buffers = false,
  stiffness = SMEAR_STIFFNESS,
  trailing_stiffness = SMEAR_TRAILING_STIFFNESS,
  distance_stop_animating = SMEAR_STOP_DISTANCE,
})

require("notify").setup({ background_colour = require("nightfox.palette").load("carbonfox").bg1 })

require("noice").setup({
  lsp = {
    override = {
      ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
      ["vim.lsp.util.stylize_markdown"] = true,
    },
  },
  presets = {
    bottom_search = true,
    command_palette = true,
    long_message_to_split = true,
    lsp_doc_border = true,
  },
})

require("tiny-inline-diagnostic").setup({
  preset = "modern",
  options = {
    show_source = true,
    multilines = { enabled = true, always_show = false },
  },
})

local function apply_transparency_now_and_later()
  apply_transparency()
  vim.schedule(apply_transparency)
end

vim.api.nvim_create_autocmd({ "VimEnter", "ColorScheme" }, { callback = apply_transparency_now_and_later })
apply_transparency_now_and_later()
