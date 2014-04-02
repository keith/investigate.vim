" Plugin and variable setup ------ {{{
if exists("g:investigate_loaded_defaults")
  finish
endif
let g:investigate_loaded_defaults = 1

let s:dashString    = 0
let s:searchURL     = 1
let s:customCommand = 2
" }}}

" Default language settings ------ {{{
let s:defaultLocations = {
  \ "android": ["android", "https://developer.android.com/reference/packages.html#q=^s"],
  \ "c": ["c", "http://en.cppreference.com/mwiki/index.php?search=^s"],
  \ "clojure": ["clojure", "http://clojuredocs.org/search?q=^s"],
  \ "coffee": ["coffee", "https://encrypted.google.com/search?q=^s&sitesearch=coffeescriptcookbook.com/chapters/syntax/"],
  \ "cpp": ["cpp", "http://en.cppreference.com/mwiki/index.php?search=^s"],
  \ "cs": ["net", "http://social.msdn.microsoft.com/Search/en-US?query=^s#refinementChanges=117"],
  \ "css": ["css", "https://developer.mozilla.org/en-US/search?q=^s&topic=css"],
  \ "django": ["django", "https://docs.djangoproject.com/search/?q=^s"],
  \ "go": ["go", "http://golang.org/search?q=^s"],
  \ "haskell": ["haskell", "http://www.haskell.org/hoogle/?hoogle=^s"],
  \ "html": ["html", "https://developer.mozilla.org/en-US/search?q=^s&topic=html"],
  \ "java": ["java6", "http://javadocs.org/^s"],
  \ "javascript": ["javascript", "https://developer.mozilla.org/en-US/search?q=^s&topic=api&topic=js"],
  \ "liquid": ["", "http://rubydoc.info/search/gems/liquid?q=^s"],
  \ "lua": ["lua", "https://encrypted.google.com/search?q=^s&sitesearch=lua.org/pil/"],
  \ "objc": ["iphoneos", "https://developer.apple.com/search/index.php?q=^s"],
  \ "perl": ["perl", "http://perldoc.perl.org/search.html?q=^s"],
  \ "php": ["php", "http://us3.php.net/results.php?q=^s"],
  \ "prolog": ["", "http://www.swi-prolog.org/pldoc/search?for=^s"],
  \ "puppet": ["puppet", "https://encrypted.google.com/search?q=^s&sitesearch=http://docs.puppetlabs.com/references/latest/"],
  \ "python": ["python", "http://docs.python.org/2/search.html?q=^s"],
  \ "rails": ["rails", "http://api.rubyonrails.org/?q=^s"],
  \ "ruby": ["ruby", "http://www.omniref.com/?q=^s"],
  \ "scala": ["scala", "http://scalex.org/?q=^s"],
  \ "sh": ["bash", "https://encrypted.google.com/search?q=^s&sitesearch=ss64.com"],
  \ "vim": ["vim", "http://vim.wikia.com/wiki/Special:Search?search=^s", "^i:h ^s"],
  \ "xul": ["xul", "https://developer.mozilla.org/en-US/search?q=^s&topic=xul"]
\ }

let s:syntaxAliases = {
  \ "bash": "sh",
  \ "help": "vim",
  \ "less": "css",
  \ "pythondjango": "django",
  \ "sass": "css",
  \ "scss": "css",
  \ "scsscss": "css",
  \ "specta": "objc",
  \ "zsh": "sh"
\ }
" }}}

" Check to make sure the language is supported ------ {{{
"   if not echo an error message
function! s:HasKeyForFiletype(filetype)
  return has_key(s:defaultLocations, a:filetype)
endfunction
" }}}

" Custom local file reading ------ {{{
function! investigate#defaults#LoadFolderSpecificSettings()
  " Only load the file once
  if exists("g:investigate_loaded_local")
    return
  endif
  let g:investigate_loaded_local = 1

  " Get the local file path and make sure it exists
  let l:filename = getcwd() . "/" . g:investigate_local_filename
  if empty(glob(l:filename)) | return | endif

  let l:contents = s:ReadAndCleanFile(l:filename)
  let l:commands = s:ParseRCFileContents(l:contents)
  for l:command in l:commands
    exec l:command
  endfor
endfunction

