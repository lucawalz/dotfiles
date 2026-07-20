-- sketchybar execs commands without the login PATH, so off-PATH binaries need absolute paths
local BREW_PREFIX = "/opt/homebrew/bin/"

return {
  aerospace = BREW_PREFIX .. "aerospace",
  brew = BREW_PREFIX .. "brew",
  gh = BREW_PREFIX .. "gh",
  nowplaying = BREW_PREFIX .. "nowplaying-cli",
  sketchybar = BREW_PREFIX .. "sketchybar",
  ifconfig = "/sbin/ifconfig",
  ipconfig = "/usr/sbin/ipconfig",
}
