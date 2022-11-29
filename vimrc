""
"" Basic Setup
""
"" See https://github.com/carlhuda/janus/blob/60e6864fbd60dc8efa9dc4c6de40b7615452814c/janus/vim/core/before/plugin/settings.vim
if has('vim_starting') && !has('nvim') && &compatible
  set nocompatible                " Be iMproved
endif
set number                        " Show line numbers
set ruler                         " Show line and column number
syntax enable                     " Turn on syntax highlighting allowing local overrides
set hidden                        " Allow switching buffers with unsaved changes in the current one
" Neovim disallow changing 'enconding' option after initialization
" see https://github.com/neovim/neovim/pull/2929 for more details
if !has('nvim')
  set encoding=utf-8              " Set default encoding to UTF-8
endif

""
"" Whitespace
""
set nowrap                        " don't wrap lines
set tabstop=2                     " a tab is two spaces
set shiftwidth=2                  " an autoindent (with <<) is two spaces
set expandtab                     " use spaces, not tabs
set list                          " Show invisible characters
set backspace=indent,eol,start    " backspace through everything in insert mode
if exists("g:enable_mvim_shift_arrow")
  let macvim_hig_shift_movement = 1 " mvim shift-arrow-keys
endif
" List chars
set listchars=""                  " Reset the listchars
set listchars=tab:\ \             " a tab should display as "  ", trailing whitespace as "."
set listchars+=trail:.            " show trailing spaces as dots
set listchars+=extends:>          " The character to show in the last column when wrap is
                                  " off and the line continues beyond the right of the screen
set listchars+=precedes:<         " The character to show in the last column when wrap is
"" https://github.com/ntpeters/vim-better-whitespace
let g:better_whitespace_enabled=1
let g:strip_whitespace_on_save=1
let g:strip_whitespace_confirm=0

""
"" Searching
""
set hlsearch    " highlight matches
set incsearch   " incremental searching
set ignorecase  " searches are case insensitive...
set smartcase   " ... unless they contain at least one capital letter


