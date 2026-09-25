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
