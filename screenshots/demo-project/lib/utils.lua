-- Utility functions
local M = {}

-- Logger instance
local logger = nil

--- Setup logger with specified level
---@param level string Log level (DEBUG, INFO, WARN, ERROR)
function M.setup_logger(level)
  logger = {
    level = level,
    debug = function(msg) print("[DEBUG] " .. msg) end,
    info = function(msg) print("[INFO] " .. msg) end,
    warn = function(msg) print("[WARN] " .. msg) end,
    error = function(msg) print("[ERROR] " .. msg) end,
  }
end

--- Get logger instance
---@return table|nil
function M.get_logger()
  return logger
end

--- Check if value is empty
---@param value any
---@return boolean
function M.is_empty(value)
  if value == nil then return true end
  if type(value) == "string" then return value == "" end
  if type(value) == "table" then return next(value) == nil end
  return false
end

--- Deep copy a table
---@param orig table
---@return table
function M.deep_copy(orig)
  local orig_type = type(orig)
  local copy

  if orig_type == "table" then
    copy = {}
    for orig_key, orig_value in next, orig, nil do
      copy[M.deep_copy(orig_key)] = M.deep_copy(orig_value)
    end
    setmetatable(copy, M.deep_copy(getmetatable(orig)))
  else
    copy = orig
  end

  return copy
end

--- Format bytes to human readable string
---@param bytes number
---@return string
function M.format_bytes(bytes)
  local units = { "B", "KB", "MB", "GB", "TB" }
  local i = 1

  while bytes >= 1024 and i < #units do
    bytes = bytes / 1024
    i = i + 1
  end

  return string.format("%.2f %s", bytes, units[i])
end

--- Get file extension
---@param filename string
---@return string
function M.get_extension(filename)
  return filename:match("^.+%.(.+)$") or ""
end

--- Check if file exists
---@param path string
---@return boolean
function M.file_exists(path)
  local stat = vim.loop.fs_stat(path)
  return stat ~= nil and stat.type == "file"
end

--- Read file contents
---@param path string
---@return string|nil, string|nil
function M.read_file(path)
  local file = io.open(path, "r")
  if not file then
    return nil, "Failed to open file"
  end

  local content = file:read("*all")
  file:close()

  return content, nil
end

--- Write content to file
---@param path string
---@param content string
---@return boolean, string|nil
function M.write_file(path, content)
  local file = io.open(path, "w")
  if not file then
    return false, "Failed to open file for writing"
  end

  file:write(content)
  file:close()

  return true, nil
end

return M
