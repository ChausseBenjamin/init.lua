--        _ _
--   ___ (_) |
--  / _ \| | |
-- | (_) | | |
--  \___/|_|_|
--

vim.pack.add {
	{ src = GH .. 'stevearc/oil.nvim' },
}

local oil = require('oil')
oil.setup({
	default_file_explorer = true,
	delete_to_trash = false,
	skip_confirm_for_simple_edits = true,
	columns = { 'icon' },
	keymaps = {
		['<C-h>'] = false,
		['<M-h>'] = 'actions.select_split',
	},
	view_options = {
		show_hidden = true,
	},
	preview_win = {
		preview_method = 'load',
	},
})

vim.keymap.set('n', '-', function() oil.open() end,
	{ desc = 'Toggle File Manager' })
