"***********************************************************************************
"   __  ___         _               ____       __   __    _
"  /  |/  / ___ _  (_)  ___        / __/ ___  / /_ / /_  (_)  ___   ___ _  ___
" / /|_/ / / _ `/ / /  / _ \      _\ \  / -_)/ __// __/ / /  / _ \ / _ `/ (_-<
"/_/  /_/  \_,_/ /_/  /_//_/     /___/  \__/ \__/ \__/ /_/  /_//_/ \_, / /___/
"                                                                 /___/
"
"***********************************************************************************
" This comes first, beacuse we have mappings that depend on leader
" With a map leader it's possible to do extra key combinations
" i.e: <leader>w saves the current file
let mapleader= ","

" Colorscheme
" If you have vim >=8.0 or Neovim >= 0.1.5
if !has('gui_running')
  set t_Co=256
endif

if (has("termguicolors"))
 set termguicolors
endif

" Enable syntax hightlighting
syntax on
set background=dark
colorscheme gruvbox

" increase undo levels to 10,000
"
set undolevels=10000

" increase history to 10,000
"
set history=10000

" Longer leader key timout
set ttimeout
set ttimeoutlen=120

" make backspace delete everywhere
"
set backspace=indent,eol,start

" Show ruler
"
set ruler

" Show partial commands
"
set showcmd

" enhance completion menu
"
set wildmenu

" make vim search all subdirectories
"
set path+=**

" Keep the cursor in the same column when moving
set nostartofline

augroup specify_filetype
  autocmd!
  autocmd BufRead,BufNewFile *.md set filetype=markdown
  autocmd BufRead,BufNewFile *.txt set filetype=text
augroup END

" Enable spell-checking for certain files
autocmd FileType text,markdown setlocal spell

" Limit line length for text files
autocmd FileType text,markdown,tex setlocal textwidth=180

" Don't automatically collapse markdown
set conceallevel=0

" designed for vim 8+
let skip_defaults_vim=1

" Enable mouse scroll for certain modes (see :help mouse)
set mouse=nicr

" Disable guioptions
set guioptions-=m  "remove menu bar
set guioptions-=T  "remove toolbar
set guioptions-=r  "remove right-hand scroll bar
set guioptions-=L  "remove left-hand scroll bar

" Automatically reread the file if it changes outside of vim
set autoread

" Set the cwd to whatever file is in view. Helps with omnicomplete.
" Doesn't work with Dirvish
"set autochdir

" Allow a new buffer to be created without saving the current one
set hidden

" Color the column at line 80 to help with writing clean code
set colorcolumn=80

set noerrorbells

" Statusline config
"set statusline+=%F
"set cmdheight=1

" Tab Settings
set expandtab
set tabstop=4
set softtabstop=4
set shiftwidth=4
set smarttab
set autoindent
set smartindent
set shiftround

" Print syntax highlighting.
set printoptions+=syntax:y

" Matching braces/tags
set showmatch

" Keep a backup file.
"set backup

" Save undo tree.
"set undofile

