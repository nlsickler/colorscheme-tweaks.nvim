local util = require('contrast-enhancer.util')

local M = {}

-- Taken from: https://www.tutorialspoint.com/how-to-split-a-string-in-lua-programming
local function stringSplit(inputStr, seperator)
  if(seperator == nil) then
    seperator = '%s'
  end

  local t={}
  for str in string.gmatch(inputStr, "([^"..seperator.."]+)") do
    table.insert(t, str)
  end
  return t
end

-- Parse the output of :highlight to get all of the individual line items from a colorscheme
local function getHighlightGroups()
  


  local highlights = vim.api.nvim_exec([[highlight]], true)
  local commands = {}

  for row in highlights do
    -- Sample Input: "SignColumn     xxx ctermfg=14 ctermbg=242 guifg=#292E44 guibg=#12131B"
    local currKey = nil
    local inputs = stringSplit(row)
    for idx, entry in ipairs(inputs) do
      if idx == 0 then
        currKey = entry
      elseif idx >= 2 and entry.find('gui') > -1 then
        local kvs = stringSplit(entry, '=') --guifg=#ffffff
        table.insert(commands, { currKey, {kvs[0], kvs[1]}})
      end
    end
  end

  return commands
end

M.increaseContrastBy = function(increaseFactor)
  local colors = getHighlightGroups()

  -- Loops to increase contrast of existing color schemes
  for key, val in pairs(colors) do
    if type(val) == 'table' then
      for nkey, nval in pairs(val) do
        if(increaseFactor == 0) then
          print('Increase factor of 0 means no change.  Specify the (0,1] percentage value to change the contrast of colors')
        elseif(increaseFactor > 0) then
          local newValue = util.increaseContrast(nval, increaseFactor)
          vim.cmd('highlight '..key..' '..nkey..'='..newValue)
        else
          local newValue = util.decreaseContrast(nval, -1 * increaseFactor)
          vim.cmd('highlight '..key..' '..nkey..'='..newValue)
        end
      end
    end
  end
end

M.parseCommand = function(args)
  return M.increaseContrastBy(args)
end

return M
