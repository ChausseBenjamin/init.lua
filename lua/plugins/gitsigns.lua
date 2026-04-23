--        _ _       _
--   __ _(_) |_ ___(_) __ _ _ __  ___
--  / _` | | __/ __| |/ _` | '_ \/ __|
-- | (_| | | |_\__ \ | (_| | | | \__ \
--  \__, |_|\__|___/_|\__, |_| |_|___/
--  |___/             |___/
--
-- To find someone to blame


vim.pack.add {
	{ src = GH .. 'lewis6991/gitsigns.nvim' },
	{ src = GH .. 'nvim-treesitter/nvim-treesitter-textobjects' },
}

local gs = require('gitsigns')
gs.setup()
local ok_ts, ts_repeat = pcall(require, 'nvim-treesitter.textobjects.repeatable_move')
if not ok_ts then
	return
end
local function navopts()
	return {
		wrap = true,
		foldopen = true,
		navigation_message = true,
		preview = false,
		count = vim.v.count1,
	}
end

local next_hunk, prev_hunk = ts_repeat.make_repeatable_move_pair(
	function()
		gs.nav_hunk('next', navopts())
	end,
	function()
		gs.nav_hunk('prev', navopts())
	end
)

vim.keymap.set(
	{ 'n', 'x', 'o' },
	']h',
	next_hunk,
	{ desc = 'next [H]unk' }
)
vim.keymap.set(
	{ 'n', 'x', 'o' },
	'[h',
	prev_hunk,
	{ desc = 'prev [H]unk' }
)
vim.keymap.set('n', '<leader>gl', function()
	require('gitsigns').blame_line()
end, { desc = 'Blame current [L]ine' })