" Do not back up temporary files.
set backupskip=/tmp/*,/private/tmp/*"

" Store backup files in one place.
" set backupdir^=$HOME/.config/nvim//storage/backups//

" Store swap files in one place.
" set dir^=$HOME/.config/nvim//storage/swaps//

" Store undo files in one place.
" set undodir^=$HOME/.config/nvim/storage/undos//

" line wrapping
set wrap

" Turns on detection for fyletypes, indentation files and plugin files
filetype plugin indent on

" Split window appears right the current one.
set splitright

" Make sure compatible mode is disabled
set nocompatible

" always use utf-8
"
set encoding=utf-8

" use correct new line symbols on unix and windows
"
set fileformats=unix,dos

" Share yank buffer with system clipboard
set clipboard=unnamedplus

" Show next 3 lines while scrolling.
if !&scrolloff
    set scrolloff=3
endif

" Show next 5 columns while side-scrolling.
if !&sidescrolloff
    set sidescrolloff=5
endif

" Jump to the last known position when reopening a file.
if has("autocmd")
  au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
    \| exe "normal! g'\"" | endif
endif

" Relative line numbers
set number
augroup numbertoggle
  autocmd!
  autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
  autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
augroup END

" Disables automatic commenting on newline:
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

" Automatically deletes all trailing whitespace on save
autocmd BufWritePre * %s/\s\+$//e
autocmd BufWritePre * %s/\n\+\%$//e

" When shortcut files are updated, renew bash and ranger configs with new material:
autocmd BufWritePost bm-files,bm-dirs !shortcuts

" Update dwmblocks when config.h is edited
autocmd BufWritePost ~/.local/src/dwmblocks/config.h !cd ~/.local/src/dwmblocks/; sudo make install && { killall -q dwmblocks;setsid dwmblocks & }

" syntax helpers
au bufnewfile,bufRead *.bash* set ft=sh
au bufnewfile,bufRead *.profile set filetype=sh
au bufnewfile,bufRead *.crontab set filetype=crontab
au bufnewfile,bufRead *ssh/config set filetype=sshconfig
au bufnewfile,bufRead *gitconfig set filetype=gitconfig
au bufnewfile,bufread /tmp/psql.edit.* set syntax=sql

" let status and other commands see the type of the current file
au bufnewfile,bufread * call system("echo " . &filetype . " > $HOME/.config/nvim/curfiletype")
au vimleavepre * call system("echo > $HOME/.config/nvim/curfiletype" )

" Run xrdb whenever Xdefaults or Xresources are updated.
autocmd BufRead,BufNewFile xresources,xdefaults set filetype=xdefaults
autocmd BufWritePost Xresources,Xdefaults,xresources,xdefaults !xrdb %

" Restart yabai everytime config is updated
autocmd BufWritePost ~/.confg/yabai/yabairc !brew services restart yabai

" Restart skhd everytime config is updated
autocmd BufWritePost skhdrc !brew services restart skhd

" Use the below highlight group when displaying bad whitespace is desired
highlight BadWhitespace ctermbg=red guibg=red

" Flag tabs instead of spaces
au BufRead,BufNewFile *.py,*.pyw match BadWhitespace /^\t\+/

" Flag Unnecessary Whitespace
au BufRead,BufNewFile *.py,*.pyw,*.c,*.h match BadWhitespace /\s\+$/

" enable omni-completion
set omnifunc=syntaxcomplete#Complete

" Set syntax highlighting
let python_highlight_all=1

" config helpers
command! InitEdit :e ~/.config/nvim/init.vim
command! InitSource :source ~/.config/nvim/init.vim

" Rainbows!
let g:rainbow_active = 1

" Search

"" Highlight search results
set hlsearch
set showmatch

" enable incremental searching
"
set incsearch

"" Ignore case in searches, but smartly
set ignorecase
set smartcase

" GnuPG Extensions
" Tell the GnuPG plugin to armor new files
let g:GPGPreferArmor=1

" Tell the GnuPG plugin to sign new files
let g:GPGPreferSign=1

augroup GnuPGExtra
  " Set extra file options.
  autocmd BufReadCmd,FileReadCmd *.\(gpg\|asc\|pgp\) call SetGPGOptions()
  " Automatically close unmodified files after inactivity.
  autocmd CursorHold *.\(gpg\|asc\|pgp\) quit
augroup END

function SetGPGOptions()
  " set updatetime to 1 minute.
  set updatetime=60000
  " Fold at markers.
  set foldmethod=marker
  " Automatically close all folds.
  set foldclose=all
  " Only open folds with insert commands.
  set foldopen=insert
endfunction

" configure tabline
"
function! Tabline()
  let s = ''
  for i in range(tabpagenr('$'))
    let tab = i + 1
    let winnr = tabpagewinnr(tab)
    let buflist = tabpagebuflist(tab)
    let bufnr = buflist[winnr - 1]
    let bufname = bufname(bufnr)
    let bufmodified = getbufvar(bufnr, "&mod")

    let s .= '%' . tab . 'T'
    let s .= (tab == tabpagenr() ? '%#TabLineSel#' : '%#TabLine#')
    let s .= ' ' . tab .':'
    let s .= (bufname != '' ? '['. fnamemodify(bufname, ':t') . '] ' : '[No Name] ')

    if bufmodified
      let s .= '[+] '
    endif
  endfor

  let s .= '%#TabLineFill#'
  return s
endfunction
set tabline=%!Tabline()

" ignore these suffixes in file completion
"
set suffixes=.bak,~,.swp,.o,.info,.aux,.log,.dvi,.bbl,.blg,.brf,.cb,.ind,.idx,.ilg,.inx,.out,.toc

" visualize wrapped lines with … characters
"
set showbreak=...

" always report the number of changed lines
"
set report=0

" when vim exits, preserve clipboard data
"
autocmd VimLeave * call system("xsel -ib", getreg('+'))

" drop comment symbols when joining lines
"
set formatoptions+=j
