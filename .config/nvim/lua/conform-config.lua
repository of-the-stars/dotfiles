conform = require 'conform'
conform.setup {
  formatters_by_ft = {
    lua = { 'stylua' },
    nix = { 'nixfmt' },
    typst = { 'typstyle' },
  },
  format_on_save = {
    -- These options will be passed to conform.format()
    timeout_ms = 500,
    lsp_format = 'fallback',
  },
}
vim.keymap.set('n', '<leade>bf', function()
  conform.format { async = true, lsp_fallback = true }
end, { desc = '[B]uffer [F]ormat' })
vim.api.nvim_create_autocmd('BufWritePre', {
  pattern = '*',
  callback = function(args)
    conform.format { bufnr = args.buf }
  end,
})
