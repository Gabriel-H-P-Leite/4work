-- Marca trechos de texto com cores (não altera o arquivo)
return {
	"pocco81/high-str.nvim",
	cmd = { "HSHighlight", "HSRmHighlight", "HSExport", "HSImport" },
	keys = {
		-- no modo visual: <leader>h + número da cor (1 a 9)
		{ "<leader>h1", ":<C-u>HSHighlight 1<CR>", mode = "v", desc = "Marcar (amarelo)" },
		{ "<leader>h2", ":<C-u>HSHighlight 2<CR>", mode = "v", desc = "Marcar (água)" },
		{ "<leader>h3", ":<C-u>HSHighlight 3<CR>", mode = "v", desc = "Marcar (roxo)" },
		{ "<leader>h4", ":<C-u>HSHighlight 4<CR>", mode = "v", desc = "Marcar (laranja)" },
		{ "<leader>hr", ":<C-u>HSRmHighlight<CR>", mode = "v", desc = "Remover marcação da seleção" },
		{ "<leader>hR", "<cmd>HSRmHighlight rm_all<CR>", desc = "Remover todas as marcações" },
	},
	opts = {
		verbosity = 0,
		-- fora do /tmp pra o :HSExport sobreviver a reiniciar o PC
		saving_path = vim.fn.stdpath("data") .. "/highstr/",
	},
}
