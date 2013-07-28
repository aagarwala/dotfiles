" Nikita Kouevda
" 2013/07/27

" Avoid compatible mode if overriding default vimrc via -u
set nocompatible

" Syntax highlighting and colors
set t_Co=256
syntax enable
set background=dark
colorscheme wombat

" Save more history; do not use backups in temporary directories
set history=1000 undolevels=1000
set backupskip=/tmp/*,/private/tmp/*

" Time out immediately on key codes
set ttimeout ttimeoutlen=0

" Backspace always deletes
set backspace=indent,eol,start

" Auto completion and wildcard matching
set wildmode=longest:list
set completeopt+=longest
set pumheight=10
set suffixes+=.class,.git,.out,.pdf,.pyc

" Do not display the intro message; shorten all file messages
set shortmess+=Ia

" Show partial commands; always report the number of lines changed by a command
set showcmd
set report=0

" Show parts of wrapped lines that are cut off at the bottom
set display=lastline

" Do not jump to the first non-whitespace character
set nostartofline

" Do not insert 2 spaces between sentences when joining
set nojoinspaces

" Interact with the X clipboard if possible
if exists('+clipboard')
    set clipboard=unnamed
endif

" Toggle paste mode; automatically disable paste mode upon leaving insert mode
set pastetoggle=<F2>
autocmd InsertLeave * set nopaste

" Copy to the end of the line with Y, to match the behavior of C and D
nnoremap Y y$

" Prefer jumping directly to marks
noremap ' `
noremap ` '

" Write with sudo and reload the file
cnoremap w!! silent execute 'w !sudo tee % > /dev/null' \| edit!

" Use comma as leader but keep its functionality via backslash
let mapleader = ','
nnoremap \ ,

" Write to black hole register to avoid overwriting copied material
nnoremap <Leader>d "_
vnoremap <Leader>d "_

" Navigate buffers, tabs, and splits
nnoremap <Leader>j :bn<CR>
nnoremap <Leader>k :bp<CR>
nnoremap <Leader>l :tabn<CR>
nnoremap <Leader>h :tabp<CR>
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
nnoremap <C-h> <C-w>h

" Toggle line numbers and relative line numbers
nnoremap <Leader>n :set number!<CR>
nnoremap <Leader>N :set relativenumber!<CR>

" Show line numbers in as few columns as possible
set number
set numberwidth=1

" Show relative line numbers if possible, except in diff mode
if exists('+relativenumber')
    set relativenumber
    autocmd FilterWritePre * if &diff | setlocal norelativenumber | endif
endif

" Use absolute line numbers and do not override global wrap setting in diff mode
autocmd FilterWritePre * if &diff | setlocal number wrap< | endif

" Search as queries are typed and highlight matches; use intelligent case
set incsearch hlsearch
set ignorecase smartcase

" Temporarily disable search highlighting
nnoremap <Leader>/ :nohlsearch<CR>

" Clear the previous regular expression
nnoremap <Leader>? :let @/ = ''<CR>

" Match all characters past column 79 or 80
nnoremap <Leader>7 /\%>79v.\+<CR>
nnoremap <Leader>8 /\%>80v.\+<CR>

" Match or remove all trailing whitespace
nnoremap <Leader>w /\s\+$<CR>
nnoremap <Leader>W :%s/\s\+$//<CR>

" Set the number of spaces per tab in the current buffer only
function! Indentation(...)
    " Use the given width if it is positive, otherwise default to 4
    let l:width = (a:0 > 0 && a:1 > 0) ? a:1 : 4

    " Always treat tabs as l:width spaces wide
    let &l:tabstop = l:width
    let &l:softtabstop = l:width
    let &l:shiftwidth = l:width
endfunction

" Set the given number of spaces per tab without changing the tab type
command! -nargs=? Indentation call Indentation(<f-args>)
command! -nargs=? I Indentation <args>

" Set soft tabs with the given number of spaces per tab
command! -nargs=? Spaces call Indentation(<f-args>) | setlocal expandtab
command! -nargs=? S Spaces <args>

" Set hard tabs with the given number of spaces per tab
command! -nargs=? Tabs call Indentation(<f-args>) | setlocal noexpandtab
command! -nargs=? T Tabs <args>

" Use soft tabs with 4 spaces per tab by default
set tabstop=4 softtabstop=4 shiftwidth=4 expandtab

" Round to the nearest tab when indenting and copy indentation exactly
set shiftround
set autoindent copyindent

" Override default tab settings for certain filetypes
autocmd FileType css,html,htmldjango,javascript,xml Spaces 2
autocmd FileType gitconfig,make,sshconfig Tabs 4

" Match pairs of angle brackets XML-like formats
autocmd FileType html,htmldjango,markdown,xml setlocal matchpairs+=<:>

" Remain in visual mode after indenting
vnoremap < <gv
vnoremap > >gv
vnoremap = =gv

" Always show the status line
set laststatus=2

" File name, modified, read-only, help, preview, and file type, if any
set statusline=%f%m%r%h%w\ %y%{&ft!=''?'\ ':''}

" File format and file encoding, or encoding if no file encoding
set statusline+=[%{&ff},%{&fenc!=''?&fenc:&enc}]

" Switch to right alignment here; cut off parts of what follows if necessary
set statusline+=%=%<

" Character under cursor in ASCII and in hexadecimal
set statusline+=[\%03b,0x\%02B]

" Line/lines and column, including virtual column if applicable
set statusline+=\ [%l/%L,%c%V]

" Percent of file in terms of current line and section of file shown
set statusline+=\ [%p%%,%P]