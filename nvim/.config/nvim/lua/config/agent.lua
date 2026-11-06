local M = {}

local function relative_path() return vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":.") end

function M.path_ref(absolute)
  local path = vim.fn.expand(absolute and "%:p" or "%:.")
  return path .. "#L" .. vim.fn.line(".")
end

function M.selection_block(first, last)
  local lines = vim.api.nvim_buf_get_lines(0, first - 1, last, false)
  local label = ("%s#L%d-L%d"):format(relative_path(), first, last)
  return table.concat({ label, "```" .. vim.bo.filetype, table.concat(lines, "\n"), "```" }, "\n")
end

local function yank(text)
  vim.fn.setreg("+", text)
  vim.notify("Yanked: " .. text:match("[^\n]*"))
end

vim.keymap.set("n", "<leader>yf", function() yank(M.path_ref(false)) end, { desc = "Yank relative path and line" })
vim.keymap.set("n", "<leader>yp", function() yank(M.path_ref(true)) end, { desc = "Yank absolute path and line" })
vim.keymap.set("x", "<leader>cc", function()
  local first, last = vim.fn.line("v"), vim.fn.line(".")
  if first > last then
    first, last = last, first
  end
  vim.cmd("normal! \27")
  yank(M.selection_block(first, last))
end, { desc = "Yank selection as agent prompt block" })

return M
