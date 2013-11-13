if exists("g:loaded_investigate_defaults")
  " finish
endif
let g:loaded_investigate_defaults = 1

let s:dashString    = 0
let s:searchURL     = 1
let s:customCommand = 2

let s:defaultLocations = {
  \ 'c': ['c:%s', 'http://en.cppreference.com/mwiki/index.php?search=%s'],
  \ 'vim': ['vim:%s', 'http://vim.wikia.com/wiki/Special:Search?search=%s', '%i:h %s']
\ }

function! s:HasKeyForFiletype(filetype)
  if has_key(s:defaultLocations, a:filetype)
    return 1
  else
    echomsg "No documentation for " . a:filetype
    return 0
  endif
endfunction

function! s:HasCustomCommandForFiletype(filetype)
  return len(s:defaultLocations[a:filetype]) > 2
endfunction

function! s:CustomCommandForFiletype(filetype)
  return s:defaultLocations[a:filetype][s:customCommand]
endfunction

function! g:SearchStringForFiletype(filetype, forDash)
  if s:HasCustomCommandForFiletype(a:filetype)
    return s:CustomCommandForFiletype(a:filetype)
  elseif a:forDash
    return s:DashStringForFiletype(a:filetype)
  else
    return '"' . s:URLForFiletype(a:filetype) . '"'
  endif
endfunction

function! s:CustomDashStringForFiletype(filetype)
  return "g:investigate_dash_for_" . a:filetype
endfunction

function! s:CustomDashKeyForFiletype(filetype)
  return expand(g:investigate_dash_for_{a:filetype})
endfunction

function! s:DashStringForFiletype(filetype)
  if exists(s:CustomDashStringForFiletype(a:filetype))
    return s:CustomDashKeyForFiletype(a:filetype)
  elseif s:HasKeyForFiletype(a:filetype)
    return s:defaultLocations[a:filetype][s:dashString]
  endif
endfunction

function! s:CustomURLStringForFiletype(filetype)
  return "g:investigate_url_for_" . a:filetype
endfunction

function! s:CustomURLKeyForFiletype(filetype)
  return expand(g:investigate_url_for_{a:filetype})
endfunction

function! s:URLForFiletype(filetype)
  if exists(s:CustomURLStringForFiletype(a:filetype))
    return s:CustomURLKeyForFiletype(a:filetype)
  elseif s:HasKeyForFiletype(a:filetype)
    return s:defaultLocations[a:filetype][s:searchURL]
  endif
endfunction

