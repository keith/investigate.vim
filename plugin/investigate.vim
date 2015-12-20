" Vim Plugin for viewing documentation
" Maintainer: Keith Smiley <keithbsmiley@gmail.com>
" Last Change: 2014 Apr
" Version: 1.1.4
" License: MIT, See LICENSE for text

if exists("g:investigate_plugin_loaded")
  finish
endif
let g:investigate_plugin_loaded = 1

if !exists("g:investigate_local_filename")
  let g:investigate_local_filename=".invrc"
endif

if filereadable(g:investigate_local_filename)
  execute 'call investigate#defaults#LoadFolderSpecificSettings()'
endif

if !hasmapto("investigate#Investigate()") && empty(mapcheck("gK", "n"))
  nnoremap gK :call investigate#Investigate('n')<CR>
  vnoremap gK :call investigate#Investigate('v')<CR>
endif
