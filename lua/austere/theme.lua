local M = {}

function M.setup(opts)
  opts = require("austere.config").extend(opts)

  local palette = require("austere.colors").palette

  vim.o.termguicolors = true
  vim.g.colors_name = "austere"

  -- only needed to clear when not the default colorscheme
  if vim.g.colors_name then
    vim.cmd("hi clear")
    vim.cmd("syntax reset")
  end

  local highlights = require("austere.highlights").get(palette)

  for group, hl in pairs(highlights) do
    hl = type(hl) == "string" and { link = hl } or hl
    vim.api.nvim_set_hl(0, group, hl)
  end

  if opts.terminal_color then
    M.apply_terminal_colors(palette)
  end
end

---@param palette Palette
function M.apply_terminal_colors(palette)
  vim.g.terminal_color_0 = palette.bg -- Black
  vim.g.terminal_color_1 = palette.red -- Red
  vim.g.terminal_color_2 = palette.green -- Green
  vim.g.terminal_color_3 = palette.yellow -- Yellow
  vim.g.terminal_color_4 = palette.blue -- Blue
  vim.g.terminal_color_5 = palette.magenta -- Magenta
  vim.g.terminal_color_6 = palette.cyan -- Cyan
  vim.g.terminal_color_7 = palette.white -- White
  vim.g.terminal_color_8 = palette.brightBlack -- Bright Black
  vim.g.terminal_color_9 = palette.brightRed -- Bright Red
  vim.g.terminal_color_10 = palette.brightGreen -- Bright Green
  vim.g.terminal_color_11 = palette.brightYellow -- Bright Yellow
  vim.g.terminal_color_12 = palette.brightBlue -- Bright Blue
  vim.g.terminal_color_13 = palette.brightMagenta -- Bright Magenta
  vim.g.terminal_color_14 = palette.brightCyan -- Bright Cyan
  vim.g.terminal_color_15 = palette.brightWhite -- Bright White
end

return M
