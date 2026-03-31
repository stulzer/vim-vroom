local M = {}

M.defaults = {
  map_keys = true,
  clear_screen = true,
  write_all = false,
  spec_command = "rspec",
  test_unit_command = "rails test",
  mix_test_command = "mix test",
  yarn_test_command = "yarn test",
  use_colors = true,
  binstubs_path = "./bin",
  command_prefix = "",
}

local config = nil

function M.setup(opts)
  config = vim.tbl_deep_extend("force", {}, M.defaults, opts or {})

  return config
end

function M.get()
  return config or M.defaults
end

return M
