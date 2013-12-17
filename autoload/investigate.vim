" autoload/investigate.vim
" Plugin and variable setup ------ {{{
if exists("g:investigate_auto_loaded")
  finish
endif
let g:investigate_auto_loaded = 1

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
    return "start explorer "
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
function! s:BuildCommand(filetype, word)
  let l:searchString = investigate#defaults#SearchStringForFiletype(a:filetype, s:UseDash())
  if empty(l:searchString) | return "" | endif

  let l:fullstring = substitute(l:searchString, '\M\^s', a:word, "g")
  let l:command = s:Executable() . l:fullstring

  if l:fullstring =~ '\M\^e'
    let l:command = substitute(l:fullstring, '\M\^e', s:Executable(), "g")
  elseif strpart(l:fullstring, 0, 2) ==? '^i'
    let l:command = substitute(l:fullstring, '\M\^i', "", "g")
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
  let l:command = s:BuildCommand(l:filetype, l:word)
  if empty(l:command)
    echomsg "No documentation for " . l:filetype
    return
  endif

  if l:command =~ s:Executable()
    execute system(l:command)
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

