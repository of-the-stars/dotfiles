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
