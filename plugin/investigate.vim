" autoload/investigate.vim for more info
if exists("g:investigate_plugin_loaded")
  finish
endif
let g:investigate_plugin_loaded = 1

if !hasmapto("investigate#Investigate()")
  nnoremap gK :call investigate#Investigate()<CR>
endif

