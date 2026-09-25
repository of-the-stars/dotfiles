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
