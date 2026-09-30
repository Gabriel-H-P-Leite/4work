-- Cyber config for lualine
-- Author: Capita1 
-- MIT license, see LICENSE for more details.

-- stylua: ignore
local colors = {
  blue   = '#79a2ac',
  cyan   = '#48c3c5',
  black  = '#240f16',
  white  = '#ffffff',
  red    = '#ee4f47',
  violet = '#d183e8',
  yellow = '#ffff00',
  grey   = '#12101d',
  none   = '#000000',
}

local Cyber = {
  normal = {
    a = { fg = colors.white, bg = colors.black},
    b = { fg = colors.cyan, bg = colors.grey },
    c = { bg = colors.none},
  },

  insert = { a = { fg = colors.yellow, bg = colors.black } },
  visual = { a = { fg = colors.blue, bg = colors.black } },
  replace = { a = { fg = colors.red, bg = colors.black } },

  inactive = {
    a = { fg = colors.white, bg = colors.black },
    b = { fg = colors.white, bg = colors.black },
    c = { fg = colors.none }, 
  },
}

require('lualine').setup {
  options = {
    theme = Cyber ,
    section_separators = { left = '', right = '' },
  },
  sections = {
    lualine_a = { { 'mode', right_padding = 2 } },
    lualine_b = { 'filename', 'branch' },
    lualine_c = {
      '%=', --[[ add your center components here in place of this comment ]]
    },
    lualine_x = {},
    lualine_y = { 'filetype'},
    lualine_z = {'progress','location'},
  },
  inactive_sections = {
    lualine_a = { 'filename' },
    lualine_b = {},
    lualine_c = {},
    lualine_x = {},
    lualine_y = {},
    lualine_z = { 'location' },
  },
  tabline = {},
  extensions = {},
}
