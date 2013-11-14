" Plugin and variable setup ------ {{{
if exists("g:loaded_investigate_defaults")
  finish
endif
let g:loaded_investigate_defaults = 1

let s:dashString    = 0
let s:searchURL     = 1
let s:customCommand = 2
" }}}

" Default language settings ------ {{{
let s:defaultLocations = {
  \ 'c': ['c:%s', 'http://en.cppreference.com/mwiki/index.php?search=%s'],
  \ 'cpp': ['cpp:%s', 'http://en.cppreference.com/mwiki/index.php?search=%s'],
  \ 'go': ['go:%s', 'http://golang.org/search?q=%s'],
  \ 'objc': ['macosx:%s', 'https://developer.apple.com/search/index.php?q=%s'],
  \ 'php': ['php:%s', 'http://us3.php.net/results.php?q=%s'],
  \ 'python':['python:%s', 'http://docs.python.org/2/search.html?q=%s'],
  \ 'ruby': ['ruby:%s', 'http://ruby-doc.com/search.html?q=%s'],
  \ 'vim': ['vim:%s', 'http://vim.wikia.com/wiki/Special:Search?search=%s', '%i:h %s']
\ }
" }}}

" Check to make sure the language is supported ------ {{{
"   if not echo an error message
function! s:HasKeyForFiletype(filetype)
  if has_key(s:defaultLocations, a:filetype)
    return 1
  else
    echomsg "No documentation for " . a:filetype
    return 0
  endif
endfunction
" }}}

" Check for custom commands specific to the language ------ {{{
function! s:CustomCommandVariableForFiletype(filetype)
  return "g:investigate_command_for_" . a:filetype
endfunction

function! s:CustomCommandVariableKeyForFiletype(filetype)
  return expand(g:investigate_command_for_{a:filetype})
endfunction

function! s:HasCustomCommandForFiletype(filetype)
  if len(s:defaultLocations[a:filetype]) > 2 || exists(s:CustomCommandVariableForFiletype(a:filetype))
    return 1
  endif

  return 0
endfunction

function! s:CustomCommandForFiletype(filetype)
  if exists(s:CustomCommandVariableForFiletype(a:filetype))
    return s:CustomCommandVariableKeyForFiletype(a:filetype)
  elseif s:HasKeyForFiletype(a:filetype)
    return s:defaultLocations[a:filetype][s:customCommand]
  endif
endfunction
" }}}

" Choose file command based on custom, dash or URL ------ {{{
function! g:SearchStringForFiletype(filetype, forDash)
  if s:HasCustomCommandForFiletype(a:filetype)
    return s:CustomCommandForFiletype(a:filetype)
  elseif a:forDash
    return s:DashStringForFiletype(a:filetype)
  else
    return '"' . s:URLForFiletype(a:filetype) . '"'
  endif
endfunction
" }}}

" Dash configuration ------ {{{
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
" }}}

" URL configuration ------ {{{
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
" }}}

