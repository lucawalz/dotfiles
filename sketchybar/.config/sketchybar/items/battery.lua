local colors = require("colors")
local settings = require("settings")
local icons = require("icons")

local BATTERY_LOW, BATTERY_MID = 20, 50

local battery = sbar.add("item", "battery", {
  position = "right",
  icon = { font = settings.icon_font .. ":Bold:15.0", color = colors.white },
  label = { color = colors.white },
  update_freq = 120,
  popup = { align = "center" },
})

local detail = sbar.add("item", "battery.detail", {
  position = "popup." .. battery.name,
  width = 210,
  icon = { drawing = false },
  label = { string = "-", align = "center" },
})

local function update()
  sbar.exec("pmset -g batt", function(result)
    result = result or ""
    local pct = tonumber(result:match("(%d+)%%"))
    if not pct then return end
    local charging = result:find("AC Power") ~= nil
    local icon
    if charging then
      icon = icons.battery.charging
    elseif pct >= 90 then
      icon = icons.battery.full
    elseif pct >= 60 then
      icon = icons.battery.high
    elseif pct >= 30 then
      icon = icons.battery.mid
    elseif pct >= 10 then
      icon = icons.battery.low
    else
      icon = icons.battery.empty
    end
    local icolor
    if charging then
      icolor = colors.white
    elseif pct < BATTERY_LOW then
      icolor = colors.critical
    elseif pct <= BATTERY_MID then
      icolor = colors.warning
    else
      icolor = colors.nominal
    end
    battery:set({ icon = { string = icon, color = icolor }, label = pct .. "%" })

    local remaining = result:match("(%d+:%d+) remaining")
    local status = charging and "Charging" or "On battery"
    detail:set({ label = remaining and (status .. " - " .. remaining .. " left") or status })
  end)
end

battery:subscribe({ "routine", "power_source_change", "system_woke", "forced" }, update)
battery:subscribe("mouse.clicked", function() battery:set({ popup = { drawing = "toggle" } }) end)
update()

require("helpers.hover")(battery)
