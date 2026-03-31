local prefix = require("vroom.prefix")
local config = require("vroom.config")

describe("prefix", function()
  describe("build", function()
    it("returns clear prefix by default", function()
      local cfg = config.setup({})
      local result = prefix.build("ruby", "rspec", cfg)
      assert.equals("clear; ", result)
    end)

    it("returns empty when clear_screen is disabled", function()
      local cfg = config.setup({ clear_screen = false })
      local result = prefix.build("ruby", "rspec", cfg)
      assert.equals("", result)
    end)

    it("uses binstub when ./bin/rspec exists", function()
      local original = vim.fn.filereadable
      vim.fn.filereadable = function(f)
        if f == "./bin/rspec" then return 1 end
        return 0
      end

      local cfg = config.setup({ clear_screen = false })
      local result = prefix.build("ruby", "rspec", cfg)
      assert.equals("./bin/", result)

      vim.fn.filereadable = original
    end)

    it("uses binstub when ./bin/yarn exists", function()
      local original = vim.fn.filereadable
      vim.fn.filereadable = function(f)
        if f == "./bin/yarn" then return 1 end
        return 0
      end

      local cfg = config.setup({ clear_screen = false })
      local result = prefix.build("js", "yarn test", cfg)
      assert.equals("./bin/", result)

      vim.fn.filereadable = original
    end)

    it("uses binstub when ./bin/rails exists for rails test", function()
      local original = vim.fn.filereadable
      vim.fn.filereadable = function(f)
        if f == "./bin/rails" then return 1 end
        return 0
      end

      local cfg = config.setup({ clear_screen = false })
      local result = prefix.build("ruby", "rails test", cfg)
      assert.equals("./bin/", result)

      vim.fn.filereadable = original
    end)

    it("falls back to bundle exec for ruby when no binstub and Gemfile exists", function()
      local original = vim.fn.filereadable
      vim.fn.filereadable = function(f)
        if f == "Gemfile" then return 1 end
        return 0
      end

      local cfg = config.setup({ clear_screen = false })
      local result = prefix.build("ruby", "rspec", cfg)
      assert.equals("bundle exec ", result)

      vim.fn.filereadable = original
    end)

    it("does not add bundle exec for js even with Gemfile", function()
      local original = vim.fn.filereadable
      vim.fn.filereadable = function(f)
        if f == "Gemfile" then return 1 end
        return 0
      end

      local cfg = config.setup({ clear_screen = false })
      local result = prefix.build("js", "yarn test", cfg)
      assert.equals("", result)

      vim.fn.filereadable = original
    end)

    it("does not add bundle exec for elixir", function()
      local original = vim.fn.filereadable
      vim.fn.filereadable = function(f)
        if f == "Gemfile" then return 1 end
        return 0
      end

      local cfg = config.setup({ clear_screen = false })
      local result = prefix.build("elixir", "mix test", cfg)
      assert.equals("", result)

      vim.fn.filereadable = original
    end)

    it("no prefix when no binstub and no Gemfile", function()
      local original = vim.fn.filereadable
      vim.fn.filereadable = function() return 0 end

      local cfg = config.setup({ clear_screen = false })
      local result = prefix.build("ruby", "rspec", cfg)
      assert.equals("", result)

      vim.fn.filereadable = original
    end)

    it("binstub takes priority over bundle exec", function()
      local original = vim.fn.filereadable
      vim.fn.filereadable = function(f)
        if f == "./bin/rspec" then return 1 end
        if f == "Gemfile" then return 1 end
        return 0
      end

      local cfg = config.setup({ clear_screen = false })
      local result = prefix.build("ruby", "rspec", cfg)
      assert.equals("./bin/", result)

      vim.fn.filereadable = original
    end)

    it("prepends command_prefix", function()
      local cfg = config.setup({ command_prefix = "docker compose exec web", clear_screen = false })
      local result = prefix.build("ruby", "rspec", cfg)
      assert.equals("docker compose exec web ", result)
    end)

    it("combines command_prefix with binstub", function()
      local original = vim.fn.filereadable
      vim.fn.filereadable = function(f)
        if f == "./bin/rspec" then return 1 end
        return 0
      end

      local cfg = config.setup({ command_prefix = "docker compose exec web", clear_screen = false })
      local result = prefix.build("ruby", "rspec", cfg)
      assert.equals("docker compose exec web ./bin/", result)

      vim.fn.filereadable = original
    end)

    it("combines clear_screen with bundle exec", function()
      local original = vim.fn.filereadable
      vim.fn.filereadable = function(f)
        if f == "Gemfile" then return 1 end
        return 0
      end

      local cfg = config.setup({ clear_screen = true })
      local result = prefix.build("ruby", "rspec", cfg)
      assert.equals("clear; bundle exec ", result)

      vim.fn.filereadable = original
    end)

    it("combines clear_screen with binstub", function()
      local original = vim.fn.filereadable
      vim.fn.filereadable = function(f)
        if f == "./bin/yarn" then return 1 end
        return 0
      end

      local cfg = config.setup({ clear_screen = true })
      local result = prefix.build("js", "yarn test", cfg)
      assert.equals("clear; ./bin/", result)

      vim.fn.filereadable = original
    end)

    it("custom binstubs_path", function()
      local original = vim.fn.filereadable
      vim.fn.filereadable = function(f)
        if f == "./vendor/bin/rspec" then return 1 end
        return 0
      end

      local cfg = config.setup({ binstubs_path = "./vendor/bin", clear_screen = false })
      local result = prefix.build("ruby", "rspec", cfg)
      assert.equals("./vendor/bin/", result)

      vim.fn.filereadable = original
    end)
  end)
end)
