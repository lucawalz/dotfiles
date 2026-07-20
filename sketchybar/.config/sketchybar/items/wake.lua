local colors = require("colors")
local settings = require("settings")
local icons = require("icons")

sbar.add("item", "wake.orb", {
  position = "center",
  drawing = false,
  icon = {
    string = icons.apple,
    font = settings.font .. ":Bold:16.0",
    color = colors.fg,
    align = "center",
    padding_left = 15,
    padding_right = 13,
  },
  label = { drawing = false },
  background = {
    drawing = true,
    color = colors.bar_color,
    corner_radius = 18,
    height = 37,
    border_color = colors.accent,
    border_width = 2,
  },
})

local wake = sbar.add("item", "wake", {
  width = 0,
  icon = { drawing = false },
  label = { drawing = false },
})

wake:subscribe("system_woke", function()
  sbar.exec(os.getenv("CONFIG_DIR") .. "/helpers/wake.sh")
end)
