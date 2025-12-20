-- Configuration module
local M = {}

-- Default configuration
M.defaults = {
  -- Application settings
  app = {
    name = "Charleston Demo",
    version = "1.0.0",
    debug = false,
  },

  -- UI settings
  ui = {
    theme = "charleston",
    icons = true,
    transparency = false,
  },

  -- Editor settings
  editor = {
    line_numbers = true,
    relative_numbers = true,
    cursor_line = true,
    sign_column = "yes",
  },

  -- Plugin settings
  plugins = {
    telescope = { enabled = true },
    neotree = { enabled = true },
    lualine = { enabled = true },
    treesitter = { enabled = true },
  },
}

--- Get default configuration
---@return table
function M.default()
  return vim.deepcopy(M.defaults)
end

--- Merge user config with defaults
---@param user_config table
---@return table
function M.merge(user_config)
  return vim.tbl_deep_extend("force", M.defaults, user_config or {})
end

--- Validate configuration
---@param cfg table
---@return boolean, string|nil
function M.validate(cfg)
  if not cfg.app or not cfg.app.name then
    return false, "app.name is required"
  end

  if cfg.app.version and type(cfg.app.version) ~= "string" then
    return false, "app.version must be a string"
  end

  return true
end

return M
