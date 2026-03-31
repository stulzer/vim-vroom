local M = {}

local patterns = {
  { pattern = "_spec%.rb$", runner = "spec_command", type = "ruby" },
  { pattern = "_test%.rb$", runner = "test_unit_command", type = "ruby" },
  { pattern = "/test_[^/]*%.rb$", runner = "test_unit_command", type = "ruby" },
  { pattern = "_test%.exs$", runner = "mix_test_command", type = "elixir" },
  { pattern = "%.test%.[jt]sx?$", runner = "yarn_test_command", type = "js" },
  { pattern = "%.spec%.[jt]sx?$", runner = "yarn_test_command", type = "js" },
  { pattern = "__tests__/.*%.[jt]sx?$", runner = "yarn_test_command", type = "js" },
}

--- Detect the test runner for a given filename.
--- @param filename string
--- @return {runner: string, type: string}|nil
function M.detect(filename)
  for _, entry in ipairs(patterns) do
    if filename:match(entry.pattern) then
      return { runner = entry.runner, type = entry.type }
    end
  end
  return nil
end

--- Check if a filename is a test file.
--- @param filename string
--- @return boolean
function M.is_test_file(filename)
  return M.detect(filename) ~= nil
end

--- Build the full test command.
--- @param filename string
--- @param prefix string
--- @param config table
--- @param opts? {line: number}
--- @return string
function M.build_command(filename, prefix, config, opts)
  opts = opts or {}
  local info = M.detect(filename)
  if not info then
    return ""
  end

  local runner_cmd = config[info.runner]
  local color_flag = ""

  if config.use_colors and (info.type == "ruby" or info.type == "elixir") then
    color_flag = " --color"
  end

  local line_suffix = ""
  if opts.line and (info.type == "ruby" or info.type == "elixir") then
    line_suffix = ":" .. opts.line
  end

  return prefix .. runner_cmd .. color_flag .. " " .. filename .. line_suffix
end

return M
