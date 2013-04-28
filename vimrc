" References:
" * My old vim configuration
" * http://nvie.com/posts/how-i-boosted-my-vim/
" * http://stevelosh.com/blog/2010/09/coming-home-to-vim/

" General configuration
set nocompatible
set laststatus=2   " Always show the statusline
set encoding=utf-8 " Necessary to show Unicode glyphs
let mapleader=","
let g:mapleader = ","
set hidden
set nowrap        " don't wrap lines
set tabstop=2     " a tab is four spaces
set backspace=indent,eol,start
" allow backspacing over everything in insert mode
set number        " always show line numbers
set shiftwidth=2  " number of spaces to use for autoindenting
set shiftround    " use multiple of shiftwidth when indenting with '<' and '>'
set showmatch     " set show matching parenthesis
set ignorecase    " ignore case when searching
set smartcase     " ignore case if search pattern is all lowercase,
" case-sensitive otherwise
set autoindent             " automatic indent new lines
set smartindent            " be smart about it
set softtabstop=2          " yep, two
set shiftwidth=2           " ..
set expandtab              " expand tabs to spaces
set nosmarttab             " fuck tabs
set formatoptions+=n       " support for numbered/bullet lists
set textwidth=80           " wrap at 80 chars by default
set virtualedit=block      " allow virtual edit in visual block ..

set nohlsearch      " highlight search terms
set history=1000         " remember more commands and search history
set undolevels=1000      " use many muchos levels of undo
set wildignore=*.swp,*.bak,*.pyc,*.class
set title                " change the terminal's title
set visualbell           " don't beep
set noerrorbells         " don't beep
set nobackup
set noswapfile
set wildmenu " turn on wild menu
set wildmode=longest,list " filename completion
set ruler " Always show current positions along the bottom
set cmdheight=2 " the command bar is 2 high
set t_Co=256
set showmatch " show matching brackets
set mat=5 " how many tenths of a second to blink matching brackets for
set so=10 " Keep 10 lines (top/bottom) for scope
set wrap
set gdefault " global substitution by default
set formatoptions=qrn1
set mouse=a
if !has("mac")
  set clipboard=unnamed
endif
set iskeyword+=_

function! CurDir()
  let curdir = substitute(getcwd(), '/home/antonio/', "~/", "g")
  return curdir
endfunction

set statusline=\ %F%m%r%h\ %w\ \ CWD:\ %r%{CurDir()}%h\ \ \ Line:\ %l/%L:%c

function! TrimWhiteSpace()
  %s/\s*$//
  ''
endfunction

filetype plugin indent on

nmap <C-j> :bn <CR>
nmap <C-k> :bp <CR>
nmap <leader>w :w!<CR>
" Automatic sudo
cmap w!! w !sudo tee % >/dev/null
nnoremap j gj
nnoremap k gk
inoremap <F1> <ESC>
nnoremap <F1> <ESC>
vnoremap <F1> <ESC>

if has('autocmd')
  autocmd!
  autocmd bufwritepost vimrc source ~/.vimrc " autoreaload .vimrc
  autocmd filetype textile let g:TextileOS="Linux"
  autocmd filetype textile let g:TextileBrowser="/usr/bin/chromium"
  "autocmd FileWritePre * :call TrimWhiteSpace()
  "autocmd FileAppendPre * :call TrimWhiteSpace()
  "autocmd FilterWritePre * :call TrimWhiteSpace()
  "autocmd BufWritePre * :call TrimWhiteSpace()
  autocmd FileType ruby,eruby set omnifunc=rubycomplete#Complete
  "autocmd FileType ruby,eruby let g:rubycomplete_buffer_loading=1
  autocmd FileType ruby,eruby let g:rubycomplete_classes_in_global=1
  autocmd FileType ruby,eruby let g:rubycomplete_rails = 1
endif

" Color
if &t_Co >= 256 || has("gui_running")
  colorscheme mustang
endif

if &t_Co > 2 || has("gui_running")
  " switch syntax highlighting on, when the terminal has colors
  syntax on
endif

set pastetoggle=<F2>

