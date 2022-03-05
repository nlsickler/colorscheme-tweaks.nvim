-- Most of this module is cobbled together from tokyonight's code base
local util = {}
local hsluv = require('contrast-enhancer.hsluv')

local hexChars = "0123456789abcdef"

util.bg = "#000000"
util.fg = "#ffffff"

local function hexToRgb(hex_str)
  local hex = "[abcdef0-9][abcdef0-9]"
  local pat = "^#(" .. hex .. ")(" .. hex .. ")(" .. hex .. ")$"
  hex_str = string.lower(hex_str)

  assert(string.find(hex_str, pat) ~= nil, "hex_to_rgb: invalid hex_str: " .. tostring(hex_str))

  local r, g, b = string.match(hex_str, pat)
  return { tonumber(r, 16), tonumber(g, 16), tonumber(b, 16) }
end

---@param fg string foreground color
---@param bg string background color
---@param alpha number number between 0 and 1. 0 results in bg, 1 results in fg
function util.blend(fg, bg, alpha)
  bg = hexToRgb(bg)
  fg = hexToRgb(fg)

  local blendChannel = function(i)
    local ret = (alpha * fg[i] + ((1 - alpha) * bg[i]))
    return math.floor(math.min(math.max(0, ret), 255) + 0.5)
  end

  return string.format("#%02X%02X%02X", blendChannel(1), blendChannel(2), blendChannel(3))
end


function util.darken(hex, amount, bg)
  return util.blend(hex, bg or util.bg, math.abs(amount))
end
function util.lighten(hex, amount, fg)
  return util.blend(hex, fg or util.fg, math.abs(amount))
end

function util.brighten(color, percentage)
  local hsl = hsluv.hex_to_hsluv(color)
  local larpSpace = 100 - hsl[3]
  if percentage < 0 then
    larpSpace = hsl[3]
  end
  hsl[3] = hsl[3] + larpSpace * percentage
  return hsluv.hsluv_to_hex(hsl)
end

-----------------------
-- My functions here
-----------------------

-- Determines if the color channel average is darker than half or brighter than half.
function util.isBrighterThanAverage(hex)
  local color = hexToRgb(hex)
  local colorAvg = (color[1] + color[2] + color[3])/3
  if colorAvg >= 128 then
    return true
  end
  return false
end

-- This shifts the given color lighter/darker, based on shouldBrighten.  This
-- usually increases contrast between the background and foreground.  Colors on
-- the same side of the middle closer will be together, but the overall effect is
-- a greater contrast.
function util.increaseContrast(hex, amount)
  if util.isBrighterThanAverage(hex) then
    return util.brighten(hex, amount)
  else
    return util.darken(hex, (1-amount))
  end
end

-- This shifts the given color lighter/darker, based on shouldBrighten.  This
-- usually decreases contrast between the background and foreground.  Colors on
-- the same side of the middle closer will be together, but the overall effect is
-- a greater contrast.
function util.decreaseContrast(hex, amount)
  if util.isBrighterThanAverage(hex) then
    return util.darken(hex, (1-amount))
  else
    return util.brighten(hex, amount)
  end
end

return util
