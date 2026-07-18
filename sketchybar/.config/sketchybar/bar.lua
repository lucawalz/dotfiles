local colors = require("colors")

sbar.bar({
  position = "top",
  height = 37,
  margin = 10,
  y_offset = 6,
  corner_radius = 12,
  blur_radius = 0,
  color = colors.bar.color,
  border_width = 1,
  border_color = colors.bar.border,
  shadow = true,
  sticky = false,
  padding_left = 8,
  padding_right = 8,
})
