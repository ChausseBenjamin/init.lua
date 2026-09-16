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

local ok_ts, ts_repeat = pcall(require, 'nvim-treesitter-textobjects.repeatable_move')
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
		target = 'all',
	}
end

-- Repeat hunk jumps via the ;/, repeatable-move machinery
-- (defined in plugins/treesitter.lua); move_hunk registers the
-- hunk jump as the "last move" so ;/, can repeat it.
local move_hunk = ts_repeat.make_repeatable_move(function(opts)
	gs.nav_hunk(opts.forward and 'next' or 'prev', navopts())
end)

vim.keymap.set({ 'n', 'x', 'o' }, ']h', function()
	move_hunk({ forward = true })
end, { desc = 'next [H]unk' })
vim.keymap.set({ 'n', 'x', 'o' }, '[h', function()
	move_hunk({ forward = false })
end, { desc = 'prev [H]unk' })

vim.keymap.set('n', '<leader>gl', function()
	gs.blame_line()
end, { desc = 'Blame current [L]ine' })
