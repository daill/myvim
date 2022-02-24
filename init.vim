" install plug automatically
let data_dir = stdpath('config') 
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin()
	Plug 'navarasu/onedark.nvim'                                  " theme
  Plug 'preservim/nerdtree'                                     " extended filebrowser
  Plug 'neoclide/coc.nvim', {'branch': 'release'}
  Plug 'itchyny/lightline.vim'
  Plug 'hallzy/lightline-onedark'
  Plug 'mbbill/undotree'
  Plug 'udalov/kotlin-vim'
call plug#end()

" some settings
syntax on           " enable highlighting
set number          " line numbers
set relativenumber  " relative numbering
set linebreak       " don't break word, create new line
set showmode        " show current mode in status line
set scrolloff=5     " keep cursor at top while scrolling
set mouse=a         " scroll with mouse
set lazyredraw      " reduces redraws
set cursorline      " mark active line
set updatetime=300  " faster drawing
set laststatus=2    " always show status line
set cmdheight=2     " more space for messages
set shortmess+=c    " don't pass messages to ins-completion-menu
set nowrap          " disable wrap)

" color fallback
if has('termguicolors')
    set termguicolors
endif
colorscheme onedark

" search enhancements
set path+=**	" :find for subfolders
set ignorecase
set smartcase 	" if intentional accept case

" language
set helplang=en
set spelllang=en,de

autocmd FileType markdown setlocal spell
autocmd FileType text setlocal spell

if !isdirectory($HOME."/.nvim/undodir")
    call mkdir($HOME."/.nvim/undodir", "p", 0700)
endif
set undodir=$HOME/.nvim/undodir
set undofile
set nobackup
set hidden

" tabs
set tabstop=2 softtabstop=2 shiftwidth=2
set expandtab
set formatoptions+=j

" file browser settings
let g:netrw_banner = 0        " disable banner
let g:netrw_browse_split = 4  " open in same window
let g:netrw_altv = 1          " split right
let g:netrw_liststyle = 3     " tree view
let g:netrw_winsize = 25      " shrink window
let g:netrw_list_hide = netrw_gitignore#Hide()    " hide .git
let g:netrw_list_hide.=',\(^\|\s\s)\zs\.\S\+'     " hide . files

" nerdtree settings
let NERDTreeIgnore = ['\.pyc$', '__pycache__']
let NERDTreeMinimalUI = 1
let g:nerdtree_open = 0

function NERDTreeToggle()   " Toggle-Funktion
    if g:nerdtree_open == 1
        let g:nerdtree_open = 0
        NERDTreeClose
    else
        let g:nerdtree_open = 1
        NERDTree
    endif
endfunction

function! StartUp() 
    if 0 == argc()
        NERDTree
        let g:nerdtree_open = 1
    end
endfunction
autocmd VimEnter * call StartUp()

" save settiongs
function! MakeSession()
  let b:sessiondir = stdpath('config').'/sessions'
  if (filewritable(b:sessiondir) != 2)
    exe 'silent !mkdir -p ' b:sessiondir
    redraw!
  endif
  let b:filename = b:sessiondir.'/autosession.vim'
  exe "mksession! ".b:filename
endfunction
au VimLeave * :call MakeSession()

function! LoadSession()
  let b:sessiondir = stdpath('config').'/sessions'
  let b:sessionfile = b:sessiondir.'/autosession.vim'
  if (filereadable(b:sessionfile))
    exe 'source '.b:sessionfile
  else
    echo "No session loaded."
  endif
endfunction
"command! LoadLastSession call LoadSession()


" lightline & vista
let g:lightline = {             
      \ 'colorscheme': 'onedark',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'readonly', 'filename', 'modified', 'method' ] ]
      \ },
      \ 'component_function': {
      \   'method': 'NearestMethodOrFunction'
      \ },
      \ }
let vim_markdown_preview_github=1
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" tab for completion
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

let g:coc_global_extensions = [
      \'coc-snippets',
      \'coc-prettier',
      \'coc-jedi',
      \'coc-html',
      \'coc-highlight',
      \'coc-eslint',
      \'coc-tsserver', 
      \'coc-json', 
      \'coc-css', 
      \'coc-git',
      \'coc-rust-analyzer',
      \'coc-svelte',
      \'coc-java',
      \'coc-svelte',
      \]


" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

nnoremap <silent> K :call <SID>show_documentation()<CR>
function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction

let mapleader = " "

nnoremap <leader>u :UndotreeToggle<CR>
map <silent> <leader>o :call NERDTreeToggle()<CR>
nnoremap <leader>S :LoadLastSession<CR>


" cmp settings
set completeopt=menu,menuone,noselect

lua <<EOF
 
EOF

" faster than Ctrl+W + - < >
nnoremap <silent> <Leader>+ :vertical resize +5<CR>   " VSplit größer
nnoremap <silent> <Leader>- :vertical resize -5<CR>   " kleiner machen
nnoremap <silent> <Leader>* :resize +5<CR>            " HSplit größer machen
nnoremap <silent> <Leader>_ :resize -5<CR>            " kleiner machen

" navigate through tabs
nnoremap <silent> <leader><Left> :tabprevious<CR>
nnoremap <silent> <leader>h :tabprevious<CR>
nnoremap <silent> <leader><Right> :tabnext<CR>
nnoremap <silent> <leader>l :tabnext<CR>
nnoremap <silent> <leader><Up> :tabnew<CR>
nnoremap <silent> <leader><Down> :tabclose<CR>

" navigate through buffers
nnoremap <silent> <leader>k :bp!<CR>
nnoremap <silent> <leader>j :bn!<CR>

" while wrapped move lines not blocks
nnoremap <silent> <A-Down> gj
nnoremap <silent> <A-Up> gk

" enable/disable wrap
nnoremap <silent> <leader>w :set wrap!<CR>

" copy, cut and paste from clipboard
vmap <C-c> "+y
vmap <C-x> "+c
vmap <C-v> c<ESC>"+p
imap <C-v> <ESC>"+pa

" misc
nnoremap <silent> <leader>s :nohlsearch<CR>
nnoremap <silent> <leader>v :Vista!!<CR>
nnoremap <leader>r :source ~/.config/nvim/init.vim<CR>  " Config neu laden
command! WriteUnix w ++ff=unix    " Wenn Du eine Dos-Datei in Unix speichern willst
command! WriteDos w ++ff=dos      " Und anders rum
command! W w " Weil ich Depp mich ständig vertippe
command! Q q " Weil ich Depp mich ständig vertippe


