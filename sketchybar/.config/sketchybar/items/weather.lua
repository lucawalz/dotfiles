local colors = require("colors")
local settings = require("settings")
local icons = require("icons")

local TEMP_HOT, TEMP_WARM, TEMP_MILD = 28, 20, 10

local function temp_color(n)
  if not n then return colors.accent end
  if n >= TEMP_HOT then return colors.base0a end
  if n >= TEMP_WARM then return colors.base0c end
  if n >= TEMP_MILD then return colors.base0d end
  return colors.base0f
end

local weather = sbar.add("item", "weather", {
  position = "right",
  icon = { string = icons.thermometer, font = settings.font .. ":Bold:15.0", color = colors.accent },
  label = { string = "--", color = colors.white },
  update_freq = 1800,
  click_script = "open -a Weather",
})

local function update()
  sbar.exec("curl -s --max-time 5 'https://wttr.in/?format=%t' 2>/dev/null", function(r)
    r = (r or ""):gsub("[\r\n%+]", "")
    if r ~= "" and #r < 12 and not r:lower():find("unknown") then
      local n = tonumber(r:match("(-?%d+)"))
      weather:set({ label = r, icon = { color = temp_color(n) } })
    end
  end)
end

weather:subscribe({ "routine", "forced" }, update)
require("helpers.hover")(weather)
update()
