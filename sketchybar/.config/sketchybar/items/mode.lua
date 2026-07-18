local colors = require("colors")
local settings = require("settings")

local MODE_COLORS = { resize = colors.accent, service = colors.elevated }

-- Kept always-drawing (SbarLua only delivers events to drawing items); it is
-- visually empty until a non-main AeroSpace mode is entered.
local mode = sbar.add("item", "mode", {
  position = "left",
  icon = { drawing = false },
  label = {
    string = "",
    color = colors.bar_color,
    font = settings.font .. ":Bold:12.0",
    padding_left = 0,
    padding_right = 0,
  },
  background = { color = colors.transparent, corner_radius = 6, height = 22 },
})

sbar.add("event", "aerospace_mode")

mode:subscribe("aerospace_mode", function(env)
  local m = env.MODE
  if m and m ~= "main" and m ~= "" then
    mode:set({
      label = { string = m:upper(), padding_left = 6, padding_right = 6 },
      background = { color = MODE_COLORS[m] or colors.accent },
    })
  else
    mode:set({
      label = { string = "", padding_left = 0, padding_right = 0 },
      background = { color = colors.transparent },
    })
  end
end)
