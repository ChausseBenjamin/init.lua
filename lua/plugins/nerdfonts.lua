require('plugins.telescope')

DevPack('ChausseBenjamin/nerdy.nvim')

local nerdy = require('nerdy')

nerdy.setup({
	max_recents = 30,
	add_default_keybindings = false,
	output_location = '', -- yank register
})


require('telescope').load_extension('nerdy')

-- Wrap the extension function to inject your theme
local original_nerdy = require('telescope').extensions.nerdy.nerdy
require('telescope').extensions.nerdy.nerdy = function(opts)
	opts = vim.tbl_deep_extend('force', {
		borderchars = { '─', '│', '─', '│', '┌', '┐', '┘', '└' },
		layout_config = {
			height = 100,
			width = 400,
			prompt_position = 'bottom',
			preview_cutoff = 40,
		},
	}, opts or {})
	return original_nerdy(opts)
end

vim.keymap.set('n', '<leader>pi',
	require('telescope').extensions.nerdy.nerdy,
	{ desc = '[P]aruse [I]cons' }
)
