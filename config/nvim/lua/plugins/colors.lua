-- Mostra a cor de verdade de códigos como #e06c75, rgb(...) e nomes como "white"
return {
	"brenoprata10/nvim-highlight-colors",
	event = { "BufReadPre", "BufNewFile" },
	opts = {
		render = "background",
		virtual_symbol_position = "inline",

		enable_hex = true,
		enable_short_hex = true,
		enable_rgb = true,
		enable_hsl = true,
		enable_named_colors = true,
		enable_tailwind = false,
	},
	keys = {
		{ "<leader>tc", "<cmd>HighlightColors Toggle<CR>", desc = "Ligar/desligar cores" },
	},
}
