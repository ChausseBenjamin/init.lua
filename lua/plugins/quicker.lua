--              _      _
--   __ _ _   _(_) ___| | _____ _ __
--  / _` | | | | |/ __| |/ / _ \ '__|
-- | (_| | |_| | | (__|   <  __/ |
--  \__, |\__,_|_|\___|_|\_\___|_|
--     |_|
--
-- Visual and functional tweaks to the quickfix

vim.pack.add {
	{ src = GH .. 'stevearc/quicker.nvim' },
}

local quicker = require('quicker')

vim.keymap.set('n', '<leader>q', function()
	quicker.toggle()
end, {
	desc = 'Toggle quickfix',
})
vim.keymap.set('n', '<leader>ll', function()
	quicker.toggle({ loclist = true })
end, {
	desc = 'Toggle loclist',
})

quicker.setup({
	keys = {
		{
			'>',
			function()
				quicker.expand({ before = 2, after = 2, add_to_existing = true })
			end,
			desc = 'Expand quickfix context',
		},
		{
			'<',
			function()
				quicker.collapse()
			end,
			desc = 'Collapse quickfix context',
		},
	},
})
