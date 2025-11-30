local M = {}

-- Use bit operations compatible with Neovim
-- vim.bit is available since Neovim 0.10, fallback to LuaJIT's bit for older versions
local bit = vim.bit or bit

-- DJB2 hash algorithm for strings
local function hash_str(str)
  local hash = 5381
  for i = 1, #str do
    hash = bit.lshift(hash, 5) + hash + string.byte(str, i)
  end
  return hash
end

-- Recursive hash for configuration tables
function M.hash(v)
  local t = type(v)
  if t == "table" then
    local hash = 0
    for p, u in pairs(v) do
      hash = bit.bxor(hash, hash_str(tostring(p) .. M.hash(u)))
    end
    return hash
  elseif t == "function" then
    return "function"
  end
  return tostring(v)
end

return M
