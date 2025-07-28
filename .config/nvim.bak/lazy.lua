return {
  "nvim-tree/nvim-tree.lua",
  version = "*",
  lazy = false,
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    require("nvim-tree").setup {}
  end,
}

## Example config to use lazy.nvim to setup lsp-zero.nvim with lua-ls installed as a system package in NixOS.

## in your NixOS config, include:
lua-language-server


## In your Neovim Lazy loader config, include:

local lsp_zero_config = {
    call_servers = 'global',
}

local lsp_servers = {
    'lua_ls',
}

local lua_ls_config = {
    settings = {
        Lua = {
            diagnostics = {globals = {'vim'}},
            runtime = {version = 'LuaJIT'},
            telemetry = {enable = false},
        },
    },
}

local function on_attach(_, bufnr)
	-- omitted for brevity
end

local diagnostics_config = {
	-- omitted for brevity
}

return {
    'VonHeikemen/lsp-zero.nvim',
    config = function()
        local lsp = require('lsp-zero')
        lsp.set_preferences(lsp_zero_config)

        lsp.configure('lua_ls', lua_ls_config)

        lsp.setup_servers(lsp_servers)
        lsp.on_attach(on_attach)
        lsp.setup()

        vim.diagnostic.config(diagnostics_config)
    end,
    dependencies = {
        {'neovim/nvim-lspconfig'},
    },
}
