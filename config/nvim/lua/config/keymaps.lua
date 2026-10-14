local map = vim.keymap.set

-- Limpa o destaque da busca
map("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Navegar entre splits
map("n", "<C-h>", "<C-w>h", { desc = "Split da esquerda" })
map("n", "<C-j>", "<C-w>j", { desc = "Split de baixo" })
map("n", "<C-k>", "<C-w>k", { desc = "Split de cima" })
map("n", "<C-l>", "<C-w>l", { desc = "Split da direita" })

-- Mover linhas selecionadas
map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Mover seleção pra baixo" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Mover seleção pra cima" })

-- Diagnósticos
map("n", "<leader>d", vim.diagnostic.open_float, { desc = "Mostrar diagnóstico" })

-- LSP: o Neovim 0.11+ já tem K (documentação), grn (renomear), gra (ações),
-- grr (referências) e gri (implementação). Faltam só estes:
vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(ev)
		local o = { buffer = ev.buf }
		map("n", "gd", vim.lsp.buf.definition, vim.tbl_extend("force", o, { desc = "Ir pra definição" }))
		map("n", "<leader>lf", function() vim.lsp.buf.format({ async = true }) end,
			vim.tbl_extend("force", o, { desc = "Formatar arquivo" }))
	end,
})
