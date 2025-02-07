local colors = require("austere.colors")
local theme = require("austere.theme")

local M = {}
M.version = "1.0.0"

M.defaults_opts = {
  terminal_colors = true,
  italic = true,
  dimmed_background = false,
}

function M.setup(custom_opts)
  M.opts = vim.tbl_deep_extend("keep", custom_opts or {}, M.defaults_opts)

  -- show debug information about custom_opts
  if custom_opts.debug then
    local function dump(o)
      if type(o) == "table" then
        local s = "{ "
        for k, v in pairs(o) do
          if type(k) ~= "number" then
            k = '"' .. k .. '"'
          end
          s = s .. "[" .. k .. "] = " .. dump(v) .. ","
        end
        return s .. "} "
      else
        return tostring(o)
      end
    end
    vim.notify(dump(custom_opts), vim.log.levels.INFO, { title = "Opts" })
  end
end

function M.load()
  if vim.version().minor < 8 then
    vim.notify("Neovim 0.8+ is required for this colorscheme", vim.log.levels.ERROR, { title = "Austere colorscheme" })
    return
  end

  vim.api.nvim_command("hi clear")
  if vim.fn.exists("syntax_on") then
    vim.api.nvim_command("syntax reset")
  end

  vim.g.colors_name = "austere"
  vim.g.palette = colors.palette

  return theme.setup(M.opts)
end

return M
