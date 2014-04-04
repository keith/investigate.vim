" Percent escape function for investigate.vim
if exists("g:investigate_escape_loaded")
  finish
endif
let g:investigate_escape_loaded = 1

let s:escapes = {
  \ '!': '%21',
  \ '#': '%23',
  \ '$': '%24',
  \ '&': '%26',
  \ "'": '%27',
  \ '(': '%28',
  \ ')': '%29',
  \ '*': '%2A',
  \ '+': '%2B',
  \ ',': '%2C',
  \ '/': '%2F',
  \ ':': '%3A',
  \ ';': '%3B',
  \ '=': '%3D',
  \ '?': '%3F',
  \ '@': '%40',
  \ '[': '%5B',
  \ ']': '%5D'
 \ }

function! investigate#escape#EscapeString(string)
  let l:escaped = ""
  for char in split(a:string, '\zs')
    if has_key(s:escapes, char)
      let l:escaped .= s:escapes[char]
    else
      let l:escaped .= char
    endif
  endfor
  return l:escaped
endfunction
