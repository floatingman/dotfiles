"*****************************************************************************************
"   ___    __                _               ____       __   __    _
"  / _ \  / / __ __  ___ _  (_)  ___        / __/ ___  / /_ / /_  (_)  ___   ___ _  ___
" / ___/ / / / // / / _ `/ / /  / _ \      _\ \  / -_)/ __// __/ / /  / _ \ / _ `/ (_-<
"/_/    /_/  \_,_/  \_, / /_/  /_//_/     /___/  \__/ \__/ \__/ /_/  /_//_/ \_, / /___/
"                  /___/                                                   /___/
"
"*****************************************************************************************
""""""""""""""
" Git Gutter "
""""""""""""""
let g:gitgutter_enabled =1
let g:gitgutter_grep=''

"""""""""""
" Goyo    "
"""""""""""
nmap <F6> :Goyo \| set linebreak<CR>
" Goyo's width will be the line limit in mutt.
autocmd BufRead,BufNewFile /tmp/neomutt* let g:goyo_width=80
autocmd BufRead,BufNewFile /tmp/neomutt* :Goyo

"""""""""""""
" Limelight "
"""""""""""""
 let g:limelight_conceal_ctermfg = 'gray'
 let g:limelight_conceal_ctermfg = 240
 let g:limelight_conceal_guifg = 'DarkGray'
 let g:limelight_conceal_guifg = '#777777'
 let g:limelight_deafault_coeffiecient = 0.7
 let g:limelight_paragraph_span = 1
 let g:limelight_bob = '^\s'
 let g:limelight_eop = '\ze\n^\s'
 let g:limelight_priority = -1
 autocmd! User GoyoEnter Limelight
 autocmd! User GoyoLeave Limelight!

"""""""""""
" Vista   "
"""""""""""
let g:vista_executive_for = {
      \ 'c': 'coc',
      \ }
let g:vista_icon_indent = ["╰─▸ ", "├─▸ "]
let g:vista#renderer#enable_icon = 1
let g:vista_sidebar_width = 50

""""""""""""
" Nerdtree "
""""""""""""
function! NERDTreeToggleCurrentFile()
    if (exists("t:NERDTreeBufName") && bufwinnr(t:NERDTreeBufName) != -1)
        exe ":NERDTreeClose"
    else
        exe ":NERDTreeFind"
    endif
endfunction
nnoremap <silent> <Leader>t :call NERDTreeToggleCurrentFile()<CR>

"" NerdTreeGitPlugin Settings
"
let g:NERDTreeIndicatorMapCustom = {
    \ "Modified"  : "✹",
    \ "Staged"    : "✚",
    \ "Untracked" : "✭",
    \ "Renamed"   : "➜",
    \ "Unmerged"  : "═",
    \ "Deleted"   : "✖",
    \ "Dirty"     : "✗",
    \ "Clean"     : "✔︎",
    \ 'Ignored'   : '☒',
    \ "Unknown"   : "?"
    \ }
let g:NERDTreeShowIgnoredStatus = 1

""NerdTree Syntax Plugin
"
let s:brown = "905532"
let s:aqua =  "3AFFDB"
let s:blue = "689FB6"
let s:darkBlue = "44788E"
let s:purple = "834F79"
let s:lightPurple = "834F79"
let s:red = "AE403F"
let s:beige = "F5C06F"
let s:yellow = "F09F17"
let s:orange = "D4843E"
let s:darkOrange = "F16529"
let s:pink = "CB6F6F"
let s:salmon = "EE6E73"
let s:green = "8FAA54"
let s:lightGreen = "31B53E"
let s:white = "FFFFFF"
let s:rspec_red = 'FE405F'
let s:git_orange = 'F54D27'

let g:NERDTreeExtensionHighlightColor = {} " this line is needed to avoid error
let g:NERDTreeExtensionHighlightColor['css'] = s:blue " sets the color of css files to blue

