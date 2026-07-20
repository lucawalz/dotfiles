return function(item)
  item:subscribe("mouse.clicked", function()
    item:set({ popup = { drawing = "toggle" } })
  end)
  item:subscribe("mouse.exited.global", function()
    item:set({ popup = { drawing = false } })
  end)
end