" Return a list of commands parsed and formatted correctly
function! s:ParseRCFileContents(contents)
  let l:commands = []
  let l:identifier = ""
  for l:line in a:contents
    " Ignore lines starting with # for comments
    if match(l:line, "^\\s*#") >= 0
      continue
    endif

    " Attempt to get the identifier string from the line
    let l:identifierString = s:IdentifierFromString(l:line)

    " If the string isn't an identifier
    if empty(l:identifierString)
      " Get the end of the command string
      let l:command = s:MatchForString(l:line)
      if empty(l:command)
        " Print an error if the syntax is invalid
        echomsg "Invalid syntax: '" . l:line . "'"
      elseif empty(l:identifier)
        " Print an error if no identifier has come before this line
        echomsg "No previous identifier: " . l:line
      else
        " Build the entire command
        let l:fullCommand = "let g:investigate_" . l:identifier . "_for_" . l:command
        call add(l:commands, l:fullCommand)
      endif
    else
      let l:identifier = l:identifierString
    endif
  endfor

  return l:commands
endfunction

" Read the given filepath line by line
" Trim all whitespace and ignore blank lines
" Returns a list of the remaining lines
" [dash]\n\nruby=rails -> ['[dash]', 'ruby=rails']
function! s:ReadAndCleanFile(filepath)
  let l:final = []
  let l:contents = readfile(a:filepath)
  for l:line in l:contents
    let l:trimmed = substitute(l:line, "^\\s*", "", "g")
    let l:trimmed = substitute(l:trimmed, "\\s*$", "", "g")
    if !empty(l:trimmed) | call add(l:final, l:trimmed) | endif
  endfor

  return l:final
endfunction


" Return the end of the identifier string
" ruby = rails -> ruby='rails'
" ruby = rails = cpp -> ""
" ruby -> ""
function! s:MatchForString(string)
  " Return an empty string unless there is at least 1 equals sign
  if match(a:string, '=') < 1 | return "" | endif

  " String the spaces from around the first equals sign
  let l:trim  = substitute(a:string, '\M\s\*=\s\*', '=', '')
  let l:idx   = match(l:trim, '=')

  let l:left  = strpart(l:trim, 0, l:idx)
  let l:right = strpart(l:trim, l:idx + 1)
  " Remove all trailing and leading quote marks
  let l:right = substitute(l:right, "\\v^['\"]*", '', 'g')
  let l:right = substitute(l:right, "\\v['\"]*$", '', 'g')
  return l:left . "='" . l:right . "'"
endfunction

" Get the function identifier for the passed string
" [dash] -> dash
" dash -> ""
function! s:IdentifierFromString(string)
  if strpart(a:string, 0, 1) ==# "[" && strpart(a:string, len(a:string) - 1, 1) ==# "]"
    return strpart(a:string, 1, len(a:string) - 2)
  endif

  return ""
endfunction
" }}}

" Choose file command based on custom, dash or URL ------ {{{
function! investigate#defaults#SearchStringForFiletype(filetype, forDash)
  " Second call is ok since it won't finish if it's already been loaded
  call investigate#defaults#LoadFolderSpecificSettings()
  call s:LoadSyntaxAliasSettings()

  " Has syntax for foo, get string for foo, another function
  let l:type = a:filetype
  let l:syntax = s:SyntaxStringForFiletype(a:filetype)
  if !empty(l:syntax) | let l:type = l:syntax | endif

  return s:SearchStringForSyntax(l:type, a:forDash)
endfunction

function! s:SearchStringForSyntax(syntax, forDash)
  let l:command = s:UserOverrideForSyntax(a:syntax, a:forDash)
  if !empty(l:command) | return l:command | endif

  if s:HasCustomCommandForFiletype(a:syntax)
    let l:command = s:CustomCommandForFiletype(a:syntax)
  endif

  if empty(l:command) && a:forDash
    let l:command = s:DashStringForFiletype(a:syntax)
  endif

  if empty(l:command)
    let l:command = s:URLForFiletype(a:syntax)
  endif

  return l:command
endfunction
" }}}

" Custom syntax aliases code ------ {{{
" Load all the keys and values from the aliases array
" if and only if they have absolutely no mappings already
" defined anywhere
function! s:LoadSyntaxAliasSettings()
  for [l:ft, l:alias] in items(s:syntaxAliases)
    if !s:HasMappingForFiletype(l:ft)
      let l:syntaxkey = s:CustomSyntaxStringForFiletype(l:ft)
      let l:command = "let " . l:syntaxkey . "='" . l:alias . "'"
      execute l:command
    endif
  endfor
endfunction

" Check to see if a filetype has a mapping defined anywhere at all
function! s:HasMappingForFiletype(filetype)
  if exists(s:CustomSyntaxStringForFiletype(a:filetype))
    return 1
  elseif exists(s:CustomCommandStringForFiletype(a:filetype))
    return 1
  elseif exists(s:CustomDashStringForFiletype(a:filetype))
    return 1
  elseif exists(s:CustomURLStringForFiletype(a:filetype))
    return 1
  elseif has_key(s:defaultLocations, a:filetype)
    return 1
  endif

  return 0
endfunction
" }}}

