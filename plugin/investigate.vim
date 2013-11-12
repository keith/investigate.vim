" Vim Plugin for viewing documentation
" Maintainer: Keith Smiley <keithbsmiley@gmail.com>
" Last Change: 2013 Nov 11
" Version: 0.1.0
" License: MIT, See LICENSE for text

if exists('g:loaded_investigate_plugin')
  " finish
endif
let g:loaded_investigate_plugin = 1

source plugin/investigate/*.vim

function! s:Executable()
  if has("mac")
    return "/usr/bin/open"
  elseif has("linux")
  endif

  echomsg "No executable found for opening URLs"
endfunction

function! s:Command()
  if has("mac")
    return "dash://"
  endif

  return ""
endfunction

function! s:BuildCommand()
  return s:Executable() . " " . s:Command() . g:DashStringForFiletype(&filetype) . expand("<cword>")
endfunction

function! OpenHelp()
  execute system(s:BuildCommand())
  redraw!
endfunction

map <S-k> :call OpenHelp()<cr>

