local colors = require("colors")
local settings = require("settings")
local icons = require("icons")

local media = sbar.add("item", "media", {
  position = "center",
  display = 1,
  icon = { string = icons.music, color = colors.accent, font = settings.font .. ":Bold:14.0", drawing = false },
  label = { color = colors.fg, max_chars = 40, font = settings.font .. ":Bold:13.0", drawing = false },
  update_freq = 3,
  scroll_texts = true,
  popup = { align = "center", horizontal = true },
})

sbar.add("item", "media.back", {
  position = "popup." .. media.name,
  icon = { string = icons.media.back, color = colors.fg },
  label = { drawing = false },
  click_script = "nowplaying-cli previous",
})
sbar.add("item", "media.play", {
  position = "popup." .. media.name,
  icon = { string = icons.media.play, color = colors.accent },
  label = { drawing = false },
  click_script = "nowplaying-cli togglePlayPause",
})
sbar.add("item", "media.next", {
  position = "popup." .. media.name,
  icon = { string = icons.media.forward, color = colors.fg },
  label = { drawing = false },
  click_script = "nowplaying-cli next",
})

local function update()
  sbar.exec("nowplaying-cli get title artist playbackRate 2>/dev/null", function(r)
    local lines = {}
    for l in (r or ""):gmatch("[^\r\n]+") do lines[#lines + 1] = l end
    local title, artist, rate = lines[1], lines[2], lines[3]
    local playing = title and title ~= "null" and title ~= ""
      and rate and rate ~= "0" and rate ~= "null" and rate ~= ""
    if playing then
      local label = (artist and artist ~= "null" and artist ~= "")
        and (artist .. " - " .. title) or title
      media:set({ icon = { drawing = true }, label = { drawing = true, string = label } })
    else
      media:set({ icon = { drawing = false }, label = { drawing = false }, popup = { drawing = false } })
    end
  end)
end

media:subscribe({ "routine", "forced" }, update)
media:subscribe("mouse.entered", function() media:set({ popup = { drawing = true } }) end)
media:subscribe("mouse.exited", function() media:set({ popup = { drawing = false } }) end)
update()
