" autoload/investigate.vim
" Plugin and variable setup ------ {{{
if exists("g:investigate_auto_loaded")
  finish
endif
let g:investigate_auto_loaded = 1

if !exists("g:investigate_use_dash")
  let g:investigate_use_dash = 0
endif
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
      return ""
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
    return "explorer "
  endif

  return ""
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
function! s:BuildCommand(filetype, word)
  let l:searchString = investigate#defaults#SearchStringForFiletype(a:filetype, s:UseDash())
  if empty(l:searchString) | return "" | endif

  let l:fullstring = substitute(l:searchString, '\M\^s', a:word, "g")
  let l:fullstring = substitute(l:fullstring, '\M\^x', investigate#escape#EscapeString(a:word), "g")
  let l:prg = s:Executable()
  let l:empty = 0
  if empty(l:prg)
    let l:empty = 1
  endif

  let l:command = l:prg . l:fullstring

  if l:fullstring =~ '\M\^e'
    let l:command = substitute(l:fullstring, '\M\^e', l:prg, "g")
  elseif strpart(l:fullstring, 0, 2) ==? '^i'
    let l:command = substitute(l:fullstring, '\M\^i', "", "g")
    let l:empty = 0
  endif

  if l:empty
    throw "Executable"
  endif
  return l:command
endfunction
" }}}

" The actual open command for mapping ------ {{{
function! investigate#Investigate()
  let l:filetype = &filetype
  if empty(l:filetype)
    echomsg "You must set your filetype to look up documentation"
    return
  endif

  let l:word = expand("<cword>")
  if empty(l:word)
    echomsg "Put your cursor over a word to look up it's documentation"
    return
  endif

  let l:filetype = substitute(l:filetype, '\M.', '', 'g')
  try
    let l:command = s:BuildCommand(l:filetype, l:word)
  catch /^Executable$/
    echomsg "No executable found for opening URLs"
    return
  endtry

  if empty(l:command)
    echomsg "No documentation for " . l:filetype
    return
  endif

  let l:prg = s:Executable()
  if !empty(l:prg) && l:command =~ l:prg
    call system(l:command)
  else
    try
      silent execute l:command
      redraw!
    catch /^Vim\%((\a\+)\)\=:E149/
      echo v:exception
    endtry
  endif
endfunction
" }}}
