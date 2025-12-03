return {
  {
    'tidalcycles/vim-tidal',
    enabled = require('nixCatsUtils').enableForCategory 'tidal-cycles',
    event = 'VimEnter',
    vim.api.nvim_create_autocmd('VimEnter', {
      group = vim.api.nvim_create_augroup('autocom', { clear = true }),
      pattern = '*.tidal',
      callback = function()
        vim.fn.system 'superdirt-start'
      end,
    }),
    config = function()
      -- vim.keymap.set({ 'n', 'v' }, '<leader>ms', '<cmd>TidalSend<cr>', {
      --   desc = '[S]end line(s) to Tidal',
      -- })
      --
      -- vim.keymap.set({ 'n', 'v' }, '<leader>mh', '<cmd>TidalHush<cr>', {
      --   desc = '[H]ush Tidal',
      -- })

      -- vim.keymap.set({ 'n', 'v' }, '<CTRL><CR>', '<cmd>TidalHush<cr>', {
      --   desc = '[H]ush Tidal',
      -- })
    end,
  },
}
