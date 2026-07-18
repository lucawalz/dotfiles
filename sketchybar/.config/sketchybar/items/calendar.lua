local colors = require("colors")
local settings = require("settings")
local icons = require("icons")

local cal = sbar.add("item", "calendar", {
  position = "right",
  icon = { string = icons.calendar, font = settings.font .. ":Bold:15.0", color = colors.fg_dim },
  label = { color = colors.white },
  update_freq = 30,
  click_script = "open -a Calendar",
})

local function update()
  cal:set({ label = os.date("%a %d %b  %H:%M") })
end

cal:subscribe({ "routine", "forced" }, update)
require("helpers.hover")(cal)
