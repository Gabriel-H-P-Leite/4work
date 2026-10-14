-- Autocompletar (substitui o nvim-cmp, que estava instalado sem configuração)
return {
	"saghen/blink.cmp",
	version = "1.*",   -- v1 estável, com o binário pronto do buscador
	opts = {
		-- Enter aceita, Ctrl+Espaço abre, Ctrl+n/Ctrl+p ou setas navegam
		keymap = { preset = "enter" },
		appearance = { nerd_font_variant = "mono" },
		completion = {
			documentation = { auto_show = true, auto_show_delay_ms = 300 },
		},
		signature = { enabled = true },
		sources = {
			default = { "lsp", "path", "snippets", "buffer" },
		},
		fuzzy = { implementation = "prefer_rust_with_warning" },
	},
}
