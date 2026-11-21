vim.pack.add({
	{ src = GH .. 'nvim-treesitter/nvim-treesitter' },
	{ src = GH .. 'nvim-mini/mini.bracketed' },
})

require('mini.bracketed').setup({
	-- Disable what's unnecessary or overlaps
	file = { suffix = '', options = {} },
	oldfile = { suffix = '', options = {} },
	undo = { suffix = '', options = {} },
	window = { suffix = '', options = {} },
	yank = { suffix = '', options = {} },
	treesitter = { suffix = '', options = {} },

	-- `c` already used by treesitter-textobjects
	comment = { suffix = 'g', options = {} },
	quickfix = { suffix = 'q', options = { wrap = false } },
})

-- Make `]g`/`[g` comment navigation repeatable with `;`/`,` by registering it
-- through treesitter-textobjects' `last_move` machinery (shared with the `]f`,
-- `]s`, `]o`, `]c` moves). Overrides mini.bracketed's plain `]g`/`[g` maps.
-- `]G`/`[G` (first/last) stay non-repeatable.
local ok_tsrm, tsrm = pcall(require,
	'nvim-treesitter-textobjects.repeatable_move')
if ok_tsrm then
	local comment_move = tsrm.make_repeatable_move(function(opts)
		MiniBracketed.comment(opts.forward and 'forward' or 'backward')
	end)
	vim.keymap.set({ 'n', 'x', 'o' }, ']g',
		function() comment_move({ forward = true }) end,
		{ desc = 'Next comment block' })
	vim.keymap.set({ 'n', 'x', 'o' }, '[g',
		function() comment_move({ forward = false }) end,
		{ desc = 'Previous comment block' })
end
