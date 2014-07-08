execute pathogen#infect()
set nocompatible              " reset to known config
filetype indent plugin on     " Determine indents from file types
syntax on                     "Enable syntax highlighting
set confirm                     " Prompt instead of failing commands that require save
set visualbell                  " Use visual bell instead of beep
set nostartofline               " Stop certain movements from going to first character (behaves like other editors)

" Search options
set hlsearch                  " Highlight searches
nnoremap <C-L> :nohl<CR><C-L> " Turn off search highlighting until next search
set incsearch " This performs the search on each key press incrementally
set ignorecase
set smartcase

set backspace=indent,eol,start " Allow backspace over autoindent, line breaks, and start of insert action

" Set the tab spacing and indents
set autoindent                  " Keep same indent as previous line
"set smartindent
set shiftwidth=2
set softtabstop=2
set expandtab
"set tabstop=2                   " Use for hard tabs

set textwidth=78
set sr fo=acw2roq

set number " This puts line numbers on the left
set ruler

set hidden " This allows CTRL-^ to switch buffers even with changes in the current one

" These make auto-complete work like it does in bash (only to the ambiguity)
set wildmenu
set wildmode=list:longest


set title
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

" This allows CTR-B to turn on/off word wrap in non-comments
imap <C-B> <C-O>:setl sr! fo<C-R>=strpart("-+",&sr,1)<CR>=t<CR>

let @z='%s/^\(\s\+\)\([^:]\+\):\s*\([^;]\+\);\s*$/\1\2: \3/g'

" Syntax highlight actionscript
au Bufread,BufNewFile *.as set filetype=actionscript

" Hack Vagrantfile and Berksfile as ruby until we have plugins
au Bufread,BufNewFile Vagrantfile set filetype=ruby
au Bufread,BufNewFile Berksfile set filetype=ruby

" Set *.ino (Arduino) to C
au Bufread,BufNewFile *.ino set filetype=c

" Map CTRL-r to replace selected text in visual mode
vnoremap <C-r> "hy:%s/<C-r>h//gc<left><left><left>

"This allows for change paste motion cp{motion}
" i.e. cpw to change the current word to what's in our buffer
nmap <silent> cp :set opfunc=ChangePaste<CR>g@
function! ChangePaste(type, ...)
  silent exe "normal! `[v`]\"_c"
  silent exe "normal! p"
endfunction

" Adjust vim-markdown settings
let g:vim_markdown_folding_disabled=1

" Adjust vim-go settings
let g:go_disable_autoinstall = 1
" TODO Why doesn't vim-go be opinionated about this?
au FileType go set tabstop=8 softtabstop=8 shiftwidth=8 noexpandtab

" Adjust starting fold level
set foldlevelstart=1 " just show class level, hide methods to start

" Highlight trailing whitespace, and remove automatically on save
" TODO Look for a plugin for this
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/
autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd InsertLeave * match ExtraWhitespace /\s\+$/
autocmd BufWinLeave * call clearmatches()
function! TrimWhiteSpace()
  %s/\s\+$//e
endfunction
autocmd BufWritePre * :call TrimWhiteSpace()
