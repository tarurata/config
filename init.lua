-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Set leader keys
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Setup lazy.nvim
require("lazy").setup({
  { "mattn/emmet-vim" },                    -- Emmet for HTML and CSS expansion
  { "cohama/lexima.vim" },                  -- Auto-close parentheses, quotes, etc.
  { "tpope/vim-surround" },                 -- Easily delete, change and add surroundings in pairs
  { "scrooloose/nerdcommenter" },           -- Easy commenting of code for various languages
  { "scrooloose/nerdtree" },                -- File system explorer
  { "ap/vim-css-color" },                   -- Preview colors in source code
  { "tomasr/molokai" },                     -- Molokai color scheme
  { "junegunn/fzf" },                       -- Fuzzy finder
  { "junegunn/fzf.vim" },                   -- Fuzzy finder Vim integration
  { "easymotion/vim-easymotion" },          -- Vim motions on speed
  { "Shougo/ddc.vim" },                     -- Dark powered asynchronous completion framework
  { "vim-denops/denops.vim" },              -- Vim/Neovim plugin framework written in Deno
  { "Shougo/pum.vim" },                     -- Popup menu for Vim
  { "Shougo/ddc-source-around" },           -- Around source for ddc.vim
  { "Shougo/ddc-source-lsp" },              -- LSP source for ddc.vim
  { "neovim/nvim-lspconfig" },              -- Quickstart configs for Nvim LSP
  { "williamboman/mason.nvim" },            -- Portable package manager for Neovim
  { "williamboman/mason-lspconfig.nvim" },  -- Bridge between mason.nvim and lspconfig
  { "jose-elias-alvarez/null-ls.nvim" },    -- Use Neovim as a language server
  { "nvim-lua/plenary.nvim" },              -- Lua functions library
  { "LumaKernel/ddc-file" },                -- File source for ddc.vim
  { "Shougo/ddc-matcher_head" },            -- Head matcher for ddc.vim
  { "Shougo/ddc-sorter_rank" },             -- Rank sorter for ddc.vim
  { "Shougo/ddc-converter_remove_overlap" },-- Overlap remover for ddc.vim
  { "Shougo/ddc-ui-pum" },                  -- Popup menu UI for ddc.vim
  { "folke/noice.nvim" },                   -- Highly experimental plugin that replaces the UI for messages, cmdline and the popupmenu
  { "MunifTanjim/nui.nvim" },               -- UI Component Library for Neovim
  { "github/copilot.vim" },                 -- GitHub Copilot for Vim
  { "serenevoid/kiwi.nvim", commit = "47894404ca554d48f4e3f1e0bd59642464ca539f" }, -- Neovim plugin for note-taking and personal wiki
  { "rhysd/vim-startuptime" },              -- Measure startup time of Vim
  { "ellisonleao/gruvbox.nvim", priority = 1000 },
}, {
--  install = { colorscheme = { "gruvbox" } },
  checker = { enabled = true },
})

-- Noice setup
require("noice").setup()

-- Mason and LSP settings
require('mason').setup({
  ui = {
    icons = {
      package_installed = "⭕",
      package_pending = "➡️",
      package_uninstalled = "❌"
    }
  }
})

require('mason-lspconfig').setup()

local nvim_lsp = require('lspconfig')
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('ddc_source_lsp').make_client_capabilities(capabilities)

require('mason-lspconfig').setup_handlers({
  function(server_name)
    local opts = {
      capabilities = capabilities,
      on_attach = function(_, bufnr)
        local bufopts = { silent = true, buffer = bufnr }
        vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
        vim.keymap.set('n', 'gtD', vim.lsp.buf.type_definition, bufopts)
        vim.keymap.set('n', 'grf', vim.lsp.buf.references, bufopts)
        vim.keymap.set('n', 'g<space>p', vim.lsp.buf.format, bufopts)
      end
    }
    nvim_lsp[server_name].setup(opts)
  end
})

-- DDC settings
vim.fn['ddc#custom#patch_global']('ui', 'pum')
vim.fn['ddc#custom#patch_global']('sources', { 'lsp', 'around', 'file' })
vim.fn['ddc#custom#patch_global']('sourceOptions', {
  ['_'] = { -- Default options for all sources
    matchers = { 'matcher_head' },
    sorters = { 'sorter_rank' },
    converters = { 'converter_remove_overlap' },
  },
  ['lsp'] = {
    mark = '🗣️',
    forceCompletionPattern = '\\.\\w*|:\\w*|->\\w*',
  },
  -- ['copilot'] = {
  --   mark = '🤖',
  --   Copilot also can be included to ddc.vim, but it requires to install ddc-source-copilot
  -- },
  ['around'] = {
    mark = '🌍',
  },
  ['file'] = {
    mark = '🗂️',
    isVolatile = true,
    forceCompletionPattern = '\\S/\\S*',
  },
})

