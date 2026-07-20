local colors = require("colors")
local settings = require("settings")
local icons = require("icons")

local LEVELS = {
  { min = 90, icon = icons.battery.full, color = colors.nominal },
  { min = 60, icon = icons.battery.high, color = colors.nominal },
  { min = 30, icon = icons.battery.mid, color = colors.warning },
  { min = 10, icon = icons.battery.low, color = colors.critical },
  { min = 0, icon = icons.battery.empty, color = colors.critical },
}

local function level_for(pct)
  for _, level in ipairs(LEVELS) do
    if pct >= level.min then return level end
  end
  return LEVELS[#LEVELS]
end

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
    local level = level_for(pct)
    local icon = charging and icons.battery.charging or level.icon
    battery:set({ icon = { string = icon, color = level.color }, label = pct .. "%" })

    local remaining = result:match("(%d+:%d+) remaining")
    local status = charging and "Charging" or "On battery"
    detail:set({ label = remaining and (status .. " - " .. remaining .. " left") or status })
  end)
end

require("helpers.poll")(battery, update, { "power_source_change" })
require("helpers.popup")(battery)

require("helpers.hover")(battery)
