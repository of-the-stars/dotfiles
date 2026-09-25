local telescope_builtin = require 'telescope.builtin'

vim.keymap.set('n', '<leader>ce', vim.diagnostic.open_float, { desc = 'Show diagnostic [E]rror messages' })
vim.keymap.set('n', '<leader>cq', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })
vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, { desc = '[C]ode [A]ction' })
vim.keymap.set('n', '<leader>cd', telescope_builtin.lsp_definitions, { desc = '[I]mplementation' })
vim.keymap.set('n', '<leader>ct', telescope_builtin.lsp_type_definitions, { desc = 'Type [D]efinition' })
vim.keymap.set('n', '<leader>csw', telescope_builtin.lsp_document_symbols, { desc = '[D]ocument [S]ymbols' })
vim.keymap.set('n', '<leader>csw', telescope_builtin.lsp_dynamic_workspace_symbols, { desc = 'Workspace [C]ode [S]ymbols' })
vim.keymap.set('n', '<leader>crn', vim.lsp.buf.rename, { desc = '[R]e[n]ame' })
vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, { desc = '[C]ode [A]ction' })
vim.keymap.set('n', '<leader>cl', '<cmd>lsp enable<CR>', { desc = 'Enable [L]SP' })

vim.lsp.enable 'lua_ls'
vim.lsp.enable 'nil_ls'
vim.lsp.enable 'nixd'
vim.lsp.config['rust-analyzer'] = {
  settings = {
    ['rust-analyzer'] = {
      diagnostics = {
        enable = true,
      },
    },
  },
}
vim.lsp.enable 'rust-analyzer'
vim.lsp.config['tinymist'] = {
  settings = {
    exportPdf = 'onSave',
    semanticTokens = 'disable',
  },
}
vim.lsp.enable 'tinymist'
vim.lsp.enable 'clangd'