let g:NERDTreeExactMatchHighlightColor = {} " this line is needed to avoid error
let g:NERDTreeExactMatchHighlightColor['.gitignore'] = s:git_orange " sets the color for .gitignore files

let g:NERDTreePatternMatchHighlightColor = {} " this line is needed to avoid error
let g:NERDTreePatternMatchHighlightColor['.*_spec\.rb$'] = s:rspec_red " sets the color for files ending with _spec.rb

let g:WebDevIconsDefaultFolderSymbolColor = s:beige " sets the color for folders that did not match any rule
let g:WebDevIconsDefaultFileSymbolColor = s:blue " sets the color for files that did not match any rule

""BufExplorer settings
"
nnoremap <silent> <Leader>ee :ToggleBufExplorer<CR>
nnoremap <silent> <Leader>eh :BufExplorerHorizontalSplit<CR>
nnoremap <silent> <Leader>ev :BufExplorerVerticalSplit<CR>

"" Leader-f opens fzf files
"  Leader-b opens fzf buffers
nnoremap <silent> <Leader>f :Files<CR>
nnoremap <silent> <Leader>b :Buffers<CR>

""""""""""""""""""
" Nerd Commenter "
""""""""""""""""""
" Add spaces after coment delimiters by default
" let g:NERDSpaceDelims = 1
" " Use compact syntax for prettified multi-line comments
" let g:NERDCompactSexyComs = 1
" " Toggle comments in visual or normal mode
" nnoremap <leader>n :call NERDComment(0,"toggle")<cr>
" vnoremap <leader>n :call NERDComment(1,"toggle")<cr>
" " Toggle a sexy comment
" nnoremap <leader>ns :call NERDComment(0,"sexy")<cr>
" vnoremap <leader>ns :call NERDComment(1,"sexy")<cr>
" " append a  comment
" nnoremap <leader>na :call NERDComment(0,"append")<cr>
" vnoremap <leader>na :call NERDComment(1,"append")<cr>
" " uncomment section
" nnoremap <leader>nu :call NERDComment(0,"uncomment")<cr>
" vnoremap <leader>nu :call NERDComment(1,"uncomment")<cr>
" " invert comments
" nnoremap <leader>ni :call NERDComment(0,"invert")<cr>
" vnoremap <leader>ni :call NERDComment(1,"invert")<cr>
" " comment section
" nnoremap <leader>nc :call NERDComment(0,"comment")<cr>
" vnoremap <leader>nc :call NERDComment(1,"comment")<cr>
"

"""""""
"COC  "
"""""""

" Define Error Symbols and colors
" let g:coc_status_warning_sign = ''
" let g:coc_status_error_sign = ''
" hi CocWarningSign ctermfg=blue
" hi CocErrorSign ctermfg=red
" hi CocInfoSign ctermfg=yellow
" hi CocHintSign ctermfg=green

" " Transparent popup window
" hi! Pmenu ctermbg=black
" hi! PmenuSel ctermfg=2
" hi! PmenuSel ctermbg=0

" " Brighter line numbers
" hi! LineNr ctermfg=NONE guibg=NONE

" " KEY REMAPS ""
" set updatetime=300
" let g:ycm_server_python_interpreter = '$HOME/.pyenv/shims/python3'
" let g:coc_snippet_next = '<TAB>'
" let g:coc_snippet_prev = '<S-TAB>'

