local mini_icons = require 'mini.icons'
mini_icons.mock_nvim_web_devicons()
local statusline = require 'mini.statusline'
statusline.section_location = function()
  return '%2l:%-2v'
end
statusline.section_fileinfo = function()
  return string.format('%s%s[%s]', vim.bo.filetype .. ' ', vim.bo.fileencoding or vim.bo.encoding, vim.bo.fileformat)
end
statusline.setup {
  use_icons = vim.g.have_nerd_font,
  config = function()
    local mode, mode_hl = statusline.section_mode { trunc_width = 120 }
    local git = statusline.section_git { trunc_width = 40 }
    local diff = statusline.section_diff { trunc_width = 75 }
    local filename = statusline.section_filename { trunc_width = 140 }
    local fileinfo = statusline.section_fileinfo
    local location = statusline.section_location
    local search = statusline.section_searchcount { trunc_width = 75 }

    return statusline.combine_groups {
      { hl = mode_hl, strings = { mode } },
      { hl = 'MiniStatuslineDevinfo', strings = { git, diff } },
      '%<', -- Mark general truncate point
      { hl = 'MiniStatuslineFilename', strings = { filename } },
      '%=', -- End left alignment
      { hl = 'MiniStatuslineFileinfo', strings = { fileinfo } },
      { hl = mode_hl, strings = { search, location } },
    }
  end,
}
local mini_files = require 'mini.files'
vim.keymap.set('n', '<leader>fe', '<cmd>lua MiniFiles.open()<cr>', { desc = 'Open Mini Files explorer' })
mini_files.setup()
require('mini.comment').setup()
require('mini.tabline').setup()
