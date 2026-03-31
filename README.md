# vroom.nvim

Run your tests from Neovim. Supports RSpec, MiniTest (Rails), ExUnit (Elixir), and Jest/Vitest (JS/TS).

Originally forked from Gary Bernhardt's `.vimrc`, now rewritten in Lua for modern Neovim.

## Installation

### [lazy.nvim](https://github.com/folke/lazy.nvim)

```lua
-- Minimal
{ "stulzer/vim-vroom" }

-- Very lazy (loads only when command or key is used)
{
  "stulzer/vim-vroom",
  cmd = { "VroomRunTestFile", "VroomRunNearestTest", "VroomRunLastTest" },
  keys = {
    { "<Leader>r", "<cmd>VroomRunTestFile<cr>", desc = "Run test file" },
    { "<Leader>R", "<cmd>VroomRunNearestTest<cr>", desc = "Run nearest test" },
    { "<Leader>l", "<cmd>VroomRunLastTest<cr>", desc = "Run last test" },
  },
  opts = {},
}
```

### Manual

```lua
require("vroom").setup({})
```

## Usage

| Key            | Command                | Description                                  |
|----------------|------------------------|----------------------------------------------|
| `<Leader>r`    | `:VroomRunTestFile`    | Run the current test file                    |
| `<Leader>R`    | `:VroomRunNearestTest` | Run the test at the cursor line              |
| `<Leader>l`    | `:VroomRunLastTest`    | Re-run the last test                         |

Tests run in a Neovim terminal split at the bottom of the window.

When called from a non-test buffer, `<Leader>r` and `<Leader>R` re-run the last test file for that tab.

## Supported Test Frameworks

| Pattern                       | Runner         | Example                      |
|-------------------------------|----------------|------------------------------|
| `*_spec.rb`                   | `rspec`        | `spec/models/user_spec.rb`   |
| `*_test.rb` / `test_*.rb`    | `rails test`   | `test/models/user_test.rb`   |
| `*_test.exs`                 | `mix test`     | `test/accounts_test.exs`     |
| `*.test.{js,ts,jsx,tsx}`     | `yarn test`    | `src/Button.test.tsx`        |
| `*.spec.{js,ts,jsx,tsx}`     | `yarn test`    | `src/utils/helpers.spec.ts`  |
| `__tests__/*.{js,ts,jsx,tsx}`| `yarn test`    | `src/__tests__/Button.js`    |

## Configuration

```lua
require("vroom").setup({
  map_keys = true,                    -- Map <Leader>r/R/l (default: true)
  clear_screen = true,                -- Prefix commands with "clear;" (default: true)
  write_all = false,                  -- :wall vs :w before running (default: false)
  spec_command = "rspec",             -- RSpec command (default: "rspec")
  test_unit_command = "rails test",   -- MiniTest command (default: "rails test")
  mix_test_command = "mix test",      -- ExUnit command (default: "mix test")
  yarn_test_command = "yarn test",    -- JS/TS test command (default: "yarn test")
  use_colors = true,                  -- Append --color to rspec/mix (default: true)
  binstubs_path = "./bin",            -- Binstubs directory (default: "./bin")
  command_prefix = "",                -- Custom prefix for Docker/SSH (default: "")
})
```

### Binstub Auto-Detection

Vroom automatically detects binstubs per command. For each test run, it checks
if `{binstubs_path}/{command}` exists (e.g., `./bin/rspec`, `./bin/yarn`).

- Binstub found → uses it (e.g., `./bin/yarn test file.spec.ts`)
- No binstub + Ruby + Gemfile → falls back to `bundle exec`
- Otherwise → bare command

This means mixed projects work out of the box — for example, `./bin/yarn test`
for JS specs and `bundle exec rspec` for Ruby specs when `./bin/rspec` doesn't exist.

### Docker / Remote

```lua
opts = {
  command_prefix = "docker compose exec web",
}
```

## Running Tests

This plugin uses [plenary.nvim](https://github.com/nvim-lua/plenary.nvim) for testing:

```bash
nvim --headless -u tests/minimal_init.lua \
  -c "PlenaryBustedDirectory tests/vroom/ {minimal_init = 'tests/minimal_init.lua'}"
```

## Credit

Originally created by [Mike Skalnik](https://mikeskalnik.com), inspired by
[Gary Bernhardt's .vimrc](https://github.com/garybernhardt/dotfiles) and
[Steven Harman](https://github.com/stevenharman).

## License

MIT
