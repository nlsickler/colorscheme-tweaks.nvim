if !has('nvim-0.5.0')
  echoerr
  finish
end

"Define the command
command! -nargs=* EnhanceContrast lua require('contrast-enhancer.plugin').parseCommand(<line1>)
