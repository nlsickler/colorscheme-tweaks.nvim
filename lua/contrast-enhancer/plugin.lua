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
  local highlightOutput = vim.api.nvim_exec([[highlight]], true)
  local highlights = stringSplit(highlightOutput, '\n')

  local commands = {}

  for _,row in pairs(highlights) do
    -- Sample Input: "SignColumn     xxx ctermfg=14 ctermbg=242 guifg=#292E44 guibg=#12131B"
    local currKey = nil
    local inputs = stringSplit(row)
    for idx, entry in ipairs(inputs) do
      if idx == 1 then
        currKey = entry
      elseif idx >= 3 and string.find(entry, 'gui') then
        local kvs = stringSplit(entry, '=') --guifg=#ffffff
        print('Parser key: '..currKey..' KVS: '..kvs[1]..' '..kvs[2])
        local highInput = {}
        highInput[kvs[1]] = kvs[2]
        local input = {}
        input[currKey] = highInput
        table.insert(commands, input)
      end
    end
  end

  return commands
end

M.increaseContrastBy = function(increaseFactor)
  local colors = getHighlightGroups()

  -- Loops to increase contrast of existing color schemes
  for _, val in pairs(colors) do
    if type(val) == 'table' then
      for key, nval in pairs(val) do
        print('KEY: '..key)
        for ctype, cval in pairs(nval) do
          if(increaseFactor == 0) then
            print('Increase factor of 0 means no change.  Specify the (0,1] percentage value to change the contrast of colors')
          elseif(increaseFactor > 0 and string.find(cval, '#')) then
            local newValue = util.increaseContrast(cval, increaseFactor)
            local command = 'highlight '..key..' '..ctype..'='..newValue
            print(command)
            vim.cmd(command)
          elseif(string.find(cval, '#')) then
            local newValue = util.decreaseContrast(cval, -1 * increaseFactor)
            local command = 'highlight '..key..' '..ctype..'='..newValue
            print(command)
            vim.cmd(command)
          end
        end
      end
    end
  end
end

M.parseCommand = function(args)
  return M.increaseContrastBy(args)
end

return M
