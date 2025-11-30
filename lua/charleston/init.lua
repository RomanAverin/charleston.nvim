local colors = require("charleston.colors")
local theme = require("charleston.theme")

local M = {}
M.version = "1.6.0"

M.defaults_opts = {
  terminal_colors = true,
  italic = true,
  darker_background = false,
  transparent = false,
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
  if vim.version().minor < 9 then
    vim.notify(
      "Neovim 0.9+ is required for this colorscheme",
      vim.log.levels.ERROR,
      { title = "Charleston colorscheme" }
    )
    return
  end

  vim.api.nvim_command("hi clear")
  if vim.fn.exists("syntax_on") then
    vim.api.nvim_command("syntax reset")
  end

  vim.g.colors_name = "charleston"
  vim.g.palette = colors.palette

  if M.opts == nil then
    M.opts = M.defaults_opts
  end

  -- Generate hash for cache invalidation
  local hash = require("charleston.lib.hashing").hash(M.opts)

  local path_sep = package.config:sub(1, 1)
  local cache_path = vim.fn.stdpath("cache") .. path_sep .. "charleston"
  local compiled_path = cache_path .. path_sep .. "compiled.lua"
  local hash_path = cache_path .. path_sep .. "cached_hash"

  -- Check if cache is valid
  local cached_hash = ""
  local hash_file = io.open(hash_path, "r")
  if hash_file then
    cached_hash = hash_file:read("*all")
    hash_file:close()
  end

  -- Recompile if hash mismatch or compiled file missing
  if cached_hash ~= tostring(hash) or vim.fn.filereadable(compiled_path) == 0 then
    require("charleston.lib.compiler").compile(M.opts)

    -- Save new hash
    local new_hash_file = io.open(hash_path, "w")
    if new_hash_file then
      new_hash_file:write(tostring(hash))
      new_hash_file:close()
    end
  end

  -- Load compiled highlights
  local compiled = loadfile(compiled_path)
  if compiled then
    compiled()
    -- Apply terminal colors if enabled
    if M.opts.terminal_colors then
      theme.apply_terminal_colors(colors.palette)
    end
  else
    -- Fallback to direct application
    theme.setup(M.opts)
  end

  -- Reapply highlights after all plugins are loaded (fixes render-markdown issue)
  vim.api.nvim_create_autocmd("User", {
    pattern = "LazyDone",
    callback = function()
      if vim.g.colors_name == "charleston" then
        local recompiled = loadfile(compiled_path)
        if recompiled then
          recompiled()
        end
      end
    end,
    desc = "Reapply Charleston highlights after plugins load",
  })

  return colors.palette
end

-- User command for manual recompilation
vim.api.nvim_create_user_command("CharlestonCompile", function()
  local opts = M.opts or M.defaults_opts
  local success, err = pcall(require("charleston.lib.compiler").compile, opts)
  if success then
    vim.notify("Charleston theme recompiled successfully", vim.log.levels.INFO, { title = "Charleston" })
    -- Reload the colorscheme
    vim.cmd("colorscheme charleston")
  else
    vim.notify("Charleston compilation failed: " .. tostring(err), vim.log.levels.ERROR, { title = "Charleston" })
  end
end, {
  desc = "Recompile Charleston colorscheme cache",
})

return M
