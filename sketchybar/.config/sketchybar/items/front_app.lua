local colors = require("colors")
local settings = require("settings")
local app_icons = require("icon_map")

local front_app = sbar.add("item", "front_app", {
  position = "left",
  icon = { font = settings.app_font .. ":Regular:16.0", color = colors.white },
  label = { color = colors.white, font = settings.font .. ":Bold:13.0" },
})

front_app:subscribe("front_app_switched", function(env)
  local name = env.INFO or ""
  front_app:set({ label = name, icon = { string = app_icons[name] or app_icons["Default"] } })
end)
