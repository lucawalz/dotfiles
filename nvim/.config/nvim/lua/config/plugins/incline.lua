return {
  "b0o/incline.nvim",
  event = "VeryLazy",
  config = function()
    require("incline").setup({
      window = {
        margin = { vertical = 0, horizontal = 1 },
        padding = 1,
      },
      render = function(props)
        local bufname = vim.api.nvim_buf_get_name(props.buf)
        local filename = vim.fn.fnamemodify(bufname, ":t")
        if filename == "" then
          filename = "[No Name]"
        end

        local icon, color = "", nil
        local ok, devicons = pcall(require, "nvim-web-devicons")
        if ok then
          icon, color = devicons.get_icon_color(filename)
        end

        local modified = vim.bo[props.buf].modified
        return {
          icon and icon ~= "" and { icon .. " ", guifg = color } or "",
          { filename, gui = modified and "bold,italic" or "bold" },
        }
      end,
    })
  end,
}
