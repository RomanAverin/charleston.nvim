local colors = require("charleston.colors")
local theme = require("charleston.theme")

local M = {}
M.version = "2.0.1"

M.defaults_opts = {
  terminal_colors = true,
  italic = true,
  darker_background = false,
  transparent = false,
  palette_overrides = {},
}

function M.setup(custom_opts)
  M.opts = vim.tbl_deep_extend("keep", custom_opts or {}, M.defaults_opts)

  -- Validate palette_overrides
  if M.opts.palette_overrides and type(M.opts.palette_overrides) ~= "table" then
    vim.notify("palette_overrides must be a table", vim.log.levels.WARN, { title = "Charleston" })
    M.opts.palette_overrides = {}
  end

  -- show debug information about custom_opts
  if custom_opts and custom_opts.debug then
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
  local hash = require("charleston.lib.hashing").hash({
    version = M.version,
    opts = M.opts,
  })

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

---Get the final color palette with customizations applied
---@return table The customized palette
function M.get_palette()
  local base_colors = require("charleston.colors")
  local customization = require("charleston.lib.customization")
  local opts = M.opts or M.defaults_opts
  return customization.apply_palette_customizations(base_colors.palette, opts)
end

-- User command for manual recompilation
vim.api.nvim_create_user_command("CharlestonCompile", function()
  -- Clear module cache to ensure fresh compilation
  package.loaded["charleston.colors"] = nil
  package.loaded["charleston.highlights"] = nil
  package.loaded["charleston.lib.compiler"] = nil
  package.loaded["charleston.lib.customization"] = nil

  local opts = M.opts or M.defaults_opts
  local success, err = pcall(require("charleston.lib.compiler").compile, opts)
  if success then
    -- Update the cached hash after successful compilation
    local hash = require("charleston.lib.hashing").hash({
      version = M.version,
      opts = M.opts,
    })
    local path_sep = package.config:sub(1, 1)
    local hash_path = vim.fn.stdpath("cache") .. path_sep .. "charleston" .. path_sep .. "cached_hash"
    local hash_file = io.open(hash_path, "w")
    if hash_file then
      hash_file:write(tostring(hash))
      hash_file:close()
    end

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
