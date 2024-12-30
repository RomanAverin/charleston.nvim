local M = {}

M.version = "1.0"

M.defaults = {
  terminal_colors = true,
}

M.options = nil

function M.setup(options)
  M.options = vim.tbl_deep_extend("force", {}, M.defaults, options or {})
end

function M.extend(opts)
  return opts and vim.tbl_deep_extend("force", {}, M.options, opts) or M.options
end

setmetatable(M, {
  __index = function(_, k)
    if k == "options" then
      return M.defaults
    end
  end,
})

return M
