" Vim Plugin for viewing documentation
" Maintainer: Keith Smiley <keithbsmiley@gmail.com>
" Last Change: 2013 Dec
" Version: 0.9.1
" License: MIT, See LICENSE for text

" Plugin and variable setup ------ {{{
if exists("g:investigate_plugin_loaded")
  finish
endif
let g:investigate_plugin_loaded = 1

if !exists("g:investigate_use_dash")
  let g:investigate_use_dash = 0
endif

runtime! plugin/investigate/*.vim
" }}}

" Return the executable tool for documentation opening ------ {{{
function! s:Executable()
  if has("mac")
    if executable("open")
      return "open "
    elseif executable("/usr/bin/open")
      " Return full path if Vim's path isn't setup correctly
      return "/usr/bin/open "
    else
      echomsg "Missing `open` command"
      finish
    endif
  elseif has("unix")
    if executable("xdg-open")
      return "xdg-open "
    elseif executable("gvfs-open")
      return "gvfs-open "
    elseif executable("gnome-open")
      return "gnome-open "
    endif
  elseif has("win32unix")
    return "cygstart "
  elseif has("win32")
    return "start "
  endif

  echomsg "No executable found for opening URLs"
  finish
endfunction
" }}}

" Determine whether documentation should open with dash ------ {{{
function! s:UseDash()
  if has("mac") && g:investigate_use_dash
    return 1
  endif

  return 0
endfunction
" }}}

" Setup the commanded based on some settings ------ {{{
"   swap occurances of ^s with the current word
"   swap out ^e with the executable
"   ^i at the beginning indicates leave the string as is
function! s:BuildCommand()
  let l:searchString = investigate#defaults#g:SearchStringForFiletype(&filetype, s:UseDash())
  if l:searchString == ""
    return ""
  endif

  let l:fullstring = substitute(l:searchString, "^s", expand("<cword>"), "g")
  let l:command = s:Executable() . l:fullstring

  if l:fullstring =~ "^e"
    let l:command = substitute(l:fullstring, "^e", s:Executable(), "g")
  elseif strpart(l:fullstring, 0, 2) == "^i"
    let l:command = substitute(l:fullstring, "^i", "", "g")
  endif
  return l:command
endfunction
" }}}

" The actual open command for mapping ------ {{{
function! investigate#Investigate()
  let l:command = s:BuildCommand()
  if l:command == ""
    return
  endif

  if l:command =~ s:Executable()
    execute system(l:command)
  else
    execute l:command
    redraw!
  endif
endfunction
" }}}

