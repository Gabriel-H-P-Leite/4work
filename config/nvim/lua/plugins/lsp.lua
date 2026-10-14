return {
	{
		"mason-org/mason.nvim",
		opts = {},
	},
	{
		"mason-org/mason-lspconfig.nvim",
		dependencies = { "mason-org/mason.nvim", "neovim/nvim-lspconfig" },
		-- instala esses servidores pelo Mason e ativa sozinho (vim.lsp.enable)
		opts = {
			ensure_installed = { "pyright", "lua_ls", "bashls" },
		},
	},
	{
		"neovim/nvim-lspconfig",
		config = function()
			-- Lua: reconhece o "vim" do Neovim e o "hl" da config do Hyprland
			vim.lsp.config("lua_ls", {
				settings = {
					Lua = {
						diagnostics = { globals = { "vim", "hl" } },
						workspace = { checkThirdParty = false },
					},
				},
			})

			-- QML (Quickshell): o qmlls vem com o Qt, fora do PATH no Arch
			vim.lsp.config("qmlls", {
				cmd = { "/usr/lib/qt6/bin/qmlls" },
			})
			vim.lsp.enable("qmlls")

			vim.diagnostic.config({
				virtual_text = true,
				severity_sort = true,
				float = { border = "rounded" },
			})
		end,
	},
}
