-- Charleston Demo - Main Application
-- This file demonstrates Lua syntax highlighting with Charleston colorscheme

local config = require("lib.config")
local utils = require("lib.utils")

---@class Application
---@field name string
---@field version string
---@field config table
local App = {}
App.__index = App

--- Create new application instance
---@param opts table Options for the application
---@return Application
function App:new(opts)
  opts = opts or {}
  local instance = setmetatable({}, self)

  instance.name = opts.name or "Charleston Demo"
  instance.version = opts.version or "1.0.0"
  instance.config = opts.config or config.default()

  return instance
end

--- Initialize the application
---@return boolean success
function App:init()
  print(string.format("Initializing %s v%s", self.name, self.version))

  -- Load configuration
  if not self.config then
    error("Configuration is required")
  end

  -- Setup logging
  if self.config.debug then
    utils.setup_logger("DEBUG")
  else
    utils.setup_logger("INFO")
  end

  return true
end

--- Run the main application loop
function App:run()
  self:init()

  print("Application running...")

  -- Main loop
  local running = true
  while running do
    local status = self:process()

    if not status then
      print("Error occurred, stopping...")
      running = false
    end

    -- Check for exit condition
    if self:should_exit() then
      running = false
    end
  end

  self:cleanup()
end

--- Process application logic
---@return boolean success
function App:process()
  -- TODO: Implement main logic
  return true
end

--- Check if application should exit
---@return boolean
function App:should_exit()
  -- FIXME: Implement proper exit handling
  return false
end

--- Cleanup resources
function App:cleanup()
  print("Cleaning up...")
  -- NOTE: Add cleanup logic here
end

-- Create and run application
local app = App:new({
  name = "Charleston",
  version = "1.0.0",
  config = {
    debug = true,
    log_level = "INFO",
  }
})

-- Export for testing
return App
