local fs = require("lfs")

local function filter(sequence, predicate)
  local newlist = {}
  for i, v in ipairs(sequence) do
    if predicate(v) then
      table.insert(newlist, v)
    end
  end
end

local filter_package = function(item)
  if item ~= "." and item ~= ".." then
    return true
  else
    return false
  end
end

local dir_path = "."
local sequence_example = { "apple", "banana", "apricot", "orange", ".." }
local contain_dir = filter(sequence_example, filter_package)
print(contain_dir)
