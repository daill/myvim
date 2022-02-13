" ### Plugins

" Install Plug
if empty(glob('~/.local/share/nvim/site/autoload/plug.vim'))
  silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin()
  Plug 'mbbill/undotree'              " Anzeigen von alten Revisionen
  Plug 'vim-scripts/SearchComplete'   " Autocompletion auch in der Suche aktivieren
  Plug 'itchyny/lightline.vim'        " Statuszeile mit mehr Informationen
  Plug 'junegunn/limelight.vim'       " Fokus auf aktuellen Absatz
  Plug 'navarasu/onedark.nvim'        " theme
  Plug 'hallzy/lightline-onedark'     " theme for lightline
  " Plug 'junegunn/goyo.vim'            " Alles ausblenden
  Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() } } " Markdown Preview
  Plug 'yegappan/mru'                 " Most Recently Used über :MRU 
"  Plug '9mm/vim-closer'               " Intelligente Klammern und co.
  Plug 'justinmk/vim-sneak'           " Sehr schnelles springen im Code
  Plug 'preservim/nerdtree'           " Erweiterter Filebrowser
  Plug 'Xuyuanp/nerdtree-git-plugin'  " Erweiterung für Git
  Plug 'airblade/vim-gitgutter'       " Änderungen (Git) anzeigen
  Plug 'neoclide/coc.nvim', {'branch': 'master', 'do': 'yarn install --frozen-lockfile'}
  Plug 'sheerun/vim-polyglot'
call plug#end() " Plugins aktivieren

" Automatisch fehlende Plugins installieren
autocmd VimEnter * if len(filter(values(g:plugs), '!isdirectory(v:val.dir)'))
  \| PlugInstall --sync | source $MYVIMRC
\| endif


" ### Darstellungsoptionen
syntax on           " Syntax Highlighting aktiveren
set number          " Line Numbers anzeigen
set relativenumber  " Relative Nummerierung anzeigen
set linebreak       " Ganze Wörter in neue Zeile umbrechen
set showmode        " Aktuellen Modus in Statuszeile anzeigen
set scrolloff=5     " Cursor bei Scroll weiter oben halten
set mouse=a         " Scrollen mit der Mouse in Console und tmux
set lazyredraw      " Weniger Redraws bei Macros und co.
set cursorline      " Aktive Zeile markieren
set updatetime=300  " Schellere Darstellung	/ Refresh
"set cc=80          " Markierung 80 Zeilen-Rand
set laststatus=2    " Statuszeile immer anzeigen
set cmdheight=2     " Mehr Platz für Statusmeldungen
set shortmess+=c    " Don't pass messages to |ins-completion-menu|
set nowrap          " Wrap standardmäßig abschalten. Mit Leader w an-/abschalten


" ##  Optik und Farben
if has('termguicolors')
    set termguicolors     " Wenn Farben nicht passen, dann die Zeile auskommentieren (z.B. macOS Terminal)	
endif
colorscheme onedark       " Farbschema aktivieren


" ### Suche
set path+=**      " Damit kann mit :find alles, auch in Subfolder gefunden werden
set ignorecase    " Suche nicht Case-Sensentiv
set smartcase     " Aber wenn Großbuchstaben verwenden werden dann schon


" ### Sprache und Rechtschreibkorrektur
set helplang=en             " Deutsche Hilfe
set spelllang=en_us   " Deutsche und englische Rechtschreibung
"set spell                  " Rechtschreibkorrektur immer aktivieren
autocmd FileType markdown setlocal spell   " Spell bei Markdown aktivieren
autocmd FileType text setlocal spell       " Spell bei allgemeinen Textfiles aktivieren


" ### Verhalten für Backup, Swap und co.
if !isdirectory($HOME."/.local/share/nvim/undodir")
    call mkdir($HOME."/.local/share/nvim/undodir", "p", 0700)
endif
set undodir=~/.local/share/nvim/undodir     " Alle Veränderungen werden hier aufgezeichnet
set undofile		                            " Alle Änderungen werden endlos in oberen undodir protokolliert
if !isdirectory($HOME."/.local/share/nvim/swap")
    call mkdir($HOME."/.local/share/nvim/swap", "p", 0700)
endif
set directory=~/.local/share/nvim/swap      " Zentrale Ablage der Swap-Files
"set noswapfile     " Falls kein Swap-Files erstellen werden soll
set nobackup        " Backfile wird sofort wirder gelöscht, da Restores über Undofiles möglich
set hidden          " Wechsel von Buffern auch, wenn File nicht gespeichert


" ### Verhalten von TABs und Einrücken bei Code 
set tabstop=2 softtabstop=2	shiftwidth=2    " Nur zwei Tab-Stopp einfügen
set expandtab           " Tabs in Spaces wandeln
set formatoptions+=j    " Immer Spaces anstatt Tabs
"set clipboard=unnamed  " Standard-Register (yy, dd, etc) IMMER in Zwischenablage kopieren 


" ### Interner Filemanager (Explore, VExplore, SExplore) optimieren
let g:netrw_banner = 0        " Banner abschalten
let g:netrw_browse_split = 4  " im gleichen Fenster öffnen
let g:netrw_altv = 1          " Split rechts öffnen
let g:netrw_liststyle = 3     " Tree View
let g:netrw_winsize = 25      " Fenster schmälter machen
let g:netrw_list_hide = netrw_gitignore#Hide()    " Gits ausblenden	
let g:netrw_list_hide.=',\(^\|\s\s)\zs\.\S\+'     " Dotfiles ausblenden


