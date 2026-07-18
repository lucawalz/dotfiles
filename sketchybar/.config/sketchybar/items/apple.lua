local colors = require("colors")
local settings = require("settings")
local icons = require("icons")

sbar.add("item", "apple", {
  position = "left",
  icon = {
    string = icons.apple,
    font = settings.font .. ":Bold:16.0",
    color = colors.fg,
    padding_left = 8,
    padding_right = 8,
  },
  label = { drawing = false },
})
