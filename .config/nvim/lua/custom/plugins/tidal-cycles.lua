return {
  {
    'tidalcycles/vim-tidal',
    enabled = require('nixCatsUtils').enableForCategory 'tidal-cycles',
    event = 'VimEnter',
    config = function()
      local on_exit = function(obj)
        print(obj.code)
        print(obj.signal)
        print(obj.stdout)
        print(obj.stderr)
      end
      local superdirt = vim.system({ 'superdirt-start' }, {
        detach = false,
      }, on_exit)
      print('Superdirt Started; PID: ' .. superdirt.pid)
    end,
  },
}
