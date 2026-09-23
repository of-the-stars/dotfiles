-- Check to see if it's running with nix
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

vim.loader.enable()

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.g.have_nerd_font = using_nix()

vim.opt.showmode = false

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
-- vim.keymap.set("n", "<leader>e", "<cmd>Neotree toggle<cr> ", { desc = "Open file explorer" })
vim.keymap.set('n', '<leader>[', '<ESC>', {})

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

-- Plugin config

install 'catppuccin/nvim'
require('catppuccin').setup {
  flavour = 'mocha',
  float = {
    transparent = true,
    solid = true,
  },
  color_overrides = {
    mocha = {
      base = '#11111b',
    },
  },
}
vim.cmd.colorscheme 'catppuccin-nvim'

install 'nvim-mini/mini.nvim'
local mini_icons = require 'mini.icons'
mini_icons.mock_nvim_web_devicons()
local statusline = require 'mini.statusline'
statusline.section_location = function()
  return '%2l:%-2v'
end
statusline.section_fileinfo = function()
  return string.format('%s%s[%s]', vim.bo.filetype .. ' ', vim.bo.fileencoding or vim.bo.encoding, vim.bo.fileformat)
end
statusline.setup {
  use_icons = vim.g.have_nerd_font,
  config = function()
    local mode, mode_hl = statusline.section_mode { trunc_width = 120 }
    local git = statusline.section_git { trunc_width = 40 }
    local diff = statusline.section_diff { trunc_width = 75 }
    local filename = statusline.section_filename { trunc_width = 140 }
    local fileinfo = statusline.section_fileinfo
    local location = statusline.section_location
    local search = statusline.section_searchcount { trunc_width = 75 }

    return statusline.combine_groups {
      { hl = mode_hl, strings = { mode } },
      { hl = 'MiniStatuslineDevinfo', strings = { git, diff } },
      '%<', -- Mark general truncate point
      { hl = 'MiniStatuslineFilename', strings = { filename } },
      '%=', -- End left alignment
      { hl = 'MiniStatuslineFileinfo', strings = { fileinfo } },
      { hl = mode_hl, strings = { search, location } },
    }
  end,
}
local mini_files = require 'mini.files'
vim.keymap.set('n', '<leader>fe', '<cmd>lua MiniFiles.open()<cr>', { desc = 'Open Mini Files explorer' })
mini_files.setup()
require('mini.comment').setup()
require('mini.tabline').setup()

install 'goolord/alpha-nvim'
local alpha = require 'alpha'
local dashboard = require 'alpha.themes.dashboard'
vim.keymap.set('n', '<leader>h', '<cmd>Alpha<cr>')
dashboard.section.header.val = {
  '           ^           ',
  '          /☄\\         ',
  '         /☼★☆\\        ',
  '        /☆☼⚧★☽\\       ',
  '   -----------------   ',
  '    %&Q ^     ^ 9@&    ',
  '    o8|   ov    |8o    ',
  '    Qo|     3   |9P    ',
  '    gB\\_________/cB    ',
  '    q%            P%    ',
  '                        ',
}
dashboard.section.buttons.val = {
  dashboard.button('SPC n', '> New file'),
  dashboard.button('SPC f e', '> Open file explorer'),
  dashboard.button('SPC f f', '> Fuzzy find file'),
  dashboard.button('SPC f r', '> Fuzzy find recent file'),
  dashboard.button('SPC f g', '> Find word in working directory'),
  dashboard.button('SPC z', '> Change directory with `zoxide`'),
  dashboard.button('SPC h', '> Open this window again'),
  dashboard.button('SPC q', '> Quit window'),
}
alpha.setup(dashboard.opts)

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
require('which-key').setup()
require('which-key').add {
  { '<leader>c', group = '[C]ode' },
  { '<leader>c_', hidden = true },
  { '<leader>d', group = '[D]ocument' },
  { '<leader>d_', hidden = true },
  { '<leader>r', group = '[R]ename' },
  { '<leader>r_', hidden = true },
  { '<leader>f', group = '[F]ind' },
  { '<leader>s_', hidden = true },
  { '<leader>t', group = '[T]erminal' },
  { '<leader>t_', hidden = true },
  -- { '<leader>w', group = '[W]orkspace' },
  -- { '<leader>w_', hidden = true },
  { '<leader>g', group = '[G]it' },
  { '<leader>g_', hidden = true },
  {
    mode = { 'v' },
    { '<leader>g', group = '[G]it' },
    { '<leader>g_', hidden = true },
  },
  vim.keymap.set('n', '<leader>?', '<cmd>WhichKey<cr>', { desc = 'Show keybinds with WhichKey' }),
}

