if !has('nvim-0.5.0')
  echoerr
  finish
end

"Define the command
command! -nargs=* IncreaseContrast lua require('colorscheme-tweaks.plugin').increaseContrastBy(<args>)
command! -nargs=* DecreaseContrast lua require('colorscheme-tweask.plugin').decreaseContrastBy(<args>)
