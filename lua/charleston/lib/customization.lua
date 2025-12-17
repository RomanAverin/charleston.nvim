local M = {}

---Apply palette customizations from opts.palette_overrides
---@param base_palette table The base color palette
---@param opts table Options containing palette_overrides
---@return table The customized palette
function M.apply_palette_customizations(base_palette, opts)
  -- Create a deep copy to avoid mutating the base palette
  local palette = vim.deepcopy(base_palette)

  -- Apply palette_overrides if present
  if opts.palette_overrides and type(opts.palette_overrides) == "table" then
    palette = vim.tbl_deep_extend("force", palette, opts.palette_overrides)
  end

  return palette
end

return M
