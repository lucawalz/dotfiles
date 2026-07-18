local settings = require("settings")
local colors = require("colors")

sbar.default({
  updates = "when_shown",
  icon = {
    font = { family = settings.font, style = "Bold", size = 15.0 },
    color = colors.white,
    padding_left = 7,
    padding_right = 4,
  },
  label = {
    font = { family = settings.font, style = "Bold", size = 14.0 },
    color = colors.white,
    padding_left = 4,
    padding_right = 7,
  },
  background = {
    drawing = false,
    corner_radius = 6,
    height = 26,
  },
  popup = {
    background = {
      border_width = 1,
      corner_radius = 9,
      border_color = colors.popup.border,
      color = colors.popup.bg,
      shadow = { drawing = true },
    },
    blur_radius = 0,
    y_offset = 6,
  },
  padding_left = 3,
  padding_right = 3,
})
