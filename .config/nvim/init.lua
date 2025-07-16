-- This file simply bootstraps the installation of Lazy.nvim and then calls other files for execution
-- This file doesn't necessarily need to be touched, BE CAUTIOUS editing this file and proceed at your own risk.
local lazypath = vim.env.LAZY or vim.fn.stdpath "data" .. "/lazy/lazy.nvim"
if not (vim.env.LAZY or (vim.uv or vim.loop).fs_stat(lazypath)) then
  -- stylua: ignore
  vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath })
end
vim.opt.rtp:prepend(lazypath)

-- require("mason").setup {
--   PATH = "append",
-- }

-- validate that lazy is available
if not pcall(require, "lazy") then
  -- stylua: ignore
  vim.api.nvim_echo({ { ("Unable to load lazy from: %s\n"):format(lazypath), "ErrorMsg" }, { "Press any key to exit...", "MoreMsg" } }, true, {})
  vim.fn.getchar()
  vim.cmd.quit()
end

require "lazy_setup"
require "polish"

vim.api.nvim_set_option("clipboard", "unnamed")

vim.o.tabstop = 4 -- A TAB character looks like 4 spaces
vim.o.expandtab = true -- Pressing the TAB key will insert spaces instead of a TAB character
vim.o.softtabstop = 4 -- Number of spaces inserted instead of a TAB character
vim.o.shiftwidth = 4 -- Number of spaces inserted when indenting
vim.opt.wrap = true -- Sets text to wrap

-- internet_wizard's custom keybindings
vim.keymap.set({ "n", "v" }, "j", "gj") -- Swaps normal 'j' and 'gj' functionality
vim.keymap.set({ "n", "v" }, "gj", "j")

vim.keymap.set({ "n", "v" }, "k", "gk") -- Swaps normal 'k' and 'gk' functionality
vim.keymap.set({ "n", "v" }, "gk", "k")

vim.keymap.set({ "n", "v" }, "H", "g^") -- Sets 'H' to go to the beginning of the visual line

vim.keymap.set({ "n", "v" }, "L", "g$") -- Sets 'L' to go to the end of the visual line

vim.api.nvim_set_keymap("t", "<Leader><ESC>", "<C-\\><C-n>", { noremap = true }) -- Lets you use <Esc> to return back to normal mode from the terminal

vim.g.rustaceanvim = {
  -- Plugin configuration
  tools = {},
  -- LSP configuration
  server = {
    on_attach = function(client, bufnr)
      -- you can also put keymaps in here
    end,
    default_settings = {
      -- rust-analyzer language server configuration
      ["rust-analyzer"] = {
        ["overrideCommand"] = { "leptosfmt", "--stdin", "--rustfmt" },
      },
    },
  },
  -- DAP configuration
  dap = {},
}
