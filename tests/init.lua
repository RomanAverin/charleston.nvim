-- Test initialization for charleston.nvim
-- This file sets up the test environment and runs all tests

-- Add the lua directory to the package path
package.path = package.path .. ";./lua/?.lua;./lua/?/init.lua"

-- Mock vim functions for testing
_G.vim = {
  inspect = function(val)
    return tostring(val)
  end,
  api = {
    nvim_set_hl = function() end,
    nvim_set_hl_ns = function() end,
  },
  fn = {
    has = function() return true end,
  },
  o = {},
  tbl_extend = function(behavior, ...)
    local result = {}
    for i = 1, select('#', ...) do
      local tbl = select(i, ...)
      if tbl then
        for k, v in pairs(tbl) do
          if behavior == "force" or result[k] == nil then
            result[k] = v
          end
        end
      end
    end
    return result
  end,
}

-- Simple test framework
local test_results = {
  passed = 0,
  failed = 0,
  errors = {},
}

local function assert(condition, message)
  if not condition then
    test_results.failed = test_results.failed + 1
    table.insert(test_results.errors, message or "Assertion failed")
    error(message or "Assertion failed", 2)
  else
    test_results.passed = test_results.passed + 1
  end
end

local function describe(name, fn)
  print("Running: " .. name)
  local success, err = pcall(fn)
  if not success then
    print("  FAILED: " .. err)
  end
end

local function it(name, fn)
  io.write("  " .. name .. " ... ")
  local success, err = pcall(fn)
  if success then
    print("✓")
  else
    print("✗")
    print("    " .. (err or "Unknown error"))
  end
end

local function before_each(fn)
  -- Simple before_each implementation - just run the function
  -- In a real test framework this would be more sophisticated
  _G._before_each_fn = fn
end

-- Export test functions globally
_G.describe = describe
_G.it = it
_G.assert = assert
_G.before_each = before_each

-- Load and run test files
local function run_tests()
  print("Running tests for charleston.nvim...\n")

  -- Load test files
  local test_files = {
    "highlights_spec.lua",
  }

  for _, file in ipairs(test_files) do
    local path = "./tests/" .. file
    local chunk, err = loadfile(path)
    if chunk then
      chunk()
    else
      print("Failed to load test file " .. file .. ": " .. err)
    end
  end

  print(string.format("\nTest Results: %d passed, %d failed", test_results.passed, test_results.failed))

  if test_results.failed > 0 then
    print("\nErrors:")
    for _, err in ipairs(test_results.errors) do
      print("  - " .. err)
    end
    os.exit(1)
  else
    print("All tests passed!")
  end
end

-- Run tests when this file is executed
if arg and arg[0] and arg[0]:match("init%.lua$") then
  run_tests()
end