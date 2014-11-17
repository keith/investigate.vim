# investigate.vim

A plugin for looking documentation on the word under the cursor.
You can choose to open it in a browser, with
[Dash](http://kapeli.com/dash) on OS X, or with an arbitrary
shell command.

## Example

![Web](http://keithbsmiley.github.io/investigate.vim/img/web.gif)

## Setup

By default investigate is mapped to `gK`. If you want to set up your
own mapping you should use something like this:

```
nnoremap <leader>K :call investigate#Investigate()<CR>
```

With this mapping, using <leader>K when your cursor is on a specific
word will open its documentation. The [help
file](https://github.com/Keithbsmiley/investigate.vim/blob/master/doc/investigate.txt)
has tons of documentation on configuration. Here are some of the
basic options.

## Configuration

### Dash

If you want to open everything in Dash you need to set:

```
let g:investigate_use_dash=1
```

This value is ignored unless you're on OS X. If you want to use Dash
conditionally based off the current filetype you can set something like:

```
let g:investigate_use_dash_for_ruby=1
```

If you want to use something else, like a URL for a single type you'd
want to use this which will override the global Dash setting:

```
let g:investigate_use_url_for_ruby=1
```

If you want to use a different keyword in Dash for a given language you
can set it by using:

```
let g:investigate_dash_for_ruby="rails"
```

This would set all Ruby files to open in the Rails documentation.
Note: If you're using a Dash 1.9.3 or newer you don't have to set this
for docsets that you have renamed.


### URLs

If you don't like the website I chose as the default for a filetype you
can redefine it with:

```
let g:investigate_url_for_ruby="http://ruby-doc.com/search.html?q=^s"
```

Where `^s` will be replaced with the word under the cursor for Ruby
files.


### Custom Commands

You can also open documentation with arbitrary shell commands. See
`investigate-writing-commands` in the documentation for more info.


### Project specific settings

You can setup project specific settings with an `.invrc` file from the
directory you launch Vim in. For example for a Rails project you may
want to set Ruby files to open Rails documentation for that single
project but not other Ruby gem based projects you're working on. To do
that the file would look something like this:

```
[syntax]
ruby=rails
```

This will set a syntax variable:

```
let g:investigate_syntax_for_ruby=rails
```

Which entirely changes Ruby files to open in the Rails documentation.
See `investigate-conf-file` for more information.


If you don't have a preferred installation method check out
[vim-plug](https://github.com/junegunn/vim-plug)


## Development

If you find any bugs, want any languages added, or want any default
language settings changed, please submit an
[issue](https://github.com/Keithbsmiley/investigate.vim/issues/new).

