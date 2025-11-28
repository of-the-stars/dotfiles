return {
  {
    'gruvw/strudel.nvim',
    enabled = require('nixCatsUtils').enableForCategory 'strudel',
    build = 'npm ci',
    config = function()
      require('strudel').setup()
    end,
  },
}
