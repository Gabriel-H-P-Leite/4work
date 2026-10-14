-- Branch "main" (reescrita): precisa do Neovim 0.12+ e do tree-sitter-cli (pacman -S tree-sitter-cli)
return {
	"nvim-treesitter/nvim-treesitter",
	lazy = false,   -- não suporta carregamento tardio
	build = ":TSUpdate",
	config = function()
		local linguagens = {
			"lua", "python", "bash", "qmljs", "json", "toml", "yaml",
			"markdown", "markdown_inline", "vim", "vimdoc", "regex",
		}
		require("nvim-treesitter").install(linguagens)

		-- arquivos .qml usam o parser qmljs
		vim.treesitter.language.register("qmljs", "qml")

		-- ativa o destaque e a indentação do treesitter em qualquer arquivo com parser
		vim.api.nvim_create_autocmd("FileType", {
			callback = function(ev)
				if pcall(vim.treesitter.start, ev.buf) then
					vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
				end
			end,
		})
	end,
}
