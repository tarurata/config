call plug#begin()
Plug 'tpope/vim-fugitive'
Plug 'scrooloose/nerdtree'
Plug 'mattn/emmet-vim'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'cohama/lexima.vim'
Plug 'tpope/vim-surround'
Plug 'posva/vim-vue'
Plug 'scrooloose/nerdcommenter'
Plug 'jwalton512/vim-blade'
Plug 'ap/vim-css-color'
Plug 'tomasr/molokai'
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
Plug 'easymotion/vim-easymotion'
Plug 'Shougo/ddc.vim' " ddc.vim本体
Plug 'vim-denops/denops.vim' " DenoでVimプラグインを開発するためのプラグイン
Plug 'prabirshrestha/vim-lsp'
Plug 'mattn/vim-lsp-settings' " vim-lspの設定
Plug 'mattn/vim-lsp-icons'
Plug 'hrsh7th/vim-vsnip' " https://zenn.dev/shougo/articles/snippet-plugins-2020
Plug 'hrsh7th/vim-vsnip-integ'
Plug 'rafamadriz/friendly-snippets' " 大量のスニペット郡
Plug 'Shougo/pum.vim' " ポップアップウィンドウを表示するプラグイン
Plug 'Shougo/ddc-source-around' " カーソル周辺の既出単語を補完するsource
Plug 'neovim/nvim-lspconfig' " Configuration for Nvim LSP
Plug 'williamboman/mason.nvim'
Plug 'williamboman/mason-lspconfig.nvim'
Plug 'Shougo/ddc-source-nvim-lsp'
Plug 'LumaKernel/ddc-file' " ファイル名を補完するsource
Plug 'Shougo/ddc-matcher_head' " 入力中の単語を補完の対象にするfilter
Plug 'Shougo/ddc-sorter_rank' " 補完候補を適切にソートするfilter
Plug 'Shougo/ddc-converter_remove_overlap' " 補完候補の重複を防ぐためのfilter
Plug 'matsui54/denops-popup-preview.vim'
Plug 'Shougo/ddc-ui-pum'
call plug#end()
call ddc#custom#patch_global('completionMenu', 'pum.vim')
call ddc#custom#patch_global('sources', [ 'nvim-lsp',  'around', 'file' ])
call ddc#custom#patch_global('sourceOptions', {
 \ '_': {
 \   'matchers': ['matcher_head'],
 \   'sorters': ['sorter_rank'],
 \   'converters': ['converter_remove_overlap'],
 \ },
 \ 'nvim-lsp': {
 \   'mark': 'LSP', 
 \   'forceCompletionPattern': '\.\w*|:\w*|->\w*',
 \ },
 \ 'around': {
 \   'mark': 'Around'
 \ },
 \ 'file': {
 \   'mark': 'file',
 \   'isVolatile': 'v:true', 
 \   'forceCompletionPattern': '\S/\S*'
 \ }
 \})
call ddc#custom#patch_global('ui', 'pum')
" Use Customized labels
call ddc#custom#patch_global('sourceParams', {
      \   'nvim-lsp': { 'kindLabels': { 'Class': 'c' } },
      \ })

call popup_preview#enable()
autocmd User PumCompleteDone call vsnip_integ#on_complete_done(g:pum#completed_item)
call ddc#enable()

lua << EOF
local mason = require('mason')
mason.setup({
  ui = {
    icons = {
      package_installed = "✓",
      package_pending = "➜",
      package_uninstalled = "✗"
    }
  }
})

local nvim_lsp = require('lspconfig')
local mason_lspconfig = require('mason-lspconfig')
mason_lspconfig.setup_handlers({ function(server_name)
  local opts = {}
  opts.on_attach = function(_, bufnr)
    local bufopts = { silent = true, buffer = bufnr }
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
    vim.keymap.set('n', 'gtD', vim.lsp.buf.type_definition, bufopts)
    vim.keymap.set('n', 'grf', vim.lsp.buf.references, bufopts)
    vim.keymap.set('n', 'g<space>p', vim.lsp.buf.format, bufopts)
 end
  nvim_lsp[server_name].setup(opts)
end })
EOF

