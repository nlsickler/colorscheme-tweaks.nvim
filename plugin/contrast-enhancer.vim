if !has('nvim-0.5.0')
  echoerr
  finish
end

"Define the command
command! -nargs=* IncreaseContrast lua require('contrast-enhancer.plugin').increaseContrastBy(<args>)
command! -nargs=* DecreaseContrast lua require('contrast-enhancer.plugin').decreaseContrastBy(<args>)
