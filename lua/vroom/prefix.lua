local M = {}

local function gemfile_exists()
  return vim.fn.filereadable("Gemfile") == 1
end

local function binstub_exists(binstubs_path, command_word)
  return vim.fn.filereadable(binstubs_path .. "/" .. command_word) == 1
end

--- Build the command prefix based on config and runner type.
--- @param runner_type string "ruby"|"elixir"|"js"
--- @param runner_command string e.g. "rspec", "yarn test"
--- @param config table
--- @return string
function M.build(runner_type, runner_command, config)
  local prefix = ""

  local first_word = runner_command:match("^(%S+)")
  if first_word and binstub_exists(config.binstubs_path, first_word) then
    prefix = config.binstubs_path .. "/"
  elseif runner_type == "ruby" and gemfile_exists() then
    prefix = "bundle exec "
  end

  -- Prepend custom command prefix
  if config.command_prefix ~= "" then
    prefix = config.command_prefix .. " " .. prefix
  end

  -- Prepend clear screen
  if config.clear_screen then
    prefix = "clear; " .. prefix
  end

  return prefix
end

return M
