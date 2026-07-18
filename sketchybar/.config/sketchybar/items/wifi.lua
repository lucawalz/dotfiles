local colors = require("colors")
local settings = require("settings")
local icons = require("icons")

local wifi = sbar.add("item", "wifi", {
  position = "right",
  icon = { string = icons.wifi.connected, font = settings.font .. ":Bold:15.0", color = colors.fg_dim },
  label = { drawing = false },
  update_freq = 30,
  popup = { align = "center" },
})

local pop_ssid = sbar.add("item", "wifi.ssid", {
  position = "popup." .. wifi.name,
  width = 210,
  icon = { string = icons.wifi.connected, color = colors.accent },
  label = { string = "Wi-Fi", align = "right" },
})

local pop_ip = sbar.add("item", "wifi.ip", {
  position = "popup." .. wifi.name,
  width = 210,
  icon = { string = icons.ethernet, color = colors.fg },
  label = { string = "-", align = "right" },
})

local pop_settings = sbar.add("item", "wifi.settings", {
  position = "popup." .. wifi.name,
  width = 210,
  icon = { string = icons.gear, color = colors.fg },
  label = { string = "Network Settings", align = "right" },
  click_script = "open 'x-apple.systempreferences:com.apple.Network-Settings.extension'; sketchybar --set wifi popup.drawing=off",
})

local function update()
  sbar.exec("ifconfig en0 2>/dev/null | awk '/status:/{print $2}'", function(status)
    local connected = (status or ""):find("active") ~= nil
    wifi:set({ icon = {
      string = connected and icons.wifi.connected or icons.wifi.disconnected,
      color = connected and colors.accent or colors.inactive,
    } })
  end)
  sbar.exec("ipconfig getifaddr en0 2>/dev/null", function(ip)
    ip = (ip or ""):gsub("%s", "")
    pop_ip:set({ label = (ip ~= "" and ip) or "-" })
  end)
end

wifi:subscribe({ "wifi_change", "system_woke", "routine", "forced" }, update)
wifi:subscribe("mouse.clicked", function() wifi:set({ popup = { drawing = "toggle" } }) end)
update()

require("helpers.hover")(wifi)
