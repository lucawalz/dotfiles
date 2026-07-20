return function(item, update, events)
  local subscriptions = { "routine", "forced", "system_woke" }
  for _, event in ipairs(events or {}) do
    subscriptions[#subscriptions + 1] = event
  end
  item:subscribe(subscriptions, update)
  update()
end
