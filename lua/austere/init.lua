local M = {}

function M.load(opts)
  opts = require("austere.config").extend(opts)

  return require("austere.theme").setup(opts)
end

M.setup = require("austere.config").setup

return M
