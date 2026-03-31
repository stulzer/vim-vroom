local config = require("vroom.config")
local runner = require("vroom.runner")
local prefix = require("vroom.prefix")
local terminal = require("vroom.terminal")

local M = {}

local _setup_done = false
local _last_cmd = nil

local function ensure_setup()
  if not _setup_done then
    M.setup({})
  end
end

local function save_and_prepare()
  local cfg = config.get()
  if cfg.write_all then
    vim.cmd("silent! wall")
  elseif vim.bo.buftype ~= "terminal" then
    vim.cmd("silent! write")
  end
end

local function is_terminal_buffer()
  return vim.bo.buftype == "terminal"
end

function M.setup(opts)
  config.setup(opts)
  _setup_done = true

  local cfg = config.get()

  if cfg.map_keys then
    vim.keymap.set("n", "<Leader>r", "<cmd>VroomRunTestFile<cr>", { silent = true, desc = "Run test file" })
    vim.keymap.set("n", "<Leader>R", "<cmd>VroomRunNearestTest<cr>", { silent = true, desc = "Run nearest test" })
    vim.keymap.set("n", "<Leader>l", "<cmd>VroomRunLastTest<cr>", { silent = true, desc = "Run last test" })
  end
end

function M.run_test_file()
  ensure_setup()

  local filename = vim.fn.fnamemodify(vim.fn.expand("%"), ":~:.")

  if runner.is_test_file(filename) and not is_terminal_buffer() then
    vim.t.vroom_test_file = filename
  elseif not vim.t.vroom_test_file then
    return
  end

  save_and_prepare()

  local cfg = config.get()
  local info = runner.detect(vim.t.vroom_test_file)
  if not info then
    return
  end

  local pfx = prefix.build(info.type, cfg[info.runner], cfg)
  local cmd = runner.build_command(vim.t.vroom_test_file, pfx, cfg)

  _last_cmd = cmd
  terminal.run(cmd)
end

function M.run_nearest_test()
  ensure_setup()

  local filename = vim.fn.fnamemodify(vim.fn.expand("%"), ":~:.")

  if runner.is_test_file(filename) then
    vim.t.vroom_test_file = filename
    vim.t.vroom_nearest_test = vim.fn.line(".")
  elseif not vim.t.vroom_nearest_test then
    return
  end

  save_and_prepare()

  local cfg = config.get()
  local info = runner.detect(vim.t.vroom_test_file)
  if not info then
    return
  end

  local pfx = prefix.build(info.type, cfg[info.runner], cfg)
  local cmd = runner.build_command(vim.t.vroom_test_file, pfx, cfg, {
    line = vim.t.vroom_nearest_test,
  })

  _last_cmd = cmd
  terminal.run(cmd)
end

function M.run_last_test()
  ensure_setup()

  if _last_cmd then
    terminal.run(_last_cmd)
  else
    vim.notify("No test was run.", vim.log.levels.WARN)
  end
end

return M