" " Extensions. Some need configuration.
" " coc-java needs a valid JVM filepath defined in coc-settings
" " coc-eslint needs eslint npm package installed globally
" let g:coc_global_extensions = [
      " \'coc-html',
      " \'coc-xml',
      " \'coc-java',
      " \'coc-powershell',
      " \'coc-r-lsp',
      " \'coc-vimlsp',
      " \'coc-lua',
      " \'coc-sql',
      " \'coc-go',
      " \'coc-css',
      " \'coc-sh',
      " \'coc-snippets',
      " \'coc-prettier',
      " \'coc-eslint',
      " \'coc-emmet',
      " \'coc-tsserver',
      " \'coc-translator',
      " \'coc-docker',
      " \'coc-pairs',
      " \'coc-json',
      " \'coc-python',
      " \'coc-imselect',
      " \'coc-highlight',
      " \'coc-git',
      " \'coc-github',
      " \'coc-gitignore',
      " \'coc-emoji',
      " \'coc-lists',
      " \'coc-post',
      " \'coc-stylelint',
      " \'coc-yaml',
      " \'coc-template',
      " \'coc-utils'
      " \]

" augroup MyAutoCmd
  " autocmd!
  " " Setup formatexpr specified filetype(s).
  " autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " " Update signature help on jump placeholder
  " autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
" augroup end

" " Highlight symbol under cursor on CursorHold
" autocmd CursorHold * silent call CocActionAsync('highlight')

" " COC Keybinds
" " Remap keys for gotos
" map <leader>cd <Plug>(coc-definition)
" nmap <leader>ct <Plug>(coc-type-definition)
" nmap <leader>ci <Plug>(coc-implementation)
" map <leader>cr <Plug>(coc-references)
" " Remap for rename current word
" nmap <leader>crn <Plug>(coc-rename)
" " Remap for format selected region
" xmap <leader>cf <Plug>(coc-format-selected)
" nmap <leader>cf <Plug>(coc-format-selected)
" " Fix current line
" nmap <leader>cfl  <Plug>(coc-fix-current)
" " Using CocList
" " Show all diagnostics
" nnoremap  <Leader>cdi  :<C-u>CocList diagnostics<cr>
" " Manage extensions
" nnoremap  <Leader>ce  :<C-u>CocList extensions<cr>
" " Show commands
" nnoremap  <Leader>cc  :<C-u>CocList commands<cr>
" " Find symbol of current document
" nnoremap <Leader>co  :<C-u>CocList outline<cr>
" " Completion keybinds

" inoremap <silent><expr> <TAB>
      " \ pumvisible() ? "\<C-n>" :
      " \ <SID>check_back_space() ? "\<TAB>" :
      " \ coc#refresh()

" " shift+tab cycles backwards
" inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

" function! s:check_back_space() abort
  " let col = col('.') - 1
  " return !col || getline('.')[col - 1]  =~# '\s'
" endfunction

" " Enter to confirm completion
" inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"

"""""""""""""
"Devicons   "
"""""""""""""
let g:webdevicons_enable = 1
let g:webdevicons_enable_unite = 1
let g:webdevicons_enable_denite = 1
let g:webdevicons_enable_nerdtree = 1
let g:webdevicons_enable_airline_tabline = 1
let g:webdevicons_enable_vimfiler = 1
let g:WebDevIconsUnicodeDecorateFileNodes = 1
let g:WebDevIconsUnicodeDecorateFolderNodes = 1
let g:WebDevIconsUnicodeGlyphDoubleWidth = 1
let g:webdevicons_enable_airline_statusline = 1
let g:WebDevIconsNerdTreeGitPluginForceVAlign = 1
let g:WebDevIconsUnicodeGlyphDoubleWidth = 1
let g:WebDevIconsUnicodeDecorateFolderNodesDefaultSymbol = ''
let g:DevIconsDefaultFolderOpenSymbol = ''

