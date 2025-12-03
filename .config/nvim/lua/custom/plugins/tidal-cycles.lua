return {
  {
    'tidalcycles/vim-tidal',
    enabled = require('nixCatsUtils').enableForCategory 'tidal-cycles',
    keys = {
      {
        '<leader>ms',
        '<cmd>TidalSend<cr>',
        desc = '[S]end line(s) to Tidal',
      },
      {
        '<leader>mh',
        '<cmd>TidalHush<cr>',
        desc = '[H]ush Tidal',
      },
    },
  },
}
