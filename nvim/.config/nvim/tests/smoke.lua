local MAX_PLUGINS = 35

local MODULES = {
  "nightfox",
  "config.aerospace-focus",
  "nvim-treesitter",
  "nvim-treesitter-textobjects",
  "nvim-ts-autotag",
  "snacks",
  "lualine",
  "incline",
  "which-key",
  "mini.icons",
  "todo-comments",
  "render-markdown",
  "trouble",
  "blink.cmp",
  "conform",
  "lint",
  "mini.ai",
  "mini.surround",
  "mini.pairs",
  "mini.operators",
  "grug-far",
  "harpoon",
  "oil",
  "nvim-tree",
  "auto-session",
  "mason",
  "mason-lspconfig",
  "mason-tool-installer",
  "lspconfig",
  "lazydev",
  "gitsigns",
  "codediff",
  "noice",
  "notify",
  "bufferline",
  "tiny-inline-diagnostic",
  "smear_cursor",
}

local MAPS = {
  { "i", "jj" },
  { "i", "jk" },
  { "n", "<Esc>" },
  { "n", "<C-s>" },
  { "i", "<C-s>" },
  { "x", "<C-s>" },
  { "n", "<leader>q" },
  { "n", "<leader>Q" },
  { "n", "<C-h>" },
  { "n", "<C-j>" },
  { "n", "<C-k>" },
  { "n", "<C-l>" },
  { "n", "<C-Up>" },
  { "n", "<C-Down>" },
  { "n", "<C-Left>" },
  { "n", "<C-Right>" },
  { "n", "<leader>sv" },
  { "n", "<leader>sh" },
  { "n", "<leader>se" },
  { "n", "<leader>sx" },
  { "n", "<S-l>" },
  { "n", "<S-h>" },
  { "n", "<leader>bd" },
  { "n", "<leader>bb" },
  { "n", "<C-p>" },
  { "n", "<C-/>" },
  { "x", "<C-/>" },
  { "n", "<C-_>" },
  { "x", "<C-_>" },
  { "v", "<" },
  { "v", ">" },
  { "v", "J" },
  { "v", "K" },
  { "n", "n" },
  { "n", "N" },
  { "n", "<C-d>" },
  { "n", "<C-u>" },
  { "x", "<D-c>" },
  { "n", "<D-c>" },
  { "x", "<D-x>" },
  { "n", "<D-v>" },
  { "x", "<D-v>" },
  { "i", "<D-v>" },
  { "c", "<D-v>" },
  { "n", "<D-a>" },
  { "x", "<D-a>" },
  { "n", "<D-s>" },
  { "i", "<D-s>" },
  { "x", "<D-s>" },
  { "n", "<D-z>" },
  { "x", "<D-z>" },
  { "i", "<D-z>" },
  { "n", "<D-Z>" },
  { "x", "<D-Z>" },
  { "n", "ZR" },
  { "n", "<leader>ut" },
  { "x", "af" },
  { "o", "if" },
  { "n", "]f" },
  { "n", "]c" },
  { "n", "[c" },
  { "n", "<leader>ff" },
  { "n", "<leader>fr" },
  { "n", "<leader>fs" },
  { "n", "<leader>fc" },
  { "n", "<leader>ft" },
  { "n", "<leader>fk" },
  { "n", "<leader>z" },
  { "n", "<leader>sm" },
  { "n", "<leader>xw" },
  { "n", "<leader>xd" },
  { "n", "<leader>xq" },
  { "n", "<leader>xl" },
  { "n", "<leader>xt" },
  { "n", "ys" },
  { "n", "ds" },
  { "n", "cs" },
  { "n", "<leader>r" },
  { "n", "<leader>rr" },
  { "n", "<leader>R" },
  { "n", "<leader>rf" },
  { "n", "<leader>cf" },
  { "n", "<leader>cl" },
  { "n", "<leader>H" },
  { "n", "<C-e>" },
  { "n", "<leader>1" },
  { "n", "-" },
  { "n", "<leader>e" },
  { "n", "<leader>E" },
  { "n", "<leader>wr" },
  { "n", "<leader>ws" },
  { "x", "<leader>r" },
  { "n", "<C-g>" },
  { "n", "<leader>gg" },
  { "n", "<leader>gv" },
  { "n", "<leader>gh" },
  { "n", "<leader>gH" },
  { "n", "<leader>gp" },
  { "n", "<leader>gd" },
  { "n", "<leader>yf" },
  { "n", "<leader>yp" },
  { "x", "<leader>cc" },
}

