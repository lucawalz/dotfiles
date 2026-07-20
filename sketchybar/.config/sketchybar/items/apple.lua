local colors = require("colors")
local settings = require("settings")
local icons = require("icons")
local bin = require("bin")

local MENU_WIDTH = 180

local apple = sbar.add("item", "apple", {
  position = "left",
  icon = {
    string = icons.apple,
    font = settings.font .. ":Bold:16.0",
    color = colors.fg,
    padding_left = 8,
    padding_right = 8,
  },
  label = { drawing = false },
  popup = { align = "left" },
})

local MENU = {
  { key = "settings", icon = icons.gear, label = "System Settings", color = colors.fg,
    run = "open -a 'System Settings'" },
  { key = "lock", icon = icons.lock, label = "Lock Screen", color = colors.fg,
    run = "pmset displaysleepnow" },
  { key = "sleep", icon = icons.sleep, label = "Sleep", color = colors.inactive,
    run = "pmset sleepnow" },
  { key = "restart", icon = icons.restart, label = "Restart", color = colors.warning,
    run = "osascript -e 'tell app \"System Events\" to restart'" },
  { key = "shutdown", icon = icons.power, label = "Shut Down", color = colors.critical,
    run = "osascript -e 'tell app \"System Events\" to shut down'" },
}

for _, entry in ipairs(MENU) do
  sbar.add("item", "apple." .. entry.key, {
    position = "popup." .. apple.name,
    width = MENU_WIDTH,
    icon = {
      string = entry.icon,
      color = entry.color,
      font = settings.font .. ":Regular:13.0",
      padding_left = 12,
    },
    label = { string = entry.label, align = "left", padding_right = 16 },
    click_script = entry.run .. "; " .. bin.sketchybar .. " --set apple popup.drawing=off",
  })
end

require("helpers.popup")(apple)
require("helpers.hover")(apple)
