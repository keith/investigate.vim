" Vim Plugin for viewing documentation
" Maintainer: Keith Smiley <keithbsmiley@gmail.com>
" Last Change: 2013 Dec
" Version: 1.1.0
" License: MIT, See LICENSE for text

if exists("g:investigate_plugin_loaded")
  finish
endif
let g:investigate_plugin_loaded = 1

if !hasmapto("investigate#Investigate()") && empty(mapcheck("gK", "n"))
  nnoremap gK :call investigate#Investigate()<CR>
endif

