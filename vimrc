
" Should be first, use vim settings rather than vi settings
" Enable loading plugins
set nocompatible

" Disable some Vim's native plugins. Do it before 'filetype plugin' command
" Do not load matchparens (higlight matching pairs)
" Do not load matchit (improves % motion to find matching words besides matching parens)
" Native Vim's "matchparen" is slow and cause lags during scrolling
" 'andymass/vim-matchup' is used instead
let g:loaded_matchit = 1
let g:loaded_matchparen = 1

" Some servers have issues with backup files
set nobackup
set nowritebackup

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience
set updatetime=300

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
set signcolumn=yes

" Turns on:
" - detection of filetype based on extensions or file content (runtime/filetype.vim, ftdetect/xxx)
" - once file type is detected, read per-filetype commands from 'ftplugin/<type>.vim'
" - once file type is detected, read indentation expression from 'indent/<type>.vim'
" See ":h :filetype-overview" for more info
filetype plugin indent on

" Plugin: sheerun/vim-polyglot
" Disable default settings (a.k.a normalize) from 'tpope/vim-sensible'
" NOTE: this should come before plug#begin section
let g:polyglot_disabled = ['sensible', 'markdown']

"""""""""""
" Plugins "
"""""""""""

" Autoinstall vim-plug
if empty(glob('~/.vim/autoload/plug.vim')) && confirm("Install vim-plug??","Y\nn") == 1
    silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Plugins
call plug#begin('~/.vim/plugged')
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'pbogut/fzf-mru.vim'
Plug 'vim-scripts/SyntaxAttr.vim'
Plug 'bronson/vim-trailing-whitespace'
Plug 'morhetz/gruvbox'
Plug 'romainl/vim-qf'
Plug 'tpope/vim-commentary'
Plug '907th/vim-auto-save'
Plug 'tpope/vim-obsession'
Plug 'farmergreg/vim-lastplace'
Plug 'andymass/vim-matchup'
Plug 'tpope/vim-surround'
Plug 'sheerun/vim-polyglot'
Plug 'catppuccin/vim', { 'as': 'catppuccin' }
call plug#end()


"""""""""""
" General "
"""""""""""

" Make Vim more useful, but less Vi compatible
set nocompatible

" Make backspace work like other apps
set backspace=2

" Display cursor position
set ruler

" Show the status line
set laststatus=2

" Automatically save before commands like :next and :make
set autowrite

" Show the editor mode
set showmode

" Show state of keyboard input
set showcmd

" Allow mouse (is this sacrilege?)
set mouse=a

" Show whitespace characters
set list

" Use wildmenu for command line tab completion
set wildmenu
set wildmode=list:longest,full

" Underline the current line
set cursorline

" Allow modified buffers to go to the background
set hidden

" The TTY is fast
set ttyfast

" Set the minimum number of lines to keep above and below cursor
set scrolloff=5

" Set termcolors
set termguicolors

" Set colortheme
:colorscheme catppuccin_mocha

""""""""""""""""
" Line Numbers "
""""""""""""""""

" Default to relative line numbers.
set relativenumber


""""""""
" Tabs "
""""""""

" Tabs should be 4-spaces
set tabstop=4
set shiftwidth=4

" Use spaces instead of tabs
set expandtab

"  Show > for tab
set listchars=tab:>-

" 4 spaces is a tab, so backspace will work properly
set softtabstop=4

" Follow line indentation
set autoindent

""""""""""
" Search "
""""""""""

" Turn on search highlighting
set hlsearch

" Ignore case in searches -- but be smart!
set ignorecase
set smartcase

" Start searching as the characters are typed
set incsearch


"""""""""""
" Folding "
"""""""""""

" Auto-fold by indentation.
"set foldmethod=indent

" Limit nested folds.
"set foldnestmax=10

" Unfold folds by default.
"set nofoldenable

"set foldlevel=2


"""""""""""""""""""""
" Keyboard Shorcuts "
"""""""""""""""""""""

" Remap colon to semicolon.
nnoremap ; :

" Toggle folds with space.
nnoremap <Space> za
vnoremap <Space> za

" Redraw syntax highlighting from start of file.
nnoremap U :syntax sync fromstart<cr>:redraw!<cr>

" Disable arrow keys. Force use of <hjkl>. (Oh noes!)
nnoremap <up> <nop>
nnoremap <down> <nop>
nnoremap <left> <nop>
nnoremap <right> <nop>
inoremap <up> <nop>
inoremap <down> <nop>
inoremap <left> <nop>
inoremap <right> <nop>

