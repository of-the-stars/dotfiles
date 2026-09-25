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
