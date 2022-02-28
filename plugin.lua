local util = require('plugin.util')

local M = {}

local function getHighlightGroups()
  -- Use ColorScheme after the colors are loaded to shift them?
  -- Use :highlight after the colors are loaded and shift them?
end


M.increaseContrastBy = function(increaseFactor)
  local colors = getHighlightGroups()

  -- Loops to increase contrast of existing color schemes
  for key, val in pairs(colors) do
    if type(val) == 'table' then
      for nkey, nval in pairs(val) do
        colors[key][nkey] = util.increaseContrast(nval, increaseFactor)
      end
    else
      colors[key] = util.increaseContrast(val, increaseFactor)
    end
  end

end

return M
