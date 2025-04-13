local M = {}

-- hex to RGB
local function hexToRGB(hex)
  hex = hex:gsub("#", "")
  return tonumber(hex:sub(1, 2), 16), tonumber(hex:sub(3, 4), 16), tonumber(hex:sub(5, 6), 16)
end

-- RGB to hex
local function rgbToHex(r, g, b)
  return string.format("#%02X%02X%02X", r, g, b)
end

-- RGB to HSL
-- r, g, b should be in the range [0, 255]
-- Returns h, s, l where:
-- h is in [0, 360), s and l are in [0, 1]
local function rgbToHsl(r, g, b)
  r, g, b = r / 255, g / 255, b / 255
  local max = math.max(r, g, b)
  local min = math.min(r, g, b)
  local h, s, l

  l = (max + min) / 2

  if max == min then
    h, s = 0, 0
  else
    local d = max - min
    s = l > 0.5 and d / (2 - max - min) or d / (max + min)

    if max == r then
      h = (g - b) / d + (g < b and 6 or 0)
    elseif max == g then
      h = (b - r) / d + 2
    else
      h = (r - g) / d + 4
    end

    h = h / 6
  end

  return h, s, l
end

-- HSL to RGB
local function hslToRgb(h, s, l)
  local function hue2rgb(p, q, t)
    if t < 0 then
      t = t + 1
    end
    if t > 1 then
      t = t - 1
    end
    if t < 1 / 6 then
      return p + (q - p) * 6 * t
    end
    if t < 1 / 2 then
      return q
    end
    if t < 2 / 3 then
      return p + (q - p) * (2 / 3 - t) * 6
    end
    return p
  end

  local r, g, b

  if s == 0 then
    r, g, b = l, l, l
  else
    local q = l < 0.5 and l * (1 + s) or l + s - l * s
    local p = 2 * l - q
    r = hue2rgb(p, q, h + 1 / 3)
    g = hue2rgb(p, q, h)
    b = hue2rgb(p, q, h - 1 / 3)
  end

  return math.floor(r * 255 + 0.5), math.floor(g * 255 + 0.5), math.floor(b * 255 + 0.5)
end

-- adjust saturation
function M.changeSaturation(hexColor, saturationChange)
  if saturationChange < -10 or saturationChange > 10 then
    vim.notify_once("Saturation must be in the range of -10% to 10%", vim.log.levels.ERROR)
    saturationChange = 0
  end

  local r, g, b = hexToRGB(hexColor)
  local h, s, l = rgbToHsl(r, g, b)

  s = s + (saturationChange / 100)
  s = math.max(0, math.min(1, s))

  r, g, b = hslToRgb(h, s, l)
  return rgbToHex(r, g, b)
end

return M
