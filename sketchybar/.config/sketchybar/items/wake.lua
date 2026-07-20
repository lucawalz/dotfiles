local wake = sbar.add("item", "wake", {
  width = 0,
  icon = { drawing = false },
  label = { drawing = false },
})

wake:subscribe("system_woke", function()
  sbar.exec(os.getenv("CONFIG_DIR") .. "/helpers/wake.sh")
end)
