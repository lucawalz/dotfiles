local colors = require("colors")

-- Adds a subtle background that fades in while the mouse is over the item.
return function(item)
  item:subscribe("mouse.entered", function()
    sbar.animate("tanh", 10, function()
      item:set({ background = { drawing = true, color = colors.item_bg } })
    end)
  end)
  item:subscribe("mouse.exited", function()
    sbar.animate("tanh", 10, function()
      item:set({ background = { color = colors.transparent } })
    end)
  end)
end
