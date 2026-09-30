--NVIM config
vim.wo.wrap = false
vim.wo.number = true  
vim.opt.relativenumber = true
vim.opt.smartindent = true
vim.g.have_nerd_font = true

--LAZY configuração dos plugins 
require("config.lazy")
--LSP server
require'lspconfig'.pyright.setup{}
vim.cmd [[
	highlight Normal guibg=none
	highlight NonText guibg=none
	highlight Normal ctermbg=none
	highlight NonText ctermbg=none
]]

--TEMA BARRA
require ('config.cyber')
