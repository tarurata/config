-- Begin plug configuration
vim.cmd [[
call plug#begin()
Plug 'mattn/emmet-vim'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'cohama/lexima.vim'
Plug 'tpope/vim-surround'
Plug 'scrooloose/nerdcommenter'
Plug 'jwalton512/vim-blade'
Plug 'ap/vim-css-color'
Plug 'tomasr/molokai'
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
Plug 'easymotion/vim-easymotion'
Plug 'Shougo/ddc.vim'
Plug 'vim-denops/denops.vim'
Plug 'prabirshrestha/vim-lsp'
Plug 'mattn/vim-lsp-settings'
Plug 'mattn/vim-lsp-icons'
Plug 'Shougo/pum.vim'
Plug 'Shougo/ddc-source-around'
Plug 'neovim/nvim-lspconfig'
Plug 'williamboman/mason.nvim'
Plug 'williamboman/mason-lspconfig.nvim'
Plug 'jose-elias-alvarez/null-ls.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'Shougo/ddc-source-nvim-lsp'
Plug 'LumaKernel/ddc-file'
Plug 'Shougo/ddc-matcher_head'
Plug 'Shougo/ddc-sorter_rank'
Plug 'Shougo/ddc-converter_remove_overlap'
Plug 'Shougo/ddc-ui-pum'
Plug 'github/copilot.vim'
Plug 'serenevoid/kiwi.nvim'
call plug#end()
]]

-- DDC settings
vim.cmd [[
call ddc#custom#patch_global('completionMenu', 'pum.vim')
call ddc#custom#patch_global('sources', [ 'nvim-lsp', 'around', 'file' ])
call ddc#custom#patch_global('sourceOptions', {
\ '_': {
\ 'matchers': ['matcher_head'],
\ 'sorters': ['sorter_rank'],
\ 'converters': ['converter_remove_overlap'],
\ },
\ 'nvim-lsp': {
\ 'mark': 'LSP',
\ 'forceCompletionPattern': '\.\w*|:\w*|->\w*',
\ },
\ 'around': {
\ 'mark': 'Around'
\ },
\ 'file': {
\ 'mark': 'file',
\ 'isVolatile': v:true,
\ 'forceCompletionPattern': '\S/\S*'
\ }
\})
call ddc#custom#patch_global('ui', 'pum')
call ddc#custom#patch_global('sourceParams', {
\ 'nvim-lsp': { 'kindLabels': { 'Class': 'c' } },
\})
call ddc#enable()
]]

-- Mason and LSP settings
require('mason').setup({
  ui = {
    icons = {
      package_installed = "✓",
      package_pending = "➜",
      package_uninstalled = "✗"
    }
  }
})

local null_ls = require("null-ls")
null_ls.setup({
  sources = {
    null_ls.builtins.formatting.black,
    null_ls.builtins.formatting.isort
  }
})

local nvim_lsp = require('lspconfig')
require('mason-lspconfig').setup_handlers({
  function(server_name)
    local opts = {}
    opts.on_attach = function(_, bufnr)
      local bufopts = { silent = true, buffer = bufnr }
      vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
      vim.keymap.set('n', 'gtD', vim.lsp.buf.type_definition, bufopts)
      vim.keymap.set('n', 'grf', vim.lsp.buf.references, bufopts)
      vim.keymap.set('n', 'g<space>p', vim.lsp.buf.format, bufopts)
    end
    nvim_lsp[server_name].setup(opts)
  end
})

-- Autocommand for formatting Python files
vim.cmd [[autocmd BufWritePre *.py lua vim.lsp.buf.format()]]

