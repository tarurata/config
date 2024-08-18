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
Plug 'folke/noice.nvim'
Plug 'MunifTanjim/nui.nvim'
Plug 'github/copilot.vim'
Plug 'serenevoid/kiwi.nvim', { 'commit': '47894404ca554d48f4e3f1e0bd59642464ca539f' }
Plug 'rhysd/vim-startuptime'
call plug#end()
]]

-- Noice setup
require("noice").setup()

-- DDC settings
vim.fn['ddc#custom#patch_global']('completionMenu', 'pum.vim')
vim.fn['ddc#custom#patch_global']('sources', { 'around', 'file' })
-- vim.fn['ddc#custom#patch_global']('sources', { 'nvim-lsp', 'around', 'file' })
vim.fn['ddc#custom#patch_global']('sourceOptions', {
  ['_'] = {
    matchers = { 'matcher_head' },
    sorters = { 'sorter_rank' },
    converters = { 'converter_remove_overlap' },
  },
  ['nvim-lsp'] = {
    mark = 'LSP',
    forceCompletionPattern = '\\.\\w*|:\\w*|->\\w*',
  },
  ['around'] = {
    mark = 'Around',
  },
  ['file'] = {
    mark = 'file',
    isVolatile = true,
    forceCompletionPattern = '\\S/\\S*',
  },
})
vim.fn['ddc#custom#patch_global']('ui', 'pum')
vim.fn['ddc#custom#patch_global']('sourceParams', {
  ['nvim-lsp'] = { kindLabels = { Class = 'c' } },
})

vim.fn['ddc#enable']()

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
local function date()
    return os.date('%y_%m_%d_%a')
end
_G.date = date
vim.api.nvim_set_keymap('n', '<leader>d', ':lua vim.api.nvim_set_current_line(_G.date())<CR>', { noremap = true, silent = true })

-- Kiwi.nvim setup
require('kiwi').setup({
  { name = "personal", path = "/Users/wata/Library/Mobile Documents/iCloud~md~obsidian/Documents/personal-wiki" },
  { name = "work", path = "/Users/wata/work-wiki" }
})

local kiwi = require('kiwi')
vim.keymap.set('n', '<leader>ww', kiwi.open_wiki_index, {})
vim.keymap.set('n', 'T', kiwi.todo.toggle, {})
vim.keymap.set('n', '<leader>wp', function() kiwi.open_wiki_index("personal", "Open index of personal wiki") end, {})

--  Temporary bypass for kiwi.nvim issue
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
vim.env.VALE_CONFIG_PATH = "/Users/wata/.vale.ini" -- https://github.com/errata-ai/vale-ls/issues/4
local lspconfig = require('lspconfig')
lspconfig.vale_ls.setup({
  cmd = {"vale-ls"},
  filetypes = {"markdown", "tex", "text"},
  settings = {
    vale = {
      Vale = {
        cli = "/usr/local/bin/vale",
        MinAlertLevel = suggestion
      }
    }
  }
})

-- Open or create daily file function
local function open_or_create_daily_file()
    local today = os.date("%y_%m_%d")
    local yesterday = os.date("%y_%m_%d", os.time() - 86400)
    local path = vim.fn.expand('~/Library/Mobile Documents/iCloud~md~obsidian/Documents/personal-wiki/')
    local today_file = path .. today .. '.md'
    local yesterday_file = path .. yesterday .. '.md'
    local journal_file = path .. 'Journal.md'

    local function file_exists(file)
        local f = io.open(file, "r")
        if f then f:close() end
        return f ~= nil
    end

    if file_exists(today_file) then
        vim.cmd('edit ' .. vim.fn.fnameescape(today_file))
    else
        if file_exists(yesterday_file) then
            os.execute('cp ' .. vim.fn.shellescape(yesterday_file) .. ' ' .. vim.fn.shellescape(today_file))
        else
            os.execute('touch ' .. vim.fn.shellescape(today_file))
        end
        vim.cmd('edit ' .. vim.fn.fnameescape(today_file))
        vim.fn.setline(1, '# ' .. os.date('%Y/%m/%d'))
        vim.cmd('write')

        -- Add the new date entry to Journal.md
        local today_entry = '* [' .. today .. '](./' .. today .. '.md)'
        local journal_entry_cmd = 'echo ' .. vim.fn.shellescape(today_entry) .. ' >> ' .. vim.fn.shellescape(journal_file)
        os.execute(journal_entry_cmd)
    end
    vim.cmd('set filetype=markdown')
end

if #vim.fn.argv() == 1 and vim.fn.argv()[1] == 'journal' then
    vim.api.nvim_create_autocmd("VimEnter", {
        callback = open_or_create_daily_file
    })
end

-- Define custom highlight for strong text in markdown
vim.cmd [[
  augroup MyMarkdownHighlights
    autocmd!
    autocmd FileType markdown syntax match MarkdownStrong /\*\*.\{-}\*\*/
    autocmd FileType markdown highlight MarkdownStrong guifg=#FF0000 ctermfg=red
  augroup END
]]