" Move by screen line rather than file line (for wrapping).
nnoremap j gj
nnoremap k gk

" Set smooth scrolling
:map <C-U> <C-Y><C-Y><C-Y><C-Y><C-Y><C-Y><C-Y><C-Y><C-Y><C-Y><C-Y><C-Y><C-Y><C-Y><C-Y><C-Y>
:map <C-D> <C-E><C-E><C-E><C-E><C-E><C-E><C-E><C-E><C-E><C-E><C-E><C-E><C-E><C-E><C-E><C-E>

" Move between windows with CTRL and navigation keys.
noremap <C-h> <C-w>h
noremap <C-j> <C-w>j
noremap <C-k> <C-w>k
noremap <C-l> <C-w>l

" Switch between windows with <Leader><number>
let i = 1
while i <= 9
    execute 'nnoremap <Leader>' . i . ' :' . i . 'wincmd w<CR>'
    let i = i + 1
endwhile

" Disable search highlighting (<leader><space>)
nnoremap <leader><space> :noh<cr>

" Open a new tab (Ctrl+t)
nnoremap <C-t> :tabnew

" Toggle paste mode
set pastetoggle=<leader>p

" Write a file with sudo (w!!)
cmap w!! w !sudo tee % >/dev/null

" Escape (kj)
inoremap kj <Esc>

" Toggle relative line numbers (Ctrl+n)
function! g:ToggleNuMode()
  if &nu == 1
     set rnu
  else
     set nu
  endif
endfunction
nnoremap <silent><C-n> :call g:ToggleNuMode()<cr>

" Paste from system clipboard in insert mode (Ctrl+v)
imap <C-V> <ESC>"+gpa

" Yank WORD to system clipboard in normal mode
nmap <leader>y "+yE

" Yank selection to system clipboard in visual mode
vmap <leader>y "+y

" Spell check
map <leader>s :setlocal spell! spelllang=en_us<cr>

" Buffer navigation
map [b :bprevious<cr>
map ]b :bnext<cr>
map <leader>b :buffers<cr>

" Insert date with cdate
:iab cdate <c-r>=strftime("%Y-%m-%d")<CR>

" Insert datetime with ctime
:iab ctime <c-r>=strftime("%Y-%m-%d %H:%M:%SZ%z")<CR>

" Move tabs left or right
map <leader>[ :tabmove-1<CR>
map <leader>] :tabmove+1<CR>


"""""""""""
" Styling "
"""""""""""

" Syntax highlighting
syntax enable

" Spell check
highlight clear SpellBad
highlight SpellBad term=standout ctermfg=1 term=underline cterm=underline
highlight clear SpellCap
highlight SpellCap ctermfg=44 term=underline cterm=underline
highlight clear SpellRare
highlight SpellRare ctermfg=44 term=underline cterm=underline
highlight clear SpellLocal
highlight SpellLocal ctermfg=44 term=underline cterm=underline

" Default gVim window size.
if has("gui_running")
    set lines=50 columns=100
endif

"""""""""""""""""""
" Temporary Files "
"""""""""""""""""""
" https://gist.github.com/tejr/5890634

" Don't backup files in temp directories or shm
if exists('&backupskip')
    set backupskip+=/tmp/*,$TMPDIR/*,$TMP/*,$TEMP/*,*/shm/*
endif

" Don't keep swap files in temp directories or shm
if has('autocmd')
    augroup swapskip
        autocmd!
        silent! autocmd BufNewFile,BufReadPre
            \ /tmp/*,$TMPDIR/*,$TMP/*,$TEMP/*,*/shm/*
            \ setlocal noswapfile
    augroup END
endif

" Don't keep undo files in temp directories or shm
if has('persistent_undo') && has('autocmd')
    augroup undoskip
        autocmd!
        silent! autocmd BufWritePre
            \ /tmp/*,$TMPDIR/*,$TMP/*,$TEMP/*,*/shm/*
            \ setlocal noundofile
    augroup END
endif

" Don't keep viminfo for files in temp directories or shm
if has('viminfo')
    if has('autocmd')
        augroup viminfoskip
            autocmd!
            silent! autocmd BufNewFile,BufReadPre
                \ /tmp/*,$TMPDIR/*,$TMP/*,$TEMP/*,*/shm/*
                \ setlocal viminfo=
        augroup END
    endif
endif

""""""""""""
" Markdown "
""""""""""""

" Prefer pythonic folding
let g:vim_markdown_folding_style_pythonic = 1
