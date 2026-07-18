local colors = require("colors")
local settings = require("settings")
local icons = require("icons")
local badge = require("helpers.badge")

local github = sbar.add("item", "github", {
  position = "right",
  icon = { string = icons.bell, font = settings.font .. ":Bold:15.0", color = colors.fg_dim },
  label = { drawing = false },
  update_freq = 180,
  click_script = "open https://github.com/notifications",
})

local function update()
  sbar.exec("/opt/homebrew/bin/gh api notifications --jq 'length' 2>/dev/null", function(r)
    local n = tonumber((r or ""):match("%d+"))
    if n and n > 0 then
      github:set({
        icon = { string = icons.bell, color = colors.critical },
        label = badge(n, colors.critical),
      })
    else
      github:set({
        icon = { string = icons.bell, color = colors.fg_dim },
        label = { drawing = false },
      })
    end
  end)
end

github:subscribe({ "routine", "forced" }, update)
update()

require("helpers.hover")(github)