install 'nvim-lua/plenary.nvim'

install 'nvim-telescope/telescope.nvim'
local telescope = require 'telescope'
telescope.setup {
  pickers = {
    live_grep = {
      additional_args = { '--hidden', '--ignore-vcs' },
    },
  },
  extensions = {
    ['ui-select'] = {
      require('telescope.themes').get_dropdown(),
    },
  },
}
pcall(telescope.load_extension, 'fzf')
pcall(telescope.load_extension, 'ui-select')
local telescope_builtin = require 'telescope.builtin'
vim.keymap.set('n', '<leader>fh', telescope_builtin.help_tags, { desc = '[F]ind [H]elp' })
vim.keymap.set('n', '<leader>fk', telescope_builtin.keymaps, { desc = '[F]ind [K]eymaps' })
vim.keymap.set('n', '<leader>ff', telescope_builtin.find_files, { desc = '[F]ind [F]iles' })
vim.keymap.set('n', '<leader>fa', function()
  telescope_builtin.find_files { hidden = true }
end, { desc = '[F]ind [A]ll files ' })
vim.keymap.set('n', '<leader>fs', telescope_builtin.builtin, { desc = '[F]ind [S]elect Telescope' })
vim.keymap.set('n', '<leader>fw', telescope_builtin.grep_string, { desc = '[F]ind in current [W]ord' })
vim.keymap.set('n', '<leader>fg', telescope_builtin.live_grep, { desc = '[F]ind by [G]rep' })
vim.keymap.set('n', '<leader>fd', telescope_builtin.diagnostics, { desc = '[F]ind [D]iagnostics' })
vim.keymap.set('n', '<leader>fr', function()
  telescope_builtin.oldfiles { only_cwd = true }
end, { desc = '[F]ind [R]ecent Files ("." for repeat)' })
vim.keymap.set('n', '<leader>ft', telescope_builtin.treesitter, { desc = '[F]ind in [T]reesitter' })
vim.keymap.set('n', '<leader><leader>', telescope_builtin.buffers, { desc = '[ ] Find existing buffers' })
vim.keymap.set('n', '<leader>/', function()
  telescope_builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
    winblend = 10,
    previewer = false,
  })
end, { desc = '[/] Fuzzily search in current buffer' })
vim.keymap.set('n', '<leader>f/', function()
  telescope_builtin.live_grep {
    grep_open_files = true,
    prompt_title = 'Live Grep in Open Files',
  }
end, { desc = '[F]ind [/] in Open Files' })
vim.keymap.set('n', '<leader>fn', function()
  telescope_builtin.find_files { cwd = vim.fn.stdpath 'config' }
end, { desc = '[F]ind [N]eovim files' })

