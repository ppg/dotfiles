set ignorecase
set smartcase
set autoindent "This makes the next line indent the same as the previous one
"set smartindent

set number " This puts line numbers on the left
set ruler

set hlsearch " This highlight regular expression searches
set incsearch " This performs the search on each key press incrementally

set hidden " This allows CTRL-^ to switch buffers even with changes in the current one

" These make auto-complete work like it does in bash (only to the ambiguity)
set wildmenu
set wildmode=list:longest


set title
set visualbell
set laststatus=2    " Show the status line all the time
" Useful status information at bottom of screen
set statusline=[%n]\                                    " Buffer number
set statusline+=%<%.99f\                                " File name (relative to current path)
set statusline+=%h%w%m%r%y                              " help, preview, modified, readonly, filetype
" Add in rvm ruby version
set statusline+=%{exists('g:loaded_rvm')?rvm#statusline():''}\ 
set statusline+=%=[\%03.3b\:\%02.2B]\ %-16(\ %l,%c\ %)  " byte value, byte value (hex), line number, column number
set statusline+=%L/%P                                   " total lines, percentage of file
"set statusline=[%n]\ %<%.99f\ %h%w%m%r%y\ %{fugitive#statusline()}%{exists('*CapsLockStatusline')?CapsLockStatusline():''}%=%-16(\ %l,%c-%v\ %)%P
"set statusline=%F%m%r%h%w\ [FORMAT=%{&ff}]\ [TYPE=%Y]\ [ASCII=\%03.3b]\ [HEX=\%02.2B]\ [POS=%04l,%04v][%p%%]\ [LEN=%L]

set tabstop=2
set shiftwidth=2
set expandtab

set textwidth=78
set sr fo=acw2roq 

" This allows CTR-B to turn on/off word wrap in non-comments
imap <C-B> <C-O>:setl sr! fo<C-R>=strpart("-+",&sr,1)<CR>=t<CR>

let @z='%s/^\(\s\+\)\([^:]\+\):\s*\([^;]\+\);\s*$/\1\2: \3/g'


" Syntax highlight actionscript
au Bufread,BufNewFile *.as set filetype=actionscript

" Map CTRL-r to replace selected text in visual mode
vnoremap <C-r> "hy:%s/<C-r>h//gc<left><left><left>
