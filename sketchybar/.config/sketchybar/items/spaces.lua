local colors = require("colors")
local settings = require("settings")
local icons = require("icons")
local app_icons = require("icon_map")

sbar.add("event", "aerospace_workspace_change")

local function shell(c)
  local h = io.popen(c)
  local r = h:read("*a")
  h:close()
  return r
end

local display_count = tonumber(shell("aerospace list-monitors 2>/dev/null | grep -c '|'")) or 1

local COLOR_FRAMES, MORPH_FRAMES = 15, 12

local function render_apps(space, sid, is_focused)
  sbar.exec("aerospace list-windows --workspace " .. sid .. " --format '%{app-name}' | sort -u", function(apps_str)
    local glyphs = {}
    for app in (apps_str or ""):gmatch("[^\r\n]+") do
      local name = app:gsub("^%s*(.-)%s*$", "%1")
      if name ~= "" then
        glyphs[#glyphs + 1] = app_icons[name] or app_icons["Default"]
      end
    end
    sbar.animate("tanh", MORPH_FRAMES, function()
      if #glyphs == 0 then
        space:set({ label = { drawing = false } })
      elseif is_focused then
        space:set({ label = { string = " " .. table.concat(glyphs, " "), drawing = true } })
      else
        space:set({ label = { string = " " .. glyphs[1], drawing = true } })
      end
    end)
  end)
end

local function update_space(space, sid)
  sbar.exec("aerospace list-workspaces --focused", function(focused)
    focused = (focused or ""):gsub("%s", "")
    local is_focused = (focused == tostring(sid))
    sbar.animate("tanh", COLOR_FRAMES, function()
      space:set({
        background = { color = is_focused and colors.accent or colors.transparent },
        icon = { color = is_focused and colors.bar_color or colors.fg_dim },
        label = { color = is_focused and colors.bar_color or colors.fg_dim },
      })
    end)
    render_apps(space, sid, is_focused)
  end)
end

for sid = 1, 5 do
  local display = "all"
  if display_count >= 2 then
    display = (sid <= 3) and 1 or 2
  end

  local space = sbar.add("item", "space." .. sid, {
    position = "left",
    display = display,
    icon = {
      string = tostring(sid),
      padding_left = 9,
      padding_right = 7,
      color = colors.fg_dim,
    },
    label = {
      font = settings.app_font .. ":Regular:15.0",
      padding_right = 16,
      y_offset = -1,
      color = colors.fg_dim,
      drawing = false,
    },
    background = {
      drawing = true,
      color = colors.transparent,
      corner_radius = 6,
      height = 26,
    },
  })

  space:subscribe("aerospace_workspace_change", function() update_space(space, sid) end)
  space:subscribe("front_app_switched", function() update_space(space, sid) end)
  space:subscribe("mouse.clicked", function() sbar.exec("aerospace workspace " .. sid) end)

  update_space(space, sid)
end

sbar.add("item", "separator", {
  position = "left",
  icon = {
    string = icons.chevron,
    font = settings.font .. ":Bold:15.0",
    color = colors.accent,
    padding_left = 8,
    padding_right = 4,
  },
  label = { drawing = false },
})
