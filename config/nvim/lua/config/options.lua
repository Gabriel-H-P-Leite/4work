local opt = vim.opt

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"
vim.g.have_nerd_font = true

-- Números e linhas
opt.number = true
opt.relativenumber = true
opt.wrap = false
opt.cursorline = true
opt.scrolloff = 8
opt.signcolumn = "yes"          -- espaço fixo pros sinais do LSP, sem o texto pular

-- Indentação: tab de 4 colunas (seus QML e Lua usam tabs)
opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = false
opt.smartindent = true

-- Busca
opt.ignorecase = true
opt.smartcase = true            -- diferencia maiúsculas só se você digitar alguma

-- Área de transferência do sistema (usa o wl-clipboard)
opt.clipboard = "unnamedplus"

-- Splits abrem à direita e embaixo
opt.splitright = true
opt.splitbelow = true

-- Desfazer persistente (sobrevive a fechar o arquivo)
opt.undofile = true

opt.updatetime = 250
