return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	---@type snacks.Config
	opts = {
		bigfile = { enabled = true },
		explorer = { enabled = true },
		indent = { enabled = true },
		input = { enabled = true },
		picker = { enabled = true },
		notifier = { enabled = true },
		quickfile = { enabled = true },
		scope = { enabled = true },
		scroll = { enabled = true },
		statuscolumn = { enabled = true },
		words = { enabled = true },
		dashboard = {
			enabled = true,
			preset = {
				keys = {
					{ icon = " ", key = "f", desc = "Achar arquivo", action = ":lua Snacks.dashboard.pick('files')" },
					{ icon = " ", key = "n", desc = "Novo arquivo", action = ":ene | startinsert" },
					{ icon = " ", key = "g", desc = "Achar texto", action = ":lua Snacks.dashboard.pick('live_grep')" },
					{ icon = " ", key = "r", desc = "Arquivos recentes", action = ":lua Snacks.dashboard.pick('oldfiles')" },
					{ icon = " ", key = "c", desc = "Configuração", action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})" },
					{ icon = " ", key = "s", desc = "Recuperar sessão", section = "session" },
					{ icon = "󰒲 ", key = "L", desc = "Lazy", action = ":Lazy", enabled = package.loaded.lazy ~= nil },
					{ icon = " ", key = "q", desc = "Sair", action = ":qa" },
				},
				header = [[
███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║
██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝]],
			},
		},
	},
	keys = {
		-- explorador e buscador (substituem o nvim-tree e o telescope)
		{ "<leader>e", function() Snacks.explorer() end, desc = "Explorador de arquivos" },
		{ "<leader>ff", function() Snacks.picker.files() end, desc = "Buscar arquivo" },
		{ "<leader>fg", function() Snacks.picker.grep() end, desc = "Buscar texto" },
		{ "<leader>fr", function() Snacks.picker.recent() end, desc = "Arquivos recentes" },
		{ "<leader>fb", function() Snacks.picker.buffers() end, desc = "Buffers abertos" },
		{ "<leader>fh", function() Snacks.picker.help() end, desc = "Ajuda" },
		{ "<leader>fk", function() Snacks.picker.keymaps() end, desc = "Atalhos" },
		{ "<leader>fd", function() Snacks.picker.diagnostics() end, desc = "Diagnósticos" },
		{ "<leader>fs", function() Snacks.picker.lsp_symbols() end, desc = "Símbolos do arquivo" },
		{ "<leader>n", function() Snacks.notifier.show_history() end, desc = "Histórico de notificações" },
	},
}