local ABSENT = {
  "lazy",
  "telescope",
  "dressing",
  "alpha",
  "hydra",
  "neogit",
  "diffview",
  "sidekick",
  "dap",
  "neotest",
  "obsidian",
}

local failures = {}
local function fail(msg) failures[#failures + 1] = msg end

if vim.v.errmsg ~= "" then
  fail("vim.v.errmsg: " .. vim.v.errmsg)
end

for _, name in ipairs(MODULES) do
  local ok, err = pcall(require, name)
  if not ok then
    fail("module failed to load: " .. name .. ": " .. tostring(err))
  end
end

for _, map in ipairs(MAPS) do
  if vim.fn.maparg(map[2], map[1]) == "" then
    fail("missing mapping: " .. map[1] .. " " .. map[2])
  end
end

for _, name in ipairs(ABSENT) do
  if pcall(require, name) then
    fail("module must not load: " .. name)
  end
end

local gopls = vim.lsp.config.gopls
if not (gopls and gopls.settings and gopls.settings.gopls and gopls.settings.gopls.gofumpt == true) then
  fail("gopls gofumpt setting not merged from after/lsp")
end

vim.cmd("edit README.md")
vim.api.nvim_win_set_cursor(0, { 3, 0 })
local agent = require("config.agent")
if agent.path_ref(false) ~= "README.md#L3" then
  fail("path_ref(false): " .. agent.path_ref(false))
end
local block = agent.selection_block(1, 2)
local first_line = vim.api.nvim_buf_get_lines(0, 0, 1, false)[1]
if
  not vim.startswith(block, "README.md#L1-L2")
  or not block:find("\n```markdown\n", 1, true)
  or not block:find(first_line, 1, true)
then
  fail("selection_block: " .. block)
end

local dashboard_ok, dashboard_err = pcall(Snacks.dashboard.open)
if not dashboard_ok then
  fail("dashboard failed to open: " .. tostring(dashboard_err))
end

local TRANSPARENT_GROUPS = { "NormalFloat", "Pmenu", "lualine_c_normal", "lualine_b_normal" }
local COLOURED_GROUPS = { "lualine_a_normal" }
local SETTLE_MS = 50

local function assert_transparent(stage)
  for _, group in ipairs(TRANSPARENT_GROUPS) do
    local hl = vim.api.nvim_get_hl(0, { name = group, link = false })
    if hl.bg ~= nil then
      fail(("%s has a background %s"):format(group, stage))
    end
  end
  for _, group in ipairs(COLOURED_GROUPS) do
    local hl = vim.api.nvim_get_hl(0, { name = group, link = false })
    if hl.bg == nil then
      fail(("%s lost its background %s"):format(group, stage))
    end
  end
end

vim.wait(SETTLE_MS)
assert_transparent("after startup")
vim.cmd.colorscheme("carbonfox")
assert_transparent("after colorscheme carbonfox")
vim.wait(SETTLE_MS)
assert_transparent("after scheduled tick")

local count = #vim.pack.get()
if count > MAX_PLUGINS then
  fail(("plugin count %d exceeds %d"):format(count, MAX_PLUGINS))
end

if #failures == 0 then
  print("smoke: ok")
  vim.cmd("qa!")
else
  for _, msg in ipairs(failures) do
    io.stderr:write(msg .. "\n")
  end
  vim.cmd("cquit 1")
end
