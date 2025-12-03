return {
  {
    'tidalcycles/vim-tidal',
    enabled = require('nixCatsUtils').enableForCategory 'tidal-cycles',
    config = function()
      require('vim-tidal').setup()

      vim.keymap.set({ 'n', 'v' }, '<leader>ms', '<cmd>TidalSend<cr>', {
        desc = '[S]end line(s) to Tidal',
      })

      vim.keymap.set({ 'n', 'v' }, '<leader>mh', '<cmd>TidalHush<cr>', {
        desc = '[H]ush Tidal',
      })
    end,
  },
}
