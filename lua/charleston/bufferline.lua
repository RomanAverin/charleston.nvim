local M = {}

---Get bufferline theme configuration
---@param opts? table Optional configuration { styles = table, custom = table }
---@return table Bufferline highlights configuration
function M.get_theme(opts)
  opts = opts or {}

  -- Get the charleston instance to access options and palette
  local charleston = require("charleston")
  local user_opts = charleston.opts or charleston.defaults_opts
  local palette = charleston.get_palette()

  -- Setup options
  local color = palette
  color.bg = user_opts.darker_background and color.bg or color.bg_dimmed

  -- Setup transparent backgrounds
  local bar_bg = user_opts.transparent and "NONE" or color.bar_bg

  -- Apply custom styles if provided
  local styles = opts.styles or {}
  local use_bold = vim.tbl_contains(styles, "bold")
  local use_italic = vim.tbl_contains(styles, "italic")

  -- Base theme configuration
  local theme = {
    -- Background states
    background = { fg = color.bar_faded_text, bg = bar_bg },
    buffer_visible = { fg = color.bar_text, bg = bar_bg },
    buffer_selected = {
      fg = color.white,
      bold = use_bold or true,
      italic = use_italic,
      bg = "NONE",
    },

    -- Fill
    fill = { bg = bar_bg },

    -- Tabs
    tab = { bg = bar_bg },
    tab_selected = { fg = color.white, bg = "NONE" },
    tab_separator = { fg = color.bg, bg = bar_bg },
    tab_separator_selected = { fg = color.bg, bg = "NONE" },
    tab_close = { fg = color.red, bg = bar_bg },

    -- Indicators
    indicator_visible = { fg = color.magenta, bg = bar_bg },
    indicator_selected = { fg = color.magenta, bg = "NONE" },

    -- Separators
    separator = { fg = color.bg, bg = bar_bg },
    separator_visible = { fg = color.bg, bg = bar_bg },
    separator_selected = { fg = color.bg, bg = "NONE" },
    offset_separator = { fg = color.bg, bg = bar_bg },

    -- Modified state
    modified = { fg = color.cyan, bg = bar_bg },
    modified_visible = { fg = color.cyan, bg = bar_bg },
    modified_selected = { fg = color.cyan, bg = "NONE" },

    -- Duplicate buffers
    duplicate = { fg = color.faded_text, bg = bar_bg },
    duplicate_visible = { fg = color.faded_text, bg = bar_bg },
    duplicate_selected = { fg = color.text, bg = "NONE" },

    -- Close button
    close_button = { fg = color.faded_text, bg = bar_bg },
    close_button_visible = { fg = color.faded_text, bg = bar_bg },
    close_button_selected = { fg = color.red, bg = "NONE" },

    -- Numbers
    numbers = { fg = color.bar_faded_text, bg = bar_bg },
    numbers_visible = { fg = color.bar_text, bg = bar_bg },
    numbers_selected = {
      fg = color.white,
      bold = use_bold or true,
      bg = "NONE",
    },

    -- Diagnostic states
    error = { fg = color.red, bg = bar_bg },
    error_visible = { fg = color.red, bg = bar_bg },
    error_selected = { fg = color.red, bg = "NONE" },
    error_diagnostic = { fg = color.red, bg = bar_bg },
    error_diagnostic_visible = { fg = color.red, bg = bar_bg },
    error_diagnostic_selected = { fg = color.red, bg = "NONE" },

    warning = { fg = color.yellow, bg = bar_bg },
    warning_visible = { fg = color.yellow, bg = bar_bg },
    warning_selected = { fg = color.yellow, bg = "NONE" },
    warning_diagnostic = { fg = color.yellow, bg = bar_bg },
    warning_diagnostic_visible = { fg = color.yellow, bg = bar_bg },
    warning_diagnostic_selected = { fg = color.yellow, bg = "NONE" },

    info = { fg = color.blue, bg = bar_bg },
    info_visible = { fg = color.blue, bg = bar_bg },
    info_selected = { fg = color.blue, bg = "NONE" },
    info_diagnostic = { fg = color.blue, bg = bar_bg },
    info_diagnostic_visible = { fg = color.blue, bg = bar_bg },
    info_diagnostic_selected = { fg = color.blue, bg = "NONE" },

    hint = { fg = color.silver, bg = bar_bg },
    hint_visible = { fg = color.silver, bg = bar_bg },
    hint_selected = { fg = color.silver, bg = "NONE" },
    hint_diagnostic = { fg = color.silver, bg = bar_bg },
    hint_diagnostic_visible = { fg = color.silver, bg = bar_bg },
    hint_diagnostic_selected = { fg = color.silver, bg = "NONE" },

    -- Pick state
    pick = { fg = color.orange, bg = bar_bg, bold = true },
    pick_visible = { fg = color.orange, bg = bar_bg, bold = true },
    pick_selected = { fg = color.orange, bold = true, bg = "NONE" },

    -- Trunc marker
    trunc_marker = { fg = color.bar_faded_text, bg = bar_bg },
  }

  -- Apply custom overrides if provided
  if opts.custom then
    if opts.custom.all then
      theme = vim.tbl_deep_extend("force", theme, opts.custom.all)
    end
  end

  return theme
end

return M
