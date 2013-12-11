# investigate.vim

A plugin for looking documentation on the word under the cursor.
You can choose to open it in a browser with
[Dash](http://kapeli.com/dash) on OS X or with an arbitary
shell command.

## Setup

Example mapping:

```
nnoremap K :call investigate#Investigate()<cr>
```

With this mapping, using capital K when your cursor is on a specific
word will open its documentation. The [help
file](https://github.com/Keithbsmiley/investigate.vim/blob/master/doc/investigate.txt)
has tons of documentation on configuration. Here are some of the
basic options.

## Configuration

### Dash

If you're on OS X and want to open everything in Dash you need to set:

```
let g:investigate_use_dash=1
```

This value is ignored unless you're on OS X. If you want to use Dash
conditionally based off the current filetype you can set something like:

```
let g:investigate_use_dash_for_ruby=1
```

If you want to use something else, like a URL for a single type you'd
want to use this:

```
let g:investiate_use_url_for_ruby=1
```

Which will override the global Dash setting. If you want to override the
keyword for a filetype in Dash you can do it with:

```
let g:investigate_syntax_for_rspec=ruby
```

Which will open all files with the filetype rspec with `ruby:` in Dash.

### URLs

If you don't like the website I chose as the default for a filetype you
can redefine it with:

```
let g:investigate_url_for_ruby="http://ruby-doc.com/search.html?q=^s"
```

Where `^s` will be replaced with the word under the cursor for Ruby
files.

### Custom Commands




## Installation

### With [Vundle](https://github.com/gmarik/vundle)

Add:

```
Bundle 'Keithbsmiley/investigate.vim'
```

To your `.vimrc` and run `BundleInstall` from within vim or `vim +BundleInstall +qall` from the command line

### With [Pathogen](https://github.com/tpope/vim-pathogen)

```
cd ~/.vim/bundle
git clone https://github.com/Keithbsmiley/investigate.vim.git
```

## Development

I'd love any pull requests you can muster. Especially the addition of
language specific documentation URLs.

