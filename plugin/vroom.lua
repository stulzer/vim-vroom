if vim.g.loaded_vroom then
  return
end
vim.g.loaded_vroom = true

vim.api.nvim_create_user_command("VroomRunTestFile", function()
  require("vroom").run_test_file()
end, { desc = "Run current test file" })

vim.api.nvim_create_user_command("VroomRunNearestTest", function()
  require("vroom").run_nearest_test()
end, { desc = "Run nearest test" })

vim.api.nvim_create_user_command("VroomRunLastTest", function()
  require("vroom").run_last_test()
end, { desc = "Run last test" })