" ### NERDTree 
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
"autocmd VimEnter * call StartUp()    " Nerdtree anzeigen beim Start, wenn man keine Datei öffnet


" ### Fokusiertes Arbeiten (Befehl :Fokus)
let g:limelight_conceal_ctermfg = 240
function FokusStart()
  Limelight
	Goyo
endfunction
command! Fokus call FokusStart()
function FokusEnde()
  Limelight!  " Beim Beenden von Goyo Limelight auch beenden
endfunction
autocmd! User GoyoLeave call FokusEnde() " Wenn Goyo beendet wird, dann Fokus auch beenden


" ### Sessions
" Automatisch letzte Session speichern
function! MakeSession()
  let b:sessiondir = $HOME . "/.config/nvim/sessions"
  if (filewritable(b:sessiondir) != 2)
    exe 'silent !mkdir -p ' b:sessiondir
    redraw!
  endif
  let b:filename = b:sessiondir . '/autosession.vim'
  exe "mksession! " . b:filename
endfunction
au VimLeave * :call MakeSession()

" Command LoadLastSession ladet die letzte gespeicherte Session
function! LoadSession()
  let b:sessiondir = $HOME . "/.config/nvim/sessions"
  let b:sessionfile = b:sessiondir . "/autosession.vim"
  if (filereadable(b:sessionfile))
    exe 'source ' b:sessionfile
  else
    echo "No session loaded."
  endif
endfunction
command! LoadLastSession call LoadSession()

" ### Allgemeine Settings

" Lightline Coloscheme + Vista in Statuszeile
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
let vim_markdown_preview_github=1   " Github-Erweiterungen von Markdown auch anzeigen
let g:sneak#label = 1               " Sneak-Vimi Label zum schnellen springen aktivieren.

" ### COC

" Automatisch COC Extensions installieren
let g:coc_global_extensions = [
      \'coc-snippets',
      \'coc-prettier',
      \'coc-jedi',
      \'coc-html',
      \'coc-eslint',
      \'coc-tsserver', 
      \'coc-json', 
      \'coc-css', 
      \'coc-git',
      \'coc-rust-analyzer',
      \'coc-svelte',
      \]

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> (g <Plug>(coc-diagnostic-prev)   " Anpassung für deutsche Tastatur
nmap <silent> )g <Plug>(coc-diagnostic-next)

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction

" coc-highlight - Gleiche Wörter im Code markieren
autocmd CursorHold * silent call CocActionAsync('highlight')

autocmd FileType * let b:coc_pairs_disabled = ["<"]

" Zeigt Fehler mit Markierung der Zeile an und Fehlercode, wenn man auf der Zeile steht
augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Mit :Format wird der Code automatisch formatiert
command! -nargs=0 Format :call CocAction('format')


" ### Meine Keyboard-Settings
let mapleader = " "		" Space-Taste als Leader

" Dateihistorie verwalten
nnoremap <leader>u :UndotreeToggle<CR>      " Tracking der Veränderungen anzeigen/ausblenden

" Öffnen von Dateien und Sessions
map <silent> <leader>o :call NERDTreeToggle()<CR>
"nnoremap <leader>o :Lexplore<CR>           " Links den Filebrowser einblenden (nochmals blendet wieder aus)
nnoremap <leader>O :MRU<CR>                 " Zeige die zuletzt verwendeten Dateien an
"nnoremap <leader>O :browse :oldfiles<CR>   " Falls Du MRU nicht verwendest, die interne Funktion
nnoremap <leader>S :LoadLastSession<CR>     " Lade letzte Session

" Schneller als Ctrl+W + - < >
nnoremap <silent> <Leader>+ :vertical resize +5<CR>   " VSplit größer
nnoremap <silent> <Leader>- :vertical resize -5<CR>   " kleiner machen
nnoremap <silent> <Leader>* :resize +5<CR>            " HSplit größer machen
nnoremap <silent> <Leader>_ :resize -5<CR>            " kleiner machen

" Durch Tabs steuern
nnoremap <silent> <leader><Left> :tabprevious<CR>
nnoremap <silent> <leader>h :tabprevious<CR>
nnoremap <silent> <leader><Right> :tabnext<CR>
nnoremap <silent> <leader>l :tabnext<CR>
nnoremap <silent> <leader><Up> :tabnew<CR>
nnoremap <silent> <leader><Down> :tabclose<CR>

" Durch Buffer steuern
nnoremap <silent> <leader>k :bp!<CR>
nnoremap <silent> <leader>j :bn!<CR>

" Bei Wrap-Zeilen in den Zeilen blättern und nicht in Blöcken
nnoremap <silent> <A-Down> gj
nnoremap <silent> <A-Up> gk

" Wrap an-/ausschalten
nnoremap <silent> <leader>w :set wrap!<CR>

" copy, cut and paste direkt in Zwischenablage
vmap <C-c> "+y
vmap <C-x> "+c
vmap <C-v> c<ESC>"+p
imap <C-v> <ESC>"+pa

" Sonstiges
nnoremap <silent> <leader>s :nohlsearch<CR>
nnoremap <silent> <leader>v :Vista!!<CR>
nnoremap <leader>r :source ~/.config/nvim/init.vim<CR>  " Config neu laden
command! WriteUnix w ++ff=unix    " Wenn Du eine Dos-Datei in Unix speichern willst
command! WriteDos w ++ff=dos      " Und anders rum
command! W w " Weil ich Depp mich ständig vertippe
command! Q q " Weil ich Depp mich ständig vertippe