" Command hierarchy for user defined commands and overrides ------ {{{
function! s:UserOverrideForSyntax(syntax, forDash)
  let l:command = ""
  if s:UseCustomCommandForFiletype(a:syntax)
    let l:command = s:CustomCommandForFiletype(a:syntax)
  elseif has("mac") && s:UseDashForFiletype(a:syntax)
    let l:command = s:DashStringForFiletype(a:syntax)
  elseif s:UseURLForFiletype(a:syntax)
    let l:command = s:URLForFiletype(a:syntax)
  endif

  if empty(l:command)
    if exists(s:CustomCommandStringForFiletype(a:syntax))
      let l:command = s:CustomCommandForFiletype(a:syntax)
    elseif exists(s:CustomDashStringForFiletype(a:syntax))
      let l:command = s:DashStringForFiletype(a:syntax)
    elseif exists(s:CustomURLStringForFiletype(a:syntax))
      let l:command = s:URLForFiletype(a:syntax)
    endif
  endif

  return l:command
endfunction
" }}}

" Syntax replacement configuration ------ {{{
function! s:CustomSyntaxStringForFiletype(filetype)
  return "g:investigate_syntax_for_" . a:filetype
endfunction

function! s:SyntaxStringForFiletype(filetype)
  let l:string = ""
  if exists(s:CustomSyntaxStringForFiletype(a:filetype))
    let l:string = eval(s:CustomSyntaxStringForFiletype(a:filetype))
  endif

  return l:string
endfunction
" }}}

" Check for custom commands specific to the language ------ {{{
function! s:CustomCommandStringForFiletype(filetype)
  return "g:investigate_command_for_" . a:filetype
endfunction

function! s:HasCustomCommandForFiletype(filetype)
  if (has_key(s:defaultLocations, a:filetype) && len(s:defaultLocations[a:filetype]) > 2) || exists(s:CustomCommandStringForFiletype(a:filetype))
    return 1
  endif

  return 0
endfunction

function! s:CustomCommandForFiletype(filetype)
  if exists(s:CustomCommandStringForFiletype(a:filetype))
    return eval(s:CustomCommandStringForFiletype(a:filetype))
  elseif s:HasKeyForFiletype(a:filetype)
    return s:defaultLocations[a:filetype][s:customCommand]
  endif

  return ""
endfunction

function! s:UseCustomCommandStringForFiletype(filetype)
  return "g:investigate_use_command_for_" . a:filetype
endfunction

function! s:UseCustomCommandForFiletype(filetype)
  if exists(s:UseCustomCommandStringForFiletype(a:filetype))
    return eval(s:UseCustomCommandStringForFiletype(a:filetype))
  endif

  return 0
endfunction
" }}}

" Dash configuration ------ {{{
function! s:CustomDashStringForFiletype(filetype)
  return "g:investigate_dash_for_" . a:filetype
endfunction

function! s:DashStringForFiletype(filetype)
  let l:string = ""
  if exists(s:CustomDashStringForFiletype(a:filetype))
    let l:string = eval(s:CustomDashStringForFiletype(a:filetype))
  elseif s:HasKeyForFiletype(a:filetype)
    let l:string = s:defaultLocations[a:filetype][s:dashString]
  endif

  if !empty(l:string)
    return investigate#dash#DashString(l:string)
  endif
  return l:string
endfunction

function! s:CustomUseDashStringForFiletype(filetype)
  return "g:investigate_use_dash_for_" . a:filetype
endfunction

function! s:UseDashForFiletype(filetype)
  if exists(s:CustomUseDashStringForFiletype(a:filetype))
    return eval(s:CustomUseDashStringForFiletype(a:filetype))
  endif

  return 0
endfunction
" }}}

" URL configuration ------ {{{
function! s:CustomURLStringForFiletype(filetype)
  return "g:investigate_url_for_" . a:filetype
endfunction

function! s:URLForFiletype(filetype)
  let l:url = ""
  if exists(s:CustomURLStringForFiletype(a:filetype))
    let l:url = eval(s:CustomURLStringForFiletype(a:filetype))
  elseif s:HasKeyForFiletype(a:filetype)
    let l:url = s:defaultLocations[a:filetype][s:searchURL]
  endif

  if !empty(l:url) | let l:url = "\"" . l:url . "\"" | endif

  return l:url
endfunction

function! s:CustomUseURLStringForFiletype(filetype)
  return "g:investigate_use_url_for_" . a:filetype
endfunction

function! s:UseURLForFiletype(filetype)
  if exists(s:CustomUseURLStringForFiletype(a:filetype))
    return eval(s:CustomUseURLStringForFiletype(a:filetype))
  endif

  return 0
endfunction
" }}}

