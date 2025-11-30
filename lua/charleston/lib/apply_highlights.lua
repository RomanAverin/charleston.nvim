local M = {}

--- Applies highlights in two passes to ensure links resolve correctly.
--- Since pairs() doesn't guarantee iteration order, we must apply all
--- non-link highlights first, then link highlights. This prevents links
--- from resolving to wrong groups when the target hasn't been defined yet.
---
--- @param highlights table Table of highlight groups
function M.apply(highlights)
  -- First pass: Apply all non-link highlights
  for group, hl in pairs(highlights) do
    hl = type(hl) == "string" and { link = hl } or hl
    if not hl.link then
      vim.api.nvim_set_hl(0, group, hl)
    end
  end

  -- Second pass: Apply all link highlights
  for group, hl in pairs(highlights) do
    hl = type(hl) == "string" and { link = hl } or hl
    if hl.link then
      vim.api.nvim_set_hl(0, group, hl)
    end
  end
end

return M
