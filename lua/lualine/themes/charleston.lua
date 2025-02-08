local colors = vim.g.palette

return {
  normal = {
    a = { fg = colors.bg, bg = colors.white, gui = "bold" },
    b = { fg = colors.bg, bg = colors.blue },
    c = { fg = colors.blue, bg = colors.bar_bg },
    x = { fg = colors.grey, bg = colors.bar_bg },
    y = { fg = colors.bg, bg = colors.blue },
    z = { fg = colors.bg, bg = colors.teal },
  },
  insert = {
    a = { fg = colors.bg, bg = colors.green, gui = "bold" },
  },
  visual = {
    a = { fg = colors.bg, bg = colors.purple, gui = "bold" },
  },
  replace = {
    a = { fg = colors.bg, bg = colors.magenta, gui = "bold" },
  },
  command = {
    a = { bg = colors.darkorange, fg = colors.bg, gui = "bold" },
  },
  inactive = {
    a = { fg = colors.blue, bg = colors.silver, gui = "bold" },
  },
}
