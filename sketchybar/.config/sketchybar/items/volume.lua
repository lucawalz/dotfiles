local colors = require("colors")
local settings = require("settings")
local icons = require("icons")

local volume = sbar.add("item", "volume", {
  position = "right",
  icon = { font = settings.font .. ":Bold:15.0", color = colors.fg_dim },
  label = { color = colors.white },
  click_script = "osascript -e 'set volume output muted (not output muted of (get volume settings))'",
})

local function set_volume(v)
  v = tonumber(v) or 0
  local icon = icons.volume.muted
  if v >= 60 then
    icon = icons.volume.high
  elseif v >= 30 then
    icon = icons.volume.mid
  elseif v >= 1 then
    icon = icons.volume.low
  end
  volume:set({ icon = icon, label = v .. "%" })
end

volume:subscribe("volume_change", function(env) set_volume(env.INFO) end)
require("helpers.hover")(volume)
sbar.exec("osascript -e 'output volume of (get volume settings)'", function(r)
  set_volume((r or ""):gsub("%s", ""))
end)
