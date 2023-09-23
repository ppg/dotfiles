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
" ALE Status Line
" https://github.com/dense-analysis/ale#custom-statusline
function! ALEStatuslineHelper(type, colored) abort
  let l:counts = ale#statusline#Count(bufnr(''))
  if a:type == 'warnings'
    let l:count = l:counts.total - (l:counts.error + l:counts.style_error)
    let l:label = 'W'
  elseif a:type == 'errors'
    let l:count = l:counts.error + l:counts.style_error
    let l:label = 'E'
  endif
  "if (l:warnings == 0 && !a:colored) || (l:warnings != 0 && a:colored)
  if (!l:count && !a:colored) || (l:count && a:colored)
    return printf('%d%s', l:count, l:label)
  else
    return ''
  endif
endfunction
set statusline+=\ -\ [
set statusline+=%{ALEStatuslineHelper('warnings',0)}
set statusline+=%#ALEWarningSign#%{ALEStatuslineHelper('warnings',1)}%*
set statusline+=\ " space
set statusline+=%{ALEStatuslineHelper('errors',0)}
set statusline+=%#ALEWarningSign#%{ALEStatuslineHelper('errors',1)}%*
set statusline+=]
" END: ALE Status Line
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

" ALE
" https://github.com/dense-analysis/ale#how-can-i-disable-virtual-text-appearing-at-ends-of-lines
let g:ale_virtualtext_cursor = 'disabled'
" https://github.com/dense-analysis/ale#how-can-i-use-the-quickfix-list-instead-of-the-loclist
"let g:ale_set_loclist = 0
"let g:ale_set_quickfix = 1
" https://github.com/dense-analysis/ale#how-can-i-change-the-format-for-echo-messages
let g:ale_echo_msg_error_str = 'E'
let g:ale_echo_msg_warning_str = 'W'
let g:ale_echo_msg_format = '[%linter%] %s [%severity%] %[code]%'
let g:ale_linters = {
\   'proto': ['buf-lint'],
\   'go': ['gofmt', 'golangci-lint', 'gopls', 'govet'],
\}

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
let g:go_fmt_fail_silently = 1 " let ALE show compile errors instead of opening location list
" Go Linting
let g:ale_go_golangci_lint_package = 1
" disable --enable-all default to defer to local .golangci.yml file
let g:ale_go_golangci_lint_options = ''
" Go - ginkgo
autocmd BufNewFile,BufReadPost *_test.go set filetype=ginkgo.go

" JavaScript

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
"autocmd BufWritePre *.py silent! execute ':Black'
" autocmd BufWritePre *.py execute ':Isort'
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
let g:ale_sh_shellcheck_change_directory=0
let g:ale_sh_shellcheck_options='--external-sources'

" API Blueprint
" Fix ctrl-b to be back still
autocmd FileType apiblueprint nnoremap <C-b> <S-Up>

" Gherkin
au FileType cucumber setlocal textwidth=88

" Markdown (vim-polygot)
" TODO(ppg): re-flowing bullets doesn't work with auto-insert bullets;
" I keep auto-insert since auto-wrap works while typing, although when
" wrapped bullet insertion no longer works. Some issues:
"   https://github.com/preservim/vim-markdown/issues/232 - Rewrapping a bullet point inserts new bullet points
"   https://github.com/preservim/vim-markdown/issues/390 - gq wrapping is still broken
" This appears to have no effect for some reason to fix things?
"   au FileType markdown setlocal comments=fb:*,fb:+,fb:-,n:> indentexpr=
" Is there no solution that allows:
"
" 1. auto-insert new list items when hitting ENTER or O at the same indentation
" 2. auto-wrap on text entry; including when you hit ENTER for 1
" 3. allow reformatting of bullets that are too long without inserting new
"    bullets.
let g:vim_markdown_frontmatter = 1
" let g:vim_markdown_folding_disabled = 0
let g:vim_markdown_auto_insert_bullets = 1
let g:vim_markdown_new_list_item_indent = 2
au FileType markdown setlocal wrap linebreak textwidth=72 nolist autoindent

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
