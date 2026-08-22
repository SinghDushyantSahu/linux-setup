" --- General Settings ---
set nocompatible            " Use Vim defaults instead of old Vi
set number                  " Show line numbers
set relativenumber          " Show relative line numbers (great for jumping lines)
set mouse=a                 " Enable mouse support for scrolling/clicking
set cursorline              " Highlight the current line
set showmatch               " Highlight matching brackets (parenthesis, etc.)
set laststatus=2            " Permanent status bar
set clipboard=unnamedplus   " Copy/Paste to system clipboard
set scrolloff=8             " Keep 8 lines visible above/below cursor

" --- Tabs & Indentation ---
set expandtab               " Convert tabs to spaces
set shiftwidth=4            " 1 tab = 4 spaces
set softtabstop=4
set autoindent              " Copy indent from current line to next line
set wrap                    " Wrap text

" --- Syntax & Search ---
syntax on                   " Enable syntax highlighting
set hlsearch                " Highlight search results
set incsearch               " Search as you type
set ignorecase              " Ignore case when searching...
set smartcase               " ...unless you use a capital letter

" --- Theme & Colors ---
colorscheme slate         " A classic built-in theme

if $USER == 'root' || $SUDO_USER != ''
    " ROOT MODE: Red Theme
    highlight StatusLine   cterm=bold ctermbg=52  ctermfg=15  guibg=#3b0000 guifg=#ffffff
    highlight StatusLineNC cterm=none ctermbg=232 ctermfg=244 guibg=#080808 guifg=#808080
else
    " NON ROOT MODE: Blue Theme
    highlight StatusLine   cterm=bold ctermbg=17  ctermfg=15  guibg=#00003b guifg=#ffffff
    highlight StatusLineNC cterm=none ctermbg=232 ctermfg=244 guibg=#080808 guifg=#808080
endif

set statusline=
set statusline+=%#StatusLine#            " Use the colors we defined earlier
set statusline+=\ %f                     " Full Path to file
set statusline+=\ [%{toupper(mode())}]   " Current vim mode
set statusline+=\ %m                     " [+] Modified flag

set statusline+=%=                       " Switch to the right side

set statusline+=%y\                      " Filetype (e.g. [python])
set statusline+=[%p%%]\                  " Percentage through file
set statusline+=%l:%c\                   " Line:Column
set statusline+=\                        " Extra space at the end

" --- AutoCompletion ---
set completeopt=menuone,noselect,noinsert
set pumheight=5             " Small menu
set shortmess+=c            " Hide 'match x of y' messages
set complete=.,w,b,u        " Scan: current, windows, buffers

function! TryComplete()
    " Cheapest checks first
    if pumvisible()
        return
    endif
    " Check v:char is a keyword character directly
    if v:char !~ '\k'
        return
    endif
    " Only fetch the last 2 chars before cursor + v:char
    let l:col = col('.') - 2
    if l:col < 1
        return
    endif
    if getline('.')[ l:col-1 : l:col-1 ] =~ '\k'
        call feedkeys("\<C-n>", 'n')
    endif
endfunction

augroup AutoCompleteGroup
    autocmd!
    autocmd InsertCharPre * call TryComplete()
augroup END
