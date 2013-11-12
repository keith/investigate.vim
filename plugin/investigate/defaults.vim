if exists("g:loaded_investigate_defaults")
  " finish
endif
let g:loaded_investigate_defaults = 1

let s:dashString = 0
let s:searchURL  = 1

let s:defaultLocations = {
  \ 'c': ['c:', 'abc'],
  \ 'vim': ['vim:', 'vimdoc']
\ }

function! s:HasKeyForFiletype(filetype)
  if has_key(s:defaultLocations, a:filetype)
    return 1
  else
    echomsg "No documentation for " . a:filetype
    return 0
  endif
endfunction

function! s:CustomDashStringForFiletype(filetype)
  return "g:dash_search_for_" . a:filetype
endfunction

function! s:CustomDashKeyForFiletype(filetype)
  return expand(g:dash_search_for_{a:filetype})
endfunction

function! g:DashStringForFiletype(filetype)
  if exists(s:CustomDashStringForFiletype(a:filetype))
    return s:CustomDashKeyForFiletype(a:filetype)
  elseif s:HasKeyForFiletype(a:filetype)
    return s:defaultLocations[a:filetype][s:dashString]
  endif
endfunction