install 'saghen/blink.cmp'
require('blink.cmp').setup {
  keymap = {
    ['<C-space>'] = { 'show', 'show_documentation', 'hide_documentation' },
    ['<C-e>'] = { 'hide', 'fallback' },
    ['<Enter>'] = { 'select_and_accept', 'fallback' },

    ['<Up>'] = { 'select_prev', 'fallback' },
    ['<Down>'] = { 'select_next', 'fallback' },
    ['<C-p>'] = { 'select_prev', 'fallback_to_mappings' },
    ['<C-n>'] = { 'select_next', 'fallback_to_mappings' },

    ['<C-b>'] = { 'scroll_documentation_up', 'fallback' },
    ['<C-f>'] = { 'scroll_documentation_down', 'fallback' },

    ['<Tab>'] = { 'snippet_forward', 'fallback' },
    ['<S-Tab>'] = { 'snippet_backward', 'fallback' },

    ['<C-k>'] = { 'show_signature', 'hide_signature', 'fallback' },
  },
  appearance = {
    -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
    -- Adjusts spacing to ensure icons are aligned
    nerd_font_variant = 'mono',
  },
  completion = {
    documentation = { auto_show = true },
    menu = {
      draw = {
        components = {
          kind_icon = {
            text = function(ctx)
              local kind_icon, _, _ = require('mini.icons').get('lsp', ctx.kind)
              return kind_icon
            end,
            -- (optional) use highlights from mini.icons
            highlight = function(ctx)
              local _, hl, _ = require('mini.icons').get('lsp', ctx.kind)
              return hl
            end,
          },
          kind = {
            -- (optional) use highlights from mini.icons
            highlight = function(ctx)
              local _, hl, _ = require('mini.icons').get('lsp', ctx.kind)
              return hl
            end,
          },
        },
      },
    },
  },
  sources = {
    default = { 'lsp', 'path', 'snippets', 'buffer' },
  },
  fuzzy = { implementation = 'prefer_rust_with_warning' },
}

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
conform = require 'conform'
conform.setup {
  formatters_by_ft = {
    lua = { 'stylua' },
    nix = { 'nixfmt' },
    typst = { 'typstyle' },
  },
  format_on_save = {
    -- These options will be passed to conform.format()
    timeout_ms = 500,
    lsp_format = 'fallback',
  },
}
vim.keymap.set('n', '<leade>bf', function()
  conform.format { async = true, lsp_fallback = true }
end, { desc = '[B]uffer [F]ormat' })
vim.api.nvim_create_autocmd('BufWritePre', {
  pattern = '*',
  callback = function(args)
    conform.format { bufnr = args.buf }
  end,
})

install 'willothy/flatten.nvim'
require('flatten').setup()

install 'folke/lazydev.nvim'
require('lazydev').setup()

install 'nvim-treesitter/nvim-treesitter'
local treesitter = require 'nvim-treesitter'
treesitter.install {
  'bash',
  'c',
  'diff',
  'html',
  'lua',
  'lua',
  'luadoc',
  'markdown',
  'nix',
  'ron',
  'rust',
  'typst',
}
treesitter.setup {
  -- Directory to install parsers and queries to (prepended to `runtimepath` to have priority)
  install_dir = vim.fn.stdpath 'data' .. '/site',
  highlight = {
    enable = true,
  },
}
vim.api.nvim_create_autocmd('FileType', {
  pattern = { '<filetype>' },
  callback = function()
    vim.treesitter.start()
  end,
})

-- LSP!!!
vim.keymap.set('n', '<leader>ce', vim.diagnostic.open_float, { desc = 'Show diagnostic [E]rror messages' })
vim.keymap.set('n', '<leader>cq', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })
vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, { desc = '[C]ode [A]ction' })
vim.keymap.set('n', '<leader>cd', telescope_builtin.lsp_definitions, { desc = '[I]mplementation' })
vim.keymap.set('n', '<leader>ct', telescope_builtin.lsp_type_definitions, { desc = 'Type [D]efinition' })
vim.keymap.set('n', '<leader>csw', telescope_builtin.lsp_document_symbols, { desc = '[D]ocument [S]ymbols' })
vim.keymap.set('n', '<leader>csw', telescope_builtin.lsp_dynamic_workspace_symbols, { desc = 'Workspace [C]ode [S]ymbols' })
vim.keymap.set('n', '<leader>crn', vim.lsp.buf.rename, { desc = '[R]e[n]ame' })
vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, { desc = '[C]ode [A]ction' })

install 'neovim/nvim-lspconfig'
vim.lsp.enable 'lua_ls'
vim.lsp.enable 'nil_ls'
vim.lsp.enable 'nixd'
vim.lsp.config 'rust-analyzer'
vim.lsp.enable 'rust-analyzer'
vim.lsp.config['tinymist'] = {
  settings = {
    exportPdf = 'onSave',
    semanticTokens = 'disable',
  },
}
vim.lsp.enable 'tinymist'
vim.lsp.enable 'clangd'
