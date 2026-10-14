-- Opções e atalhos antes dos plugins (o leader precisa existir antes do lazy carregar)
require("config.options")
require("config.keymaps")

-- Plugins
require("config.lazy")

-- Fundo transparente. No autocmd, pra ser reaplicado se um tema for carregado depois.
local function transparente()
	for _, grupo in ipairs({ "Normal", "NormalNC", "NonText", "SignColumn", "EndOfBuffer" }) do
		vim.api.nvim_set_hl(0, grupo, { bg = "none" })
	end
end
vim.api.nvim_create_autocmd("ColorScheme", { callback = transparente })
transparente()
