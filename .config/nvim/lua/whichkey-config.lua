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
