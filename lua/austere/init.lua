local M = {}

function M.load(opts)
  opts = require("austere.config").extend(opts)

  local palette = require("austere.colors").palette
  vim.g.palette = palette

  return require("austere.theme").setup(opts)
end

M.setup = require("austere.config").setup

return M
