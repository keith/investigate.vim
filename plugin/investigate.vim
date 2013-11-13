" Vim Plugin for viewing documentation
" Maintainer: Keith Smiley <keithbsmiley@gmail.com>
" Last Change: 2013 Nov 11
" Version: 0.1.0
" License: MIT, See LICENSE for text

" Plugin and variable setup ------ {{{
if exists('g:loaded_investigate_plugin')
  " finish
endif
let g:loaded_investigate_plugin = 1

if !exists("g:investigate_use_dash")
  let g:investigate_use_dash = 0
endif

source plugin/investigate/*.vim
" }}}

" Return the executable tool for documentation to open with ------ {{{
function! s:Executable()
  if has("mac")
    return "/usr/bin/open "
  elseif has("linux")
  endif

  echomsg "No executable found for opening URLs"
  unlet g:loaded_investigate_plugin
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

" Another string to be added after the executable before ------ {{{
"   the search string is appended
function! s:IntermediateCommand()
  if s:UseDash()
    return "dash://"
  endif

  return ""
endfunction
" }}}

" Setup the commanded based on some settings ------ {{{
"   swap occurances of %s with the current word
"   swap out %c or %e with the intermediate command
"   and the executable respectively
"   %i at the beginning indicates leave the string as it's given
function! s:BuildCommand()
  let l:searchString = g:SearchStringForFiletype(&filetype, s:UseDash())
  let l:fullString = substitute(l:searchString, "%s", expand("<cword>"), "")
  let l:command = s:Executable() . s:IntermediateCommand() . l:fullString

  if l:fullString =~ "%c" && l:fullString =~ "%e"
    let l:command = substitute(substitute(l:fullString, "%c", s:IntermediateCommand(), ""), "%e", s:Executable(), "")
  elseif l:fullString =~ "%c"
    let l:command = s:Executable() . substitute(l:fullString, "%c", s:IntermediateCommand(), "")
  elseif l:fullString =~ "%e"
    let l:command = substitute(l:fullString, "%e", s:Executable())
  elseif strpart(l:fullString, 0, 2) == "%i"
    let l:command = substitute(l:fullString, "%i", "", "")
  endif
  return l:command
endfunction
" }}}

" The actual open command for mapping ------ {{{
function! OpenHelp()
  let l:command = s:BuildCommand()
  if l:command =~ s:Executable()
    execute system(l:command)
  else
    execute l:command
    redraw!
  endif
endfunction
" }}}

map <S-k> :call OpenHelp()<cr>

