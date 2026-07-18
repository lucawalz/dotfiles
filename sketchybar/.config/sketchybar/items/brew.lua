local colors = require("colors")
local settings = require("settings")
local icons = require("icons")
local badge = require("helpers.badge")

local brew = sbar.add("item", "brew", {
  position = "right",
  icon = { string = icons.package, font = settings.font .. ":Bold:15.0", color = colors.fg_dim },
  label = { drawing = false },
  update_freq = 3600,
  click_script = "open -a Ghostty",
})

local function update()
  sbar.exec("/opt/homebrew/bin/brew outdated --quiet 2>/dev/null | grep -c .", function(r)
    local n = tonumber((r or ""):match("%d+"))
    if n and n > 0 then
      brew:set({
        icon = { string = icons.package, color = colors.warning },
        label = badge(n, colors.warning),
      })
    else
      brew:set({
        icon = { string = icons.package, color = colors.fg_dim },
        label = { drawing = false },
      })
    end
  end)
end

brew:subscribe({ "routine", "forced" }, update)
update()

require("helpers.hover")(brew)
