-- Check to see if it's running with nixnvimini
local nix_nvim_runtime_path = os.getenv 'NIX_NVIM_RUNTIME_PATH'

-- Helper functions
local function using_nix()
  return nix_nvim_runtime_path and true or false
end

local function gh(repo)
  return 'https://github.com/' .. repo
end

local function install(repo)
  local plugin = gh(repo)
  if not using_nix() then
    vim.pack.add { plugin }
  end
end

-- If running with nix, tell it where to find plugins
if using_nix() then
  vim.opt.runtimepath:prepend(nix_nvim_runtime_path)
end

-- TODO: Make it so that I can instead just change where the lockfile is
-- https://github.com/neovim/neovim/pull/40562
-- It seems that this will be implemented in 0.13, so I'll work around it for now

vim.g.have_nerd_font = using_nix()

vim.loader.enable()

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.g.editorconfig = true

vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.clipboard = 'unnamedplus'

vim.opt.breakindent = true

vim.opt.undofile = true

vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.signcolumn = 'yes'

vim.opt.updatetime = 250

vim.opt.timeoutlen = 300

vim.opt.splitright = true
vim.opt.splitbelow = true

vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

vim.opt.inccommand = 'split'

vim.opt.cursorline = false

vim.opt.scroll = 10
vim.opt.scrolloff = 15

vim.opt.hlsearch = true
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

vim.opt.path:prepend(vim.fn.expand '%:p:h')

vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Keybinds to make navigation easier
vim.keymap.set({ 'n', 'v' }, 'j', 'gj') -- Swaps normal 'j' and 'gj' functionality
vim.keymap.set({ 'n', 'v' }, 'gj', 'j')

vim.keymap.set({ 'n', 'v' }, 'k', 'gk') -- Swaps normal 'k' and 'gk' functionality
vim.keymap.set({ 'n', 'v' }, 'gk', 'k')

vim.keymap.set({ 'n', 'v' }, 'H', 'g^') -- Sets 'H' to go to the beginning of the visual line
vim.keymap.set({ 'n', 'v' }, 'L', 'g$') -- Sets 'L' to go to the end of the visual line

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- Keybinds to make managing windows easier
vim.keymap.set('n', '<leader>sv', '<cmd>vsplit<cr>', { desc = 'Split window vertically' })
vim.keymap.set('n', '<leader>sh', '<cmd>split<cr>', { desc = 'Split window horizontally' })
vim.keymap.set('n', '<leader>q', '<cmd>q<cr>', { desc = 'Quit window' })
vim.keymap.set('n', '<leader>Q', '<cmd>q!<cr>', { desc = 'Quit window without saving' })
vim.keymap.set('n', '<leader>w', '<cmd>w<cr>', { desc = 'Write buffer' })
vim.keymap.set('n', '<leader>nw', '<cmd>noa w<cr>', { desc = 'Write buffer with no autocommands' })
vim.keymap.set('n', '<leader>bd', '<cmd>bd<cr>', { desc = 'Delete buffer' })
vim.keymap.set('n', '<leader>[', '<ESC>', {})

vim.keymap.set('n', 'gf', function()
  local file = vim.bo.filetype == 'markdown' and vim.fn.expand '<cexpr>' or vim.fn.expand '<cfile>'

  local replaced_file = string.gsub(file, '%%20', ' ')

  local ok, _ = pcall(vim.cmd.edit, replaced_file)

  if not ok then
    vim.cmd 'normal! gf'
  end
end)

-- Set whitespace rules
vim.o.tabstop = 4 -- A TAB character looks like 4 spaces
vim.o.expandtab = true -- Pressing the TAB key will insert spaces instead of a TAB character
vim.o.softtabstop = 4 -- Number of spaces inserted instead of a TAB character
vim.o.shiftwidth = 4 -- Number of spaces inserted when indenting
vim.opt.wrap = true -- Sets text to wrap
vim.opt.linebreak = true -- Sets text to wrap around whitespace

vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('highlight-yank', { clear = true }),
  callback = function()
    vim.hl.on_yank()
  end,
})

-- Custom lua files
require 'netrw'

-- Plugin config

install 'catppuccin/nvim'
require 'catppuccin-config'

install 'nvim-mini/mini.nvim'
require 'mini-config'

install 'goolord/alpha-nvim'
require 'alpha-nvim-config'

install 'akinsho/toggleterm.nvim'
require('toggleterm').setup {
  size = function(term)
    if term.direction == 'horizontal' then
      return 15
    elseif term.direction == 'vertical' then
      return vim.o.columns * 0.4
    end
  end,
  open_mapping = [[<C-\>]],
  insert_mappings = false,
  terminal_mappings = false,
  autochdir = true,
  direction = 'horizontal',
  close_on_exit = true,
}
vim.keymap.set('n', '<leader>tf', '<cmd>ToggleTerm direction=float<cr>', { desc = 'Toggle terminal in floating window' })
vim.keymap.set('n', '<leader>tv', '<cmd>ToggleTerm direction=vertical<cr>', { desc = 'Toggle terminal in vertical window' })
local Terminal = require('toggleterm.terminal').Terminal
local lazygit = Terminal:new {
  cmd = 'lazygit',
  direction = 'float',
  hidden = true,
}
function _lazygit_toggle()
  lazygit:toggle()
end
vim.keymap.set('n', '<leader>gl', '<cmd>lua _lazygit_toggle()<cr>', { noremap = true, silent = true, desc = 'Open LazyGit' })

install 'folke/which-key.nvim'
require 'whichkey-config'

install 'nvim-lua/plenary.nvim'

install 'nvim-telescope/telescope.nvim'
require 'telescope-config'

install 'saghen/blink.cmp'
require 'blink-cmp-config'

install 'lewis6991/gitsigns.nvim'
require('gitsigns').setup {
  signs = {
    add = { text = '+' },
    change = { text = '~' },
    delete = { text = '_' },
    topdelete = { text = '‾' },
    changedelete = { text = '~' },
  },
}

install 'stevearc/conform.nvim'
require 'conform-config'

install 'willothy/flatten.nvim'
require('flatten').setup()

install 'folke/lazydev.nvim'
require('lazydev').setup()

install 'nvim-treesitter/nvim-treesitter'
require 'nvim-treesitter-config'

-- LSP!!!
install 'neovim/nvim-lspconfig'
require 'lsp-config'
