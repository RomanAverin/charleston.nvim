local M = {}

function M.compile(opts)
  local colors = require("charleston.colors")
  local highlights = require("charleston.highlights").get(colors.palette, opts)

  -- Generate Lua code as a function
  local lines = {
    "return function()",
    "  local h = vim.api.nvim_set_hl",
    "  -- First pass: non-link highlights",
  }

  -- First pass: non-link highlights
  for group, hl in pairs(highlights) do
    hl = type(hl) == "string" and { link = hl } or hl
    if not hl.link then
      table.insert(lines, string.format("  h(0, %q, %s)", group, vim.inspect(hl)))
    end
  end

  table.insert(lines, "  -- Second pass: link highlights")

  -- Second pass: link highlights
  for group, hl in pairs(highlights) do
    hl = type(hl) == "string" and { link = hl } or hl
    if hl.link then
      table.insert(lines, string.format("  h(0, %q, %s)", group, vim.inspect(hl)))
    end
  end

  table.insert(lines, "end")

  local code = table.concat(lines, "\n")

  -- Get compile path
  local path_sep = package.config:sub(1, 1)
  local compile_path = vim.fn.stdpath("cache") .. path_sep .. "charleston"

  -- Create directory if not exists
  if vim.fn.isdirectory(compile_path) == 0 then
    vim.fn.mkdir(compile_path, "p")
  end

  -- Compile the code string into a function
  local chunk, err = loadstring(code)
  if not chunk then
    error("Charleston compilation error: " .. tostring(err))
  end

  -- Execute to get the actual function
  local func = chunk()

  -- Dump the function to bytecode
  local bytecode = string.dump(func, true)

  -- Write compiled file
  local compiled_path = compile_path .. path_sep .. "compiled.lua"
  local file = io.open(compiled_path, "wb")
  if file then
    file:write(bytecode)
    file:close()
    return true
  else
    error("Charleston: Permission denied while writing compiled file to " .. compiled_path)
  end

  return false
end

return M