""
"" Wild settings
""
" These make auto-complete work like it does in bash (only to the ambiguity)
set wildmenu
set wildmode=list:longest
" Disable output and VCS files
set wildignore+=*.o,*.out,*.obj,.git,*.rbc,*.rbo,*.class,.svn,*.gem
" Disable archive files
set wildignore+=*.zip,*.tar.gz,*.tar.bz2,*.rar,*.tar.xz
" Ignore bundler and sass cache
set wildignore+=*/vendor/gems/*,*/vendor/cache/*,*/.bundle/*,*/.sass-cache/*
" Disable temp and backup files
set wildignore+=*.swp,*~,._*

""
"" Backup and swap files
""
set backupdir^=~/.vim/_backup//    " where to put backup files.
set directory^=~/.vim/_temp//      " where to put swap files.

""
"" Status line
""
" Useful status information at bottom of screen
set laststatus=2                                                    " always show the status bar
set statusline=[%n]\                                                " Buffer number
set statusline+=%<%.99f\                                            " File name (relative to current path)
set statusline+=%h%w%m%r%y                                          " help, preview, modified, readonly, filetype
set statusline+=\ -\ %{fugitive#statusline()}                       " Add in git information from fugitive
set statusline+=\ -\ %{exists('g:loaded_rvm')?rvm#statusline():''}  " Add in rvm ruby version
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}                        " Add in syntastic warnings
set statusline+=%*
set statusline+=%=[\%05b\:0x\%04B]\ %-16(\ %l,%c\ %)                " byte value, byte value (hex), line number, column number
set statusline+=%L/%P                                               " total lines, percentage of file

" Folding settings
set foldmethod=indent   " fold based on indent
set foldnestmax=5       " deepest fold levels
set foldenable          " fold by default
set foldlevel=3         " start on methods for normal class

" Solarized
" With black light (pallet color 8) set to #0387AD we need to set termtrans:
"   https://github.com/altercation/solarized/issues/220#issuecomment-269930034
let g:solarized_termtrans = 1
set background=dark
colorscheme solarized
" undercurl support
let &t_Cs = "\e[4:3m"
let &t_Ce = "\e[4:0m"
" vim-gitgutter color settings
" See https://github.com/airblade/vim-gitgutter/commit/8db2fc5da0d5ad02fa4fa38ae16dc2fad9bfd201
highlight! link SignColumn LineNr
highlight! link GitGutterAdd LineNr
highlight! link GitGutterChange LineNr
highlight! link GitGutterDelete LineNr
" highlight GitGutterAdd      guibg=#073642 ctermbg=0
" highlight GitGutterChange   guibg=#073642 ctermbg=0
" highlight GitGutterDelete   guibg=#073642 ctermbg=0
" highlight SignColumn        guibg=#073642 ctermbg=0

" Spell check
set spelllang=en
set spellfile=$HOME/.spell/en.utf-8.add
" TODO(ppg): how to get undercurl to be red?
highlight SpellBad gui=undercurl guisp=red term=undercurl cterm=undercurl
autocmd FileType cucumber setlocal spell
autocmd FileType gitcommit setlocal spell
autocmd FileType markdown setlocal spell
autocmd FileType text setlocal spell

" SYNTASTIC
let g:syntastic_aggregate_errors = 1
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_jump = 0
let g:syntastic_auto_loc_list = 0
" Leave disabled, see https://github.com/vim-syntastic/syntastic/issues/2238
"let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_mode_map = { 'mode': 'active' } ", 'passive_filetypes': ['go'] }
" Potentially enable to make vim saving go faster, but might skip go checking
" unless forced
"let g:syntastic_mode_map = { 'mode': 'active', 'passive_filetypes': ['go'] }
" DEBUG
"let g:syntastic_debug=1
"let g:syntastic_debug=3
"let g:syntastic_debug=33

" Ruby
let g:syntastic_ruby_checkers = ['mri', 'rubocop']
let g:syntastic_ruby_rubocop_args = '--display-cop-names --display-style-guide'
" Stop printing out warnings for <%= some_var_here %>
let g:syntastic_eruby_ruby_quiet_messages = { 'regex': 'possibly useless use of a variable in void context' }

" Go
" Turn on gopls
let g:go_gopls_options = ['-remote=auto']
" Enable for debug
"let g:go_gopls_options = ['-remote=auto', '-logfile=auto', '-debug=:0', '-remote.debug=:0', '-rpc.trace']
let g:go_def_mode = 'gopls'
let g:go_info_mode = 'gopls'
set updatetime=100
"let g:go_auto_type_info = 1 " shows type info at bottom when on something
let g:go_auto_sameids = 1 " highlights the same variables when cursor is there
" Support :A
" https://github.com/fatih/vim-go/wiki/Tutorial#vimrc-improvements-5
autocmd Filetype go command! -bang A call go#alternate#Switch(<bang>0, 'edit')
autocmd Filetype go command! -bang AV call go#alternate#Switch(<bang>0, 'vsplit')
autocmd Filetype go command! -bang AS call go#alternate#Switch(<bang>0, 'split')
autocmd Filetype go command! -bang AT call go#alternate#Switch(<bang>0, 'tabe')
" https://github.com/fatih/vim-go/wiki/Tutorial#identifier-resolution
" autocmd FileType go nmap <Leader>i <Plug>(go-info)
let g:go_build_tags = "acceptance benchmark functional integration client_test"
let g:go_fmt_fail_silently = 1 " let syntastic show compile errors instead of opening location list
" Go Syntastic
" TODO(ppg): disable golint when
" https://github.com/golangci/golangci-lint/issues/928 is fully fixed
let g:syntastic_go_checkers = ['go', 'gofmt', 'golint', 'golangci_lint']
let g:syntastic_go_go_test_args = "-tags 'acceptance benchmark functional integration client_test'"
let g:syntastic_go_go_build_args = "-tags 'acceptance benchmark functional integration client_test'"
" TODO(ppg): why can't I get govet with the makeprgBuild to work?
"let g:syntastic_go_govet_exe = "go tool vet"
" < go1.12
"let g:syntastic_go_govet_args = "-all -shadow -tags 'acceptance benchmark functional integration devci'"
"let g:syntastic_go_govet_args = "-vettool=$(which shadow) -tags 'benchmark functional integration devci'"
" When entering a golangci_lint set the fname to the current directory so it compiles
"   see https://vim.fandom.com/wiki/Set_working_directory_to_the_current_file
autocmd BufEnter *.go silent! let g:syntastic_go_golangci_lint_fname = shellescape(expand("%:p:h", 1))
let g:syntastic_go_golangci_lint_args = "--build-tags 'acceptance benchmark functional integration devci client_test'"
"let g:syntastic_go_golangci_lint_defaults = {'type': 'w'}
let g:syntastic_go_golangci_lint_type = 'w'
" Go - ginkgo
autocmd BufNewFile,BufReadPost *_test.go set filetype=ginkgo.go

" JavaScript
"let g:syntastic_javascript_checkers = ['jshint', 'eslint']
let g:syntastic_javascript_checkers = ['eslint']
let g:syntastic_javascript_eslint_exe = 'npx eslint'
" TODO(ppg): don't use ctrl-f, use for forward by page
"autocmd FileType javascript vnoremap <buffer> <c-f> :call RangeJsBeautify()<cr>
"autocmd FileType json vnoremap <buffer> <c-f> :call RangeJsonBeautify()<cr>
"autocmd FileType jsx vnoremap <buffer> <c-f> :call RangeJsxBeautify()<cr>
"autocmd FileType html vnoremap <buffer> <c-f> :call RangeHtmlBeautify()<cr>
"autocmd FileType css vnoremap <buffer> <c-f> :call RangeCSSBeautify()<cr>

" Python
let g:black_quiet = 1
"let g:syntastic_python_python_exec = 'python'
"let g:syntastic_python_flake8_exec = 'python'
"let g:syntastic_python_flake8_args = ['-m', 'flake8']
let g:syntastic_python_checkers = ['python', 'flake8', 'pylint', 'mypy']
"let g:vim_isort_python_version = 'python'
autocmd BufRead,BufNewFile *.py set textwidth=88
" waiting on https://github.com/psf/black/pull/1733 to be released
" workaround: https://github.com/psf/black/issues/252
autocmd BufWritePre *.py silent! execute ':Black'
autocmd BufWritePre *.py execute ':Isort'
"" TODO(ppg): try to get this working
"" Enable python-language-server
"if executable('pyls')
"# Set these to default enum value
"  au User lsp_setup call lsp#register_server({
"    \ 'name': 'pyls',
"    \ 'cmd': {server_info->['pyls']},
"    \ 'whitelist': ['python'],
"    \ 'workspace_config': {'pyls': {'plugins': {'black': {'enabled': v:true}}}}
"    \ })
"endif
" Set *.jinja to be jinja2
au BufRead,BufNewFile *.jinja set filetype=jinja2

"" Shell
let g:syntastic_sh_shellcheck_args = "--external-sources"
let g:syntastic_sh_checkers = ['sh', 'shellcheck']

" API Blueprint
" Fix ctrl-b to be back still
autocmd FileType apiblueprint nnoremap <C-b> <S-Up>

" Gherkin
au FileType cucumber setlocal textwidth=88

" Markdown
" Change to autoindent
au FileType markdown set autoindent

" Override filetypes
au BufRead,BufNewFile Dockerfile.* set filetype=dockerfile
au BufRead,BufNewFile .eslintrc set filetype=json

" Override *.ino to be Arduino files
au BufRead,BufNewFile *.ino set filetype=cpp

" Nginx
au BufRead,BufNewFile */nginx/conf.d/* set ft=nginx

" map for cnext and cprevious
nnoremap <silent> <leader>] :lnext<CR>
nnoremap <silent> <leader>[ :lprevious<CR>

" Define common tabularizations
if exists(":Tabularize")
  nmap <Leader>a= :Tabularize /=<CR>
  vmap <Leader>a= :Tabularize /=<CR>
  nmap <Leader>a: :Tabularize /:\zs<CR>
  vmap <Leader>a: :Tabularize /:\zs<CR>
  nmap <Leader>a, :Tabularize /,\zs<CR>
  vmap <Leader>a, :Tabularize /,\zs<CR>
endif
" TODO Probably put these in after insert too like cucumber?

" Tabularize cucumber after insert
inoremap <silent> <Bar>   <Bar><Esc>:call <SID>align()<CR>a
function! s:align()
  let p = '^\s*|\s.*\s|\s*$'
  if exists(':Tabularize') && getline('.') =~# '^\s*|' && (getline(line('.')-1) =~# p || getline(line('.')+1) =~# p)
    let column = strlen(substitute(getline('.')[0:col('.')],'[^|]','','g'))
    let position = strlen(matchstr(getline('.')[0:col('.')],'.*|\s*\zs.*'))
    Tabularize/|/l1
    normal! 0
    call search(repeat('[^|]*|',column).'\s\{-\}'.repeat('.',position),'ce',line('.'))
  endif
endfunction

" vim-spec
map <Leader>rt :call  RunCurrentSpecFile()<CR>
map <Leader>rs :call  RunNearestSpec()<CR>
map <Leader>rl :call  RunLastSpec()<CR>
map <Leader>ra :call  RunAllSpecs()<CR>