"Settings for Plugin.
let g:NERDTreeWinSize=15

" Settings for lsp. Show the result of static analysis or linter.
set completeopt+=noinsert
let g:lsp_diagnostics_enabled = 1
let g:lsp_diagnostics_echo_cursor = 1
let g:lsp_text_edit_enabled = 1
let g:lsp_diagnostics_virtual_text_enabled = 0
highlight link LspErrorHighlight Error

set cursorline
set cursorcolumn
set ruler
set fileencodings=utf-8,iso-2022-jp,euc-jp,sjis
set history=1000
set showcmd " Display the incomplete commands in the bottom right-hand side of your screen.  
set hlsearch
set scrolloff=5 " Show a few lines of context around the cursor
set incsearch
set ignorecase
set smartcase " Override the 'ignorecase' option if the search pattern contains upper case characters.
set number
set nobackup
set noswapfile
set linebreak " Don't line wrap mid-word.
set expandtab " Use spaces instead of tabs
set autoindent
set smartindent 
set smarttab
set shiftwidth=4
set tabstop=4
let mapleader = "\<Space>" " Allocate space key to <leader>
map <leader>w :w!<cr> " Quickly save your file.
nnoremap <Leader>o :Files<CR> " Quickly open the file with fzf.
nnoremap <Leader>h :History<CR>

" この設定でデフォルトの補完が表示されなくなる
inoremap <C-n>   <Cmd>call pum#map#insert_relative(+1)<CR>
inoremap <C-p>   <Cmd>call pum#map#insert_relative(-1)<CR>
inoremap <C-y>   <Cmd>call pum#map#confirm()<CR>
inoremap <C-e>   <Cmd>call pum#map#cancel()<CR>
inoremap <PageDown> <Cmd>call pum#map#insert_relative_page(+1)<CR>
inoremap <PageUp>   <Cmd>call pum#map#insert_relative_page(-1)<CR>

"For Snippet expand https://github.com/hrsh7th/vim-vsnip
imap <expr> <C-j>   vsnip#expandable()  ? '<Plug>(vsnip-expand)'         : '<C-j>'
smap <expr> <C-j>   vsnip#expandable()  ? '<Plug>(vsnip-expand)'         : '<C-j>'
" Expand or jump to next inputable attribute or something
imap <expr> <C-l>   vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : '<C-l>'
smap <expr> <C-l>   vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : '<C-l>'
" Jump forward or backward (#pumのtab complettionと競合するので条件分岐追加 )
imap <expr> <Tab>   vsnip#jumpable(1)   ? '<Plug>(vsnip-jump-next)'      : pum#visible() ? '<Cmd>call pum#map#confirm()<CR>' : '<Tab>'
smap <expr> <Tab>   vsnip#jumpable(1)   ? '<Plug>(vsnip-jump-next)'      : pum#visible() ? '<Cmd>call pum#map#confirm()<CR>' : '<Tab>'
imap <expr> <S-Tab> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)'      : '<S-Tab>'
smap <expr> <S-Tab> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)'      : '<S-Tab>'

" Quickly yank and paste with OS clip board. 
vmap <Leader>y "+y
vmap <Leader>d "+d
nmap <Leader>p "+p
nmap <Leader>P "+P
vmap <Leader>p "+p
vmap <Leader>P "+P

:imap jk <Esc>
:imap kj <Esc>

nmap <silent> <Esc><Esc> :nohlsearch<CR> " remove highlight
nnoremap <silent><C-e> :NERDTreeToggle<CR>

map <leader>s <Plug>(easymotion-bd-f2)
nmap <leader>s <Plug>(easymotion-overwin-f2)

" For html tag jump (<div>-></div>)
:runtime macros/matchit.vim

"" Color config
colorscheme molokai
"syntax on
"set t_Co=256
" Need below lines for molokai
hi Search ctermbg=Gray
hi Search ctermfg=Black
set backspace=indent,eol,start
