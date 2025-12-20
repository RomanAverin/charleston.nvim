-- Charleston colorscheme example
local M = {}

-- Color palette
local colors = {
  bg = "#1D2024",
  fg = "#C5C8D3",
  red = "#cc6666",
  green = "#A9C476",
  yellow = "#D0AB3C",
  blue = "#88ABDC",
  magenta = "#B689BC",
  cyan = "#7fb2c8",
}

--- Setup the colorscheme
---@param config table Configuration options
---@return nil
function M.setup(config)
  config = config or {}

  -- Apply highlights
  for group, hl in pairs(M.highlights) do
    vim.api.nvim_set_hl(0, group, hl)
  end

  -- Set terminal colors
  if config.terminal_colors then
    M.set_terminal_colors()
  end
end

--- Get color by name
---@param name string Color name
---@return string Hex color value
function M.get_color(name)
  return colors[name] or colors.fg
end

-- Example of string manipulation
local function process_text(text)
  local result = text:gsub("%s+", " ")
  return result:match("^%s*(.-)%s*$")
end

-- Example table with data
local plugins = {
  "telescope.nvim",
  "nvim-treesitter",
  "lualine.nvim",
}

-- Iterate through plugins
for i, plugin in ipairs(plugins) do
  print(string.format("%d. %s", i, plugin))
end

return M