""""""""""""
"Airline   "
""""""""""""
"main settings
"let g:airline_theme='wpgtk'
"let g:airline_powerline_fonts = 1
"let g:airline_symbols = {}
"let g:airline_skip_empty_sections = 1
"let g:airline_left_sep = ''
"let g:airline_left_alt_sep = ''
"let g:airline_right_sep = ''
"let g:airline_right_alt_sep = ''
"let g:airline_symbols_branch = ''
"let g:airline_powerline_fonts = 1
"let g:airline_symbols.crypt = ''
"let g:airline_symbols.linenr = '☰'
"let g:airline_symbols.linenr = '␊'
"let g:airline_symbols.linenr = '␤'
"let g:airline_symbols.linenr = '¶'
"let g:airline_symbols.maxlinenr = ''
"let g:airline_symbols.paste = 'ρ'
"let g:airline_symbols.paste = 'Þ'
"let g:airline_symbols.paste = '∥'
"let g:airline_symbols.spell = 'Ꞩ'
"let g:airline_symbols.notexists = 'Ɇ'
"let g:airline_symbols.whitespace = 'Ξ'
"let g:airline_symbols.modified = ' '
"let g:airline_section_error = '%{airline#util#wrap(airline#extensions#coc#get_error(),0)}'
"let g:airline_section_warning = '%{airline#util#wrap(airline#extensions#coc#get_warning(),0)}'
""extensions
"let g:airline#extensions#tabline#enabled = 1
"let g:airline#extensions#ale#enabled = 1
"let g:airline#extensions#coc#enabled = 1
"let g:airline#extensions#unicode#enabled = 1
"let g:airline#extensions#branch#enabled = 1
"let g:airline#extensions#vista#enabled = 1
"let g:airline#extensions#hunks#enabled = 1
""extension settings
"let airline#extensions#coc#stl_format_err = '%E{[%e(#%fe)]}'
"let airline#extensions#coc#stl_format_warn = '%W{[%w(#%fw)]}'
"let airline#extensions#coc#warning_symbol = ':'
"let airline#extensions#coc#error_symbol = ':'
"let g:airline#extensions#hunks#hunk_symbols = [':', ':', ':']
"let g:airline#extensions#branch#format = 2

" lightline config
" let g:lightline = {
      " \ 'colorscheme': 'solarized',
      " \ 'active': {
      " \   'left': [ ['mode', 'paste'],
      " \             ['fugitive', 'cocstatus', 'readonly', 'filename', 'modified'] ],
      " \   'right': [ [ 'lineinfo' ], ['percent'] ]
      " \ },
      " \ 'component': {
      " \   'readonly': '%{&filetype=="help"?"":&readonly?"🔒":""}',
      " \   'modified': '%{&filetype=="help"?"":&modified?"+":&modifiable?"":"-"}',
      " \   'fugitive': '%{exists("*fugitive#head")?fugitive#head():""}'
      " \ },
      " \ 'component_visible_condition': {
      " \   'readonly': '(&filetype!="help"&& &readonly)',
      " \   'modified': '(&filetype!="help"&&(&modified||!&modifiable))',
      " \   'fugitive': '(exists("*fugitive#head") && ""!=fugitive#head())'
      " \ },
      " \ 'component_function': {
      " \   'cocstatus': 'coc#status'
      " \ },
      " \ 'separator': { 'left': ' ', 'right': ' ' },
      " \ 'subseparator': { 'left': ' ', 'right': ' ' }
      " \ }

" " Use auocmd to force lightline update.
" autocmd User CocStatusChange,CocDiagnosticChange call lightline#update()

"""""""""""""""""
"Indent Guides  "
"""""""""""""""""
"let g:indentLine_char = '▏'
let g:indentLine_char_list = ['|', '¦', '┆', '┊']

let g:indent_guides_auto_colors = 1
let g:indentLine_fileTypeExclude = [
      \'defx',
      \'markdown',
      \'denite',
      \'startify',
      \'tagbar',
      \'vista_kind',
      \'vista'
      \]

"""""""""""""
"Autopairs  "
"""""""""""""
" let g:AutoPairsFlyMode = 0
" let g:AutoPairsMultilineClose = 0

"""""""""""""""""
"Comfy-Scroll   "
"""""""""""""""""
" noremap <silent> <ScrollWheelDown> :call comfortable_motion#flick(40)<CR>
" noremap <silent> <ScrollWheelUp>   :call comfortable_motion#flick(-40)<CR>
" let g:comfortable_motion_friction = 50.0
" let g:comfortable_motion_air_drag = 1.0

