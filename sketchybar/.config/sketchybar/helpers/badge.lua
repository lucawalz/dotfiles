local settings = require("settings")

return function(n, color)
  return {
    string = tostring(n),
    drawing = true,
    color = color,
    font = settings.font .. ":Bold:11.0",
    y_offset = 6,
  }
end
