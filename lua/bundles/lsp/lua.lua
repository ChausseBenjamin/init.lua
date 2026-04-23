-- tweaks to mute lua errors in the Neovim config:
vim.lsp.config('lua_ls', {
	settings = {
		Lua = {
			workspace = {
				library = vim.api.nvim_get_runtime_file('', true)
			}
		}
	}
})
