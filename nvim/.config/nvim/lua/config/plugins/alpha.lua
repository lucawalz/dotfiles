return {
  "goolord/alpha-nvim",
  event = "VimEnter",
  config = function()
    local alpha = require("alpha")
    local dashboard = require("alpha.themes.dashboard")

    dashboard.section.header.val = {
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
    }
    dashboard.section.header.opts.hl = "Comment"

    dashboard.section.buttons.val = {
      dashboard.button("SPC f f", "\u{f002}  Find File", "<cmd>Telescope find_files<CR>"),
      dashboard.button("SPC f o", "\u{f017}  Recent Files", "<cmd>Telescope oldfiles<CR>"),
      dashboard.button("SPC f g", "\u{f422}  Live Grep", "<cmd>Telescope live_grep<CR>"),
      dashboard.button("SPC e", "\u{f07b}  File Explorer", "<cmd>NvimTreeToggle<CR>"),
      dashboard.button("SPC f k", "\u{f11c}  Keymaps", "<cmd>Telescope keymaps<CR>"),
      dashboard.button("q", "\u{f011}  Quit", "<cmd>qa<CR>"),
    }
    for _, b in ipairs(dashboard.section.buttons.val) do
      b.opts.hl = "Normal"
      b.opts.hl_shortcut = "Comment"
    end

    dashboard.section.footer.val = ""

    local content_h = #dashboard.section.header.val + (#dashboard.section.buttons.val * 2) + 4
    dashboard.opts.layout[1].val = math.max(2, math.floor((vim.o.lines - content_h) / 2))

    alpha.setup(dashboard.opts)

    vim.api.nvim_create_autocmd("VimResized", {
      callback = function()
        if vim.bo.filetype == "alpha" then
          dashboard.opts.layout[1].val = math.max(2, math.floor((vim.o.lines - content_h) / 2))
          pcall(function() require("alpha").redraw() end)
        end
      end,
    })

    vim.cmd([[autocmd FileType alpha setlocal nofoldenable]])
  end,
}
