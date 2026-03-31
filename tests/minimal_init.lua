-- Minimal init for running plenary tests
vim.cmd([[set runtimepath+=.]])

-- Add plenary to runtimepath if not already available (lazy.nvim installs)
local plenary_paths = {
  vim.fn.stdpath("data") .. "/lazy/plenary.nvim",
  vim.fn.stdpath("data") .. "/site/pack/vendor/start/plenary.nvim",
}

for _, path in ipairs(plenary_paths) do
  if vim.fn.isdirectory(path) == 1 then
    vim.cmd("set runtimepath+=" .. path)
    break
  end
end
