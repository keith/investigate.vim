" Dash integration for investigate.vim
" Setup ------ {{{
if exists("g:investigate_loaded_dash")
  finish
endif
let g:investigate_loaded_dash = 1

" Default path for the lsregister command (for now)
let s:lsregister = '/System/Library/Frameworks/CoreServices.framework/Versions/A/Frameworks/LaunchServices.framework/Versions/A/Support/lsregister'
" }}}

" Get the correct string depending on Dash compatibility ------ {{{
function! investigate#dash#DashString(syntax)
  if exists('g:investigate_dash_format')
    return s:SyntaxString(eval('g:investigate_dash_format'), a:syntax)
  endif

  let l:format = s:DashFormat(s:lsregister)
  let g:investigate_dash_format = l:format
  return s:SyntaxString(l:format, a:syntax)
endfunction
" }}}

" Replace the identifier with the syntax if it exists ------ {{{
function! s:SyntaxString(string, syntax)
  return substitute(a:string, '\M\^f', a:syntax, 'g')
endfunction
" }}}

" Create the format string based on Dash versions ------ {{{
function! s:DashFormat(path)
  let l:format = "dash://^f:^s"
  if !executable(a:path)
    return l:format
  endif

  let l:command = s:LSRegisterCommand(a:path)
  let l:output = system(l:command)
  if s:HasDashPlugin(l:output)
    let l:format = "dash-plugin://keys=^f\\&query=^x"
  end

  return l:format
endfunction
" }}}

" Return true if the given text indicates the dash-plugin ------ {{{
"  url scheme is available
function! s:HasDashPlugin(text)
  if match(a:text, 'dash-plugin:') >= 0
    return 1
  endif

  return 0
endfunction
" }}}

" Get the command using lsregister to find Dash info ------ {{{
function! s:LSRegisterCommand(path)
  return a:path . ' -dump | grep "bindings:\s\+dash.*:"'
endfunction
" }}}

" vspec ------ {{{
function! investigate#dash#sid()
  return maparg('<SID>', 'n')
endfunction
nnoremap <SID> <SID>

function! investigate#dash#scope()
  return s:
endfunction
" }}}