vim.fn['ddc#custom#patch_global']('sourceParams', {
  ['lsp'] = {
    snippetEngine = vim.fn['denops#callback#register'](function(body)
      return vim.fn['vsnip#anonymous'](body)
    end),
    enableResolveItem = true,
    enableAdditionalTextEdit = true,
  },
})

-- LSP capabilities for ddc
capabilities = require("ddc_source_lsp").make_client_capabilities()

-- Specific setup for denols
require('lspconfig').denols.setup({
  capabilities = capabilities,
})

vim.fn['ddc#enable']()

-- LSP settings for Make "vim" global variable available in Lua files
require('lspconfig').lua_ls.setup({
    settings = {
        Lua = {
            diagnostics = {
                globals = { 'vim' }
            }
        }
    }
})

-- Autocommand for formatting Python files
vim.cmd [[autocmd BufWritePre *.py lua vim.lsp.buf.format()]]

-- Key mappings for PUM
vim.api.nvim_set_keymap('i', '<C-l>', 'pum#visible() ? "<Cmd>call pum#map#confirm()<CR>" : "<C-Space>"', { noremap = true, silent = true, expr = true })
-- vim.api.nvim_set_keymap('i', '<C-n>', '<Cmd>call pum#map#select_relative(+1)<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('i', '<C-p>', '<Cmd>call pum#map#select_relative(-1)<CR>', { noremap = true, silent = true })

-- Copilot settings
vim.g.copilot_no_tab_map = true
vim.api.nvim_set_keymap('i', '<Tab>', 'copilot#Accept("<CR>")', { silent = true, expr = true })

-- LSP and diagnostic settings
vim.o.completeopt = "menuone,noselect"
vim.g.lsp_diagnostics_enabled = 1
vim.g.lsp_diagnostics_echo_cursor = 1
vim.g.lsp_text_edit_enabled = 0
vim.g.lsp_diagnostics_virtual_text_enabled = 1
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
vim.keymap.set('n', '<Leader>ld', vim.lsp.buf.definition, { desc = 'LSP go to definition' })
vim.keymap.set('n', '<Leader>bp', '<cmd>bp<CR>', { desc = 'Go to previous buffer' })
vim.keymap.set('n', '<Leader>lh', vim.lsp.buf.hover, { desc = 'LSP hover' })
vim.keymap.set('n', '<Leader>lr', vim.lsp.buf.references, { desc = 'LSP references' })

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

-- Matchit plugin. Jump to the matching characters or tags with %
vim.cmd [[runtime macros/matchit.vim]]

-- Colorscheme settings
vim.o.termguicolors = true -- Enable true color support
vim.api.nvim_command('hi Normal guibg=NONE ctermbg=NONE') -- Set the background to be transparent
vim.cmd [[colorscheme gruvbox]] -- If you're using a colorscheme, make sure to set it after these settings

-- Ensure the colorscheme doesn't override the transparent background
vim.api.nvim_command('hi Normal guibg=NONE ctermbg=NONE')
vim.api.nvim_command('hi NonText guibg=NONE ctermbg=NONE')
vim.api.nvim_command('hi LineNr guibg=NONE ctermbg=NONE')
vim.api.nvim_command('hi Folded guibg=NONE ctermbg=NONE')
vim.api.nvim_command('hi EndOfBuffer guibg=NONE ctermbg=NONE')
vim.o.termguicolors = true
vim.cmd [[syntax on]]
vim.o.backspace = "indent,eol,start" -- Make backspace behave more intuitively in insert mode

-- Kiwi.nvim setup
local kiwi = require('kiwi')
kiwi.setup({
  { name = "personal", path = "/Users/wata/Library/Mobile Documents/iCloud~md~obsidian/Documents/personal-wiki" },
  { name = "work", path = "/Users/wata/work-wiki" }
})

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
-- Highlight between ** and ** | Ignore underscore in words
vim.cmd [[
  augroup MyMarkdownHighlights
    autocmd!
    autocmd FileType markdown syntax match MarkdownStrong /\*\*.\{-}\*\*/
    autocmd FileType markdown highlight MarkdownStrong guifg=#FF0000 ctermfg=red
    autocmd FileType markdown syntax match MarkdownError "\w\@<=\w\@="
  augroup END
]]

vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { noremap = true, silent = true })
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { noremap = true, silent = true }) -- Move to the previous diagnostic
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { noremap = true, silent = true }) -- Move to the next diagnostic
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { noremap = true, silent = true }) -- Show diagnostics in the location list
-- vim.cmd [[autocmd CursorHold,CursorHoldI * lua vim.diagnostic.open_float(nil, {focus=false})]] -- Show diagnostics automatically in hover window

-- Trigger `checktime` when changing buffers or coming back to vim in terminal.
vim.o.autoread = true
vim.o.updatetime = 250
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI" }, {
    command = "if mode() != 'c' | checktime | endif",
    pattern = { "*" },
})
