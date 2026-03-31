local M = {}

--- Run a command in a Neovim terminal split at the bottom.
--- Reuses the tab-scoped terminal buffer, closing the previous one if it exists.
--- @param cmd string
function M.run(cmd)
  -- Close previous terminal buffer if it exists
  local prev_buf = vim.t.vroom_terminal_bufnr
  if prev_buf and vim.api.nvim_buf_is_valid(prev_buf) then
    vim.api.nvim_buf_delete(prev_buf, { force = true })
  end

  -- Open a bottom split at 1/2 of the current window height
  local height = math.floor(vim.api.nvim_win_get_height(0) / 2)
  vim.cmd("belowright " .. height .. "new")

  -- Run the command in the terminal
  vim.fn.termopen(cmd)

  -- Stay in normal mode so the buffer persists after the command finishes
  vim.cmd("stopinsert")

  -- Store the buffer number for later reuse
  vim.t.vroom_terminal_bufnr = vim.api.nvim_get_current_buf()
end

return M