""""""""""
" Emoji  "
""""""""""
set completefunc=emoji#complete

""""""""""""
"Startify  "
""""""""""""
function! s:center(lines) abort
  let longest_line   = max(map(copy(a:lines), 'strwidth(v:val)'))
  let centered_lines = map(copy(a:lines),
        \ 'repeat(" ", (&columns / 2) - (longest_line / 2)) . v:val')
  return centered_lines
endfunction
let s:header= [
      \"Floatingman's VIM session -- based on vim.Reaper",
      \]

let g:startify_change_to_dir = 1
let g:startify_custom_header = s:center(s:header)
" Optionally create and use footer
"let s:header= []
"let g:startify_custom_footer = s:center(s:footer)

" vim-ags
" Search for the word under cursor
nnoremap <Leader>s :Ags<Space><C-R>=expand('<cword>')<CR><CR>
" Search for the visually selected text
vnoremap <Leader>s y:Ags<Space><C-R>='"' . escape(@", '"*?()[]{}.') . '"'<CR><CR>
" Run Ags
nnoremap <Leader>ag :Ags<Space>
" Quit Ags
nnoremap <Leader><Leader>a :AgsQuit<CR>

" ag items.  I need the silent ag.
if executable('ag')
  " Use ag over grep "
  set grepprg=ag\ --nogroup\ --nocolor\ --column

  " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore "
  let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'

  " ag is fast enough that CtrlP doesn't need to cache "
  let g:ctrlp_use_caching = 0
endif

" better-whitespace
map <leader>W :ToggleWhitespace<CR>
let g:better_whitespace_enabled = 0

" lengthmatters
map <leader>L :LengthmattersToggle<CR>
let g:lengthmatters_on_by_default = 0
let g:lengthmatters_start_at_column = 130

" Syntax
"ale
" set completeopt-=preview
" let g:ale_set_loclist = 0
" let g:ale_set_quickfix = 1
" " Set this variable to 1 to fix files when you save them.
" let g:ale_fix_on_save = 1
" " Let Ale autoimport modules in typescript
" let g:ale_completion_tsserver_autoimport = 1

" FZF
" An action can be a reference to a function that processes selected lines
function! s:build_quickfix_list(lines)
  call setqflist(map(copy(a:lines), '{ "filename": v:val }'))
  copen
  cc
endfunction

let g:fzf_action = {
  \ 'ctrl-q': function('s:build_quickfix_list'),
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-x': 'split',
  \ 'ctrl-v': 'vsplit' }

" Default fzf layout
" - down / up / left / right
"let g:fzf_layout = { 'down': '~40%' }

" You can set up fzf window using a Vim command (Neovim or latest Vim 8 required)
"let g:fzf_layout = { 'window': 'enew' }
let g:fzf_layout = { 'window': '-tabnew' }
"let g:fzf_layout = { 'window': '10new' }

" Customize fzf colors to match your color scheme
" - fzf#wrap translates this to a set of `--color` options
let g:fzf_colors =
\ { 'fg':      ['fg', 'Normal'],
  \ 'bg':      ['bg', 'Normal'],
  \ 'hl':      ['fg', 'Comment'],
  \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
  \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
  \ 'hl+':     ['fg', 'Statement'],
  \ 'info':    ['fg', 'PreProc'],
  \ 'border':  ['fg', 'Ignore'],
  \ 'prompt':  ['fg', 'Conditional'],
  \ 'pointer': ['fg', 'Exception'],
  \ 'marker':  ['fg', 'Keyword'],
  \ 'spinner': ['fg', 'Label'],
  \ 'header':  ['fg', 'Comment'] }

" Hide status bar while using fzf commands
if has('nvim') || has('gui_running')
  autocmd! FileType fzf
  autocmd  FileType fzf set laststatus=0 | autocmd WinLeave <buffer> set laststatus=2
endif

" Centered floating window for fzf
let g:fzf_layout = { 'window': 'call CreateCenteredFloatingWindow()' }

" VimWiki
let g:vimwiki_list = [{'path': '~/vimwiki/',
                      \ 'syntax': 'markdown', 'ext': '.md'}]

" RG"
" bind K to grep word under cursor
"nnoremap K :grep! "\b<C-R><C-W>\b"<CR>:cw<CR>
"command -nargs=+ -complete=file -bar Ag silent! grep! <args>|cwindow|redraw!
"nnoremap \ :Ag<SPACE>
"nnoremap <Leader>ps :Ag<SPACE>

" Fugitive keybinds
" Git status
nnoremap  <Leader>gs  :Gstatus<cr>
" Git diff in split window
nnoremap  <Leader>gd  :Gdiffsplit<cr>
" Git commit
nnoremap  <Leader>gc  :Gcommit<cr>
" Git Log
nnoremap <Leader>gl   :Glog<cr>
" Git push
nnoremap  <Leader>gP  :Gpush<cr>
" Git pull
nnoremap  <Leader>gp  :Gpull<cr>
" Git move
nnoremap  <Leader>gm  :Gmove<cr>
" Git merge
nnoremap  <Leader>gM  :Gmerge<cr>
" browse current file on web
nnoremap  <Leader>gb  :Gbrowse<cr>
" browse current line on web
nnoremap  <Leader>gbl  :CocCommand git.browserOpen<cr>
" View chunk information in preview window.
nnoremap  <Leader>gh  :CocCommand git.chunkInfo<cr>
" View commit information in preview window.
nnoremap  <Leader>gsc  :CocCommand git.showCommit<cr>
" Toggle git gutter sign columns
nnoremap  <Leader>gg  :CocCommand git.toggleGutters<cr>
" Lazygit
nnoremap <silent> <Leader>lg :call ToggleLazyGit()<CR>

" Vista
" Floating tag finder
nnoremap  <Leader>ft  :Vista finder coc<cr>
" Opens tagbar on right side of screen
nmap <F8> :Vista!!<CR>

" Undotree
nmap <leader>u :UndotreeShow<CR>

" configure illuminate plugin
"
highlight link illuminatedWord Visual

" configure matchup plugin
"
let g:matchup_matchparen_offscreen = {}

" configure undoquit plugin
"
nnoremap <c-w>c :call undoquit#SaveWindowQuitHistory()<cr><c-w>c

" configure dirvish plugin
"
nmap <leader>d <Plug>(dirvish_up)

" configure Asterisk
"
map * <Plug>(asterisk-*)
map # <Plug>(asterisk-#)
let g:asterisk#keeppos = 1

" make an alias command :B for :Bufferize
"
cabbrev B Bufferize

" configure textmanip plugin
"
let g:textmanip_enable_mappings = 0
let g:textmanip_move_ignore_shiftwidth = 1
xmap <C-j> <Plug>(textmanip-move-down)
xmap <C-k> <Plug>(textmanip-move-up)
xmap <C-h> <Plug>(textmanip-move-left)
xmap <C-l> <Plug>(textmanip-move-right)

" configure easy-align plugin
"
xmap <leader>ea <Plug>(EasyAlign)
nmap <leader>ea <Plug>(EasyAlign)

" configure ranger plugin
"
let g:ranger_map_keys = 0
map <leader>r :Ranger<CR>

" configure scratch plugin
"
let g:scratch_no_mappings = 1

" configure speeddating plugin
"
let g:speeddating_no_mappings = 1
nmap <C-a> <Plug>SpeedDatingUp
nmap <C-x> <Plug>SpeedDatingDown

" configure thesaurus-query plugin
"
let g:tq_map_keys = 0
let g:tq_use_vim_autocomplete = 0
let g:tq_openoffice_en_file = "~/.vim/thesaurus/th_en_US_v2"
