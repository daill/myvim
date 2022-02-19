" install plug automatically
let data_dir = stdpath('config') 
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin()
	Plug 'navarasu/onedark.nvim'                                  " theme
  Plug 'preservim/nerdtree'                                     " extended filebrowser
  Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}   " parsing library
  Plug 'neovim/nvim-lspconfig'
  Plug 'hrsh7th/cmp-nvim-lsp'
  Plug 'hrsh7th/cmp-buffer'
  Plug 'hrsh7th/cmp-path'
  Plug 'hrsh7th/cmp-cmdline'
  Plug 'hrsh7th/nvim-cmp'
  Plug 'hrsh7th/cmp-vsnip'
  Plug 'hrsh7th/vim-vsnip'
  Plug 'itchyny/lightline.vim'
  Plug 'hallzy/lightline-onedark'
  Plug 'mbbill/undotree'
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

" tab for completion

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

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
  -- Setup nvim-cmp.
  local cmp = require'cmp'

  cmp.setup({
    snippet = {
      -- REQUIRED - you must specify a snippet engine
      expand = function(args)
        vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
        -- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
        -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
        -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
      end,
    },
    mapping = {
      ['<C-b>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
      ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
      ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
      ['<C-y>'] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
      ['<C-e>'] = cmp.mapping({
        i = cmp.mapping.abort(),
        c = cmp.mapping.close(),
      }),
      ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    },
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      { name = 'vsnip' }, -- For vsnip users.
      -- { name = 'luasnip' }, -- For luasnip users.
      -- { name = 'ultisnips' }, -- For ultisnips users.
      -- { name = 'snippy' }, -- For snippy users.
    }, {
      { name = 'buffer' },
    })
  })

  -- Set configuration for specific filetype.
  cmp.setup.filetype('gitcommit', {
    sources = cmp.config.sources({
      { name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it. 
    }, {
      { name = 'buffer' },
    })
  })

  -- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline('/', {
    sources = {
      { name = 'buffer' }
    }
  })

  -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
  cmp.setup.cmdline(':', {
    sources = cmp.config.sources({
      { name = 'path' }
    }, {
      { name = 'cmdline' }
    })
  })

  require'nvim-treesitter.configs'.setup {
    highlight = {
      enable = true,
      -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
      -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
      -- Using this option may slow down your editor, and you may see some duplicate highlights.
      -- Instead of true it can also be a list of languages
      additional_vim_regex_highlighting = false,
    },
  }

  -- Setup lspconfig.
  local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
  -- Replace <YOUR_LSP_SERVER> with each lsp server you've enabled.
  require'lspconfig'.svelte.setup{}
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