-- Key mappings for PUM
vim.api.nvim_set_keymap('i', '<TAB>', 'pum#visible() ? "<Cmd>call pum#map#confirm()<CR>" : "<TAB>"', { noremap = true, silent = true, expr = true })
vim.api.nvim_set_keymap('i', '<C-n>', '<Cmd>call pum#map#select_relative(+1)<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('i', '<C-p>', '<Cmd>call pum#map#select_relative(-1)<CR>', { noremap = true, silent = true })

-- LSP and diagnostic settings
vim.o.completeopt = "menuone,noselect"
vim.g.lsp_diagnostics_enabled = 1
vim.g.lsp_diagnostics_echo_cursor = 1
vim.g.lsp_text_edit_enabled = 0
vim.g.lsp_diagnostics_virtual_text_enabled = 0
vim.cmd [[highlight link LspErrorHighlight Error]]
vim.cmd [[highlight link LspWarningHighlight Error]]

-- General settings
vim.o.cursorline = true
vim.o.cursorcolumn = true
vim.o.ruler = true
vim.o.history = 1000
vim.o.showcmd = true
vim.o.hlsearch = true
vim.o.scrolloff = 5
vim.o.incsearch = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.number = true
vim.o.backup = false
vim.o.swapfile = false
vim.o.linebreak = true
vim.o.expandtab = true
vim.o.autoindent = true
vim.o.smartindent = true
vim.o.smarttab = true
vim.o.shiftwidth = 4
vim.o.tabstop = 4
vim.g.mapleader = " "

-- Key mappings for general usage
vim.api.nvim_set_keymap('n', '<leader>w', ':w!<cr>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>o', ':Files<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>h', ':History<CR>', { noremap = true, silent = true })

-- Key mappings for LSP
vim.api.nvim_set_keymap('n', '<Leader>ld', ':LspDefinition<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Leader>bp', ':bp<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Leader>lh', ':LspHover<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Leader>lr', ':LspReferences<CR>', { noremap = true, silent = true })

-- Clipboard key mappings
vim.api.nvim_set_keymap('v', '<Leader>y', '"+y', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<Leader>d', '"+d', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Leader>p', '"+p', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<Leader>P', '"+P', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<Leader>p', '"+p', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<Leader>P', '"+P', { noremap = true, silent = true })

-- Remap Esc key combinations
vim.api.nvim_set_keymap('i', 'jk', '<Esc>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('i', 'kj', '<Esc>', { noremap = true, silent = true })

-- Disable search highlight
vim.api.nvim_set_keymap('n', '<Esc><Esc>', ':nohlsearch<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<C-e>', ':NERDTreeToggle<CR>', { noremap = true, silent = true })

-- EasyMotion mappings
vim.api.nvim_set_keymap('n', '<leader>s', '<Plug>(easymotion-bd-f2)', {})
vim.api.nvim_set_keymap('n', '<leader>s', '<Plug>(easymotion-overwin-f2)', {})

-- Matchit plugin
vim.cmd [[runtime macros/matchit.vim]]

-- Colorscheme settings
vim.cmd [[colorscheme molokai]]
vim.cmd [[syntax on]]
vim.o.backspace = "indent,eol,start"

-- Journal header shortcut
vim.api.nvim_exec([[
function! Date()
  return strftime('%y_%m_%d_%a')
endfunction
nnoremap <silent> <leader>d :call setline('.', Date())<CR>
]], false)

-- Kiwi.nvim setup
require('kiwi').setup({
  { name = "personal", path = "/Users/wata/Library/Mobile Documents/iCloud~md~obsidian/Documents/personal-wiki" },
  { name = "work", path = "/Users/wata/work-wiki" }
})

local kiwi = require('kiwi')
vim.keymap.set('n', '<leader>ww', kiwi.open_wiki_index, {})
vim.keymap.set('n', 'T', kiwi.todo.toggle, {})
vim.keymap.set('n', '<leader>wp', function() kiwi.open_wiki_index("personal", "Open index of personal wiki") end, {})

-- Temporary bypass for kiwi.nvim issue
local utils = require'kiwi.utils'
local is_windows = vim.loop.os_uname().version:match('Windows')

utils.get_relative_path = function (config)
  local relative_path = vim.fs.dirname(vim.fn.expand('%:p'))
  if is_windows then
    return relative_path:gsub(config.path:gsub("\\", "/"), "")
  else
    return ""
  end
end

-- Vale LSP setup
require'lspconfig'.vale_ls.setup{
  cmd = {"vale-ls"},
  filetypes = {"markdown", "tex", "text"},
  settings = {
    vale = {
      Path = "/usr/local/bin/vale"
    }
  }
}

-- Open or create daily file function
vim.api.nvim_exec([[
function! OpenOrCreateDailyFile()
    let l:today = strftime("%y_%m_%d")
    let l:yesterday = strftime("%y_%m_%d", localtime() - 86400)
    let l:path = expand('~/Library/Mobile Documents/iCloud~md~obsidian/Documents/personal-wiki/')
    let l:today_file = l:path . l:today . '.md'
    let l:yesterday_file = l:path . l:yesterday . '.md'

    if filereadable(l:today_file)
        execute 'edit ' . fnameescape(l:today_file)
    else
        if filereadable(l:yesterday_file)
            call system('cp ' . shellescape(l:yesterday_file) . ' ' . shellescape(l:today_file))
        else
            call system('touch ' . shellescape(l:today_file))
        endif
        execute 'edit ' . fnameescape(l:today_file)
        call setline(1, '# ' . strftime('%Y/%m/%d'))
        write
    endif
    set filetype=markdown
endfunction

if argc() == 1 && argv(0) == 'journal'
    autocmd VimEnter * call OpenOrCreateDailyFile()
endif
]], false)


-- Disable default rules for lexima.vim
vim.g.lexima_no_default_rules = true
vim.cmd('call lexima#set_default_rules()')
-- Add custom rule for square brackets. I need this to avoid duplicated spaces in parentheses.
vim.cmd([[
call lexima#add_rule({
    \ 'char': '[',
    \ 'at': '\[\]',
    \ 'input': '[',
    \ 'leave': ']',
    \ 'except': '\[.*\]'
})
]])
