local colors = require("colors")
local settings = require("settings")
local icons = require("icons")

local cpu = sbar.add("item", "cpu", {
  position = "right",
  icon = { string = icons.cpu, font = settings.icon_font .. ":Bold:15.0", color = colors.white },
  label = { color = colors.white },
  update_freq = 2,
})

local function update()
  sbar.exec(os.getenv("CONFIG_DIR") .. "/helpers/cpu.sh", function(r)
    local p = tonumber((r or ""):match("%d+"))
    if p then cpu:set({ label = p .. "%" }) end
  end)
end

cpu:subscribe({ "routine", "forced" }, update)
update()

require("helpers.hover")(cpu)
