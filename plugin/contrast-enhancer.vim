if !has('nvim-0.5.0')
  echoerr
  finish
end

"Define the command
command! -nargs=* EnhanceContrast lua require('plugin').parseCommand(<line1>)