" Pathogen allows to deploy plugins in ~/.vim/bundle
call pathogen#helptags()
call pathogen#incubate()

" Yankring
let g:yankring_history_file='.yankring'
let g:yankring_manual_clipboard_check=0
nmap <leader>p :YRShow <cr>

" NERDTree
function! OpenNERDTree()
  :TMiniBufExplorer
  :NERDTreeToggle
endfunction
nmap <leader>n :NERDTreeToggle <cr>

" CtrlP
let g:ctrlp_map = '<leader>.'
let g:ctrlp_working_path_mode = 2
let g:ctrlp_cmd = 'CtrlPMixed'
set wildignore+=*/tmp/*,*.so,*.swp,*.zip  " MacOSX/Linux
let g:ctrlp_custom_ignore = '\.git$\|\.hg$\|\.svn$'
let g:ctrlp_use_caching = 1
let g:ctrlp_clear_cache_on_exit = 0
let g:ctrlp_follow_symlinks = 1
let g:ctrlp_user_command = {
  \ 'types': {
  \ 1: ['.git', 'cd %s && git ls-files'],
  \ 2: ['.hg', 'hg --cwd %s locate -I .'],
  \ },
  \ 'fallback': 'find %s -type f'
  \ }
let g:ctrlp_open_multiple_files='1h'

" VimOrganizer
au! BufRead,BufWrite,BufWritePost,BufNewFile *.org
au BufEnter *.org            call org#SetOrgFileType()

" Coffeescript
autocmd BufEnter *.coffee set filetype=coffee
if executable('coffeetags')
  let g:tagbar_type_coffee = {
        \ 'ctagsbin' : 'coffeetags',
        \ 'ctagsargs' : '',
        \ 'kinds' : [
        \ 'f:functions',
        \ 'o:object',
        \ ],
        \ 'sro' : ".",
        \ 'kind2scope' : {
        \ 'f' : 'object',
        \ 'o' : 'object',
        \ }
        \ }
endif

" Tagbar and tags
set tags=tags;/
set tags+=gems.tags
set shell=bash
if has("mac")
  let g:tagbar_ctags_bin = '/usr/local/Cellar/ctags/5.8/bin/ctags'
endif

" Highlight trailing whitespaces
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/
autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd InsertLeave * match ExtraWhitespace /\s\+$/
autocmd BufWinLeave * call clearmatches()

" Ruby wizardry
" bind control-l to hashrocket
imap <C-l> =><Space>

" Toggle Words
nmap <C-t> :Switch<CR>
imap <C-t> <ESC>:Switch<CR>

" Make vim-autoclose work with vim-endwise
let g:AutoCloseExpandEnterOn = ""

function! HlSearch()
  let @/=""
  set hlsearch incsearch
  call feedkeys('/')
endfunction

function! BackHlSearch()
  let @/=""
  set hlsearch incsearch
  call feedkeys('?')
endfunction

map <space>:call HlSearch()<CR>
map <c-space>:call BackHlSearch()<CR>
nnoremap <CR> :nohlsearch<CR>/<BS>

function! RspecCmd()
  if findfile(".zeus.sock") == ".zeus.sock"
    return "zeus rspec"
  else
    return "rspec"
  endif
endfunction

" Rspec
function! RSpecFile()
  execute("!clear && " . RspecCmd() . " " . expand("%p"))
endfunction
map <leader>R :call RSpecFile() <CR>
command! RSpecFile call RSpecFile()

function! RSpecCurrent()
  execute("!clear && " . RspecCmd() . " " . expand("%p") . ":" . line("."))
endfunction
map <leader>r :call RSpecCurrent() <CR>
command! RSpecCurrent call RSpecCurrent()

" Gist
let g:gist_detect_filetype = 1
let g:gist_clip_command = 'xclip -selection clipboard'

" Sessions
let g:session_default_to_last = 1
let g:session_autoload = 1
let g:session_autosave = 1
let g:session_directory = getcwd() . '/.vim-sessions'

" Guardfile
autocmd BufEnter Guardfile set filetype=ruby

" Slim
autocmd BufEnter *.slim set filetype=slim
