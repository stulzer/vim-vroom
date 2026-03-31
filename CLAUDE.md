# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project

vroom.nvim is a Neovim plugin (Lua) for running tests from within Neovim. Supports RSpec, MiniTest (Rails), ExUnit (Elixir), and Jest/Vitest (JS/TS). Originally forked from Gary Bernhardt's .vimrc.

## Repository Structure

- `plugin/vroom.lua` — Entry point. Defines commands (`:VroomRunTestFile`, `:VroomRunNearestTest`, `:VroomRunLastTest`). Loaded by Neovim automatically.
- `lua/vroom/init.lua` — Public API: `setup()`, `run_test_file()`, `run_nearest_test()`, `run_last_test()`. Orchestrates all modules.
- `lua/vroom/config.lua` — Default configuration and merge logic.
- `lua/vroom/runner.lua` — Filename pattern matching to detect test framework, command building.
- `lua/vroom/prefix.lua` — Prefix chain: auto-detected binstubs, bundle exec fallback, command_prefix, clear screen.
- `lua/vroom/terminal.lua` — Neovim terminal split management (open, reuse, close).
- `doc/vroom.txt` — Vim help documentation (`:help vroom`).
- `tests/` — Plenary-based unit tests.

## Tests

Run tests with plenary.nvim:

```bash
nvim --headless -u tests/minimal_init.lua \
  -c "PlenaryBustedDirectory tests/vroom/ {minimal_init = 'tests/minimal_init.lua'}"
```

## Architecture

**Test execution pipeline:**

1. Command triggered → `run_test_file()` / `run_nearest_test()`
2. Detect if current buffer is a test file via `runner.is_test_file()`, store path in `vim.t.vroom_test_file`
3. Save files, build prefix via `prefix.build()` (auto-detect binstub or bundle exec fallback, command_prefix, clear screen)
4. Build full command via `runner.build_command()` (prefix + runner + color flag + filename + line)
5. Dispatch via `terminal.run()` (Neovim terminal split)

**Runner detection** by filename pattern:
- `_spec.rb` → rspec
- `_test.rb` / `test_*.rb` → rails test
- `_test.exs` → mix test
- `.test.{js,ts,jsx,tsx}` / `.spec.{js,ts,jsx,tsx}` / `__tests__/*` → yarn test

**Prefix priority:** auto-detected binstub (`./bin/{cmd}` exists?) → bundle exec fallback (Ruby + Gemfile) → command_prefix → clear screen.
