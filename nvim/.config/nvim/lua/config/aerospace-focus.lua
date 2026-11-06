local M = {}

local lock = vim.fn.stdpath("state") .. "/aerospace-focus.lock"
local focus_script = vim.fn.expand("~/.config/aerospace/scripts/focus.sh")
local keys = { left = "h", down = "j", up = "k", right = "l" }

function M.focus(direction)
  local key = keys[direction]
  if not key then
    return 0
  end
  vim.schedule(function()
    local before = vim.api.nvim_get_current_win()
    vim.cmd.wincmd(key)
    if vim.api.nvim_get_current_win() == before then
      vim.system({ focus_script, "--pane", vim.env.TMUX_PANE or "", direction })
    end
  end)
  return 0
end

local function claim()
  if #vim.api.nvim_list_uis() == 0 then
    return
  end
  local f = io.open(lock, "w")
  if f then
    f:write(vim.v.servername, "\n", vim.env.TMUX_PANE or "", "\n")
    f:close()
  end
end

local function release()
  local f = io.open(lock, "r")
  if not f then
    return
  end
  local owner = f:read("*l")
  f:close()
  if owner == vim.v.servername then
    os.remove(lock)
  end
end

function M.setup()
  if vim.fn.executable("aerospace") == 0 then
    return
  end
  local group = vim.api.nvim_create_augroup("AerospaceFocus", {})
  vim.api.nvim_create_autocmd({ "VimEnter", "FocusGained" }, { group = group, callback = claim })
  vim.api.nvim_create_autocmd({ "VimLeavePre", "FocusLost" }, { group = group, callback = release })
end

return M
