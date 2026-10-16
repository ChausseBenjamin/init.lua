--            _       _
--  _ __ ___ (_)_ __ (_)
-- | '_ ` _ \| | '_ \| |
-- | | | | | | | | | | |
-- |_| |_| |_|_|_| |_|_|
--
-- The plugin that's anything but mini

vim.pack.add {
	{ src = GH .. 'nvim-treesitter/nvim-treesitter' },
	{ src = GH .. 'echasnovski/mini.nvim' },
}

-- plugin parts for which the defaults are ok
local mini_defaults = {
	'align',
	'surround',
	'icons',
}
for _, pkg in ipairs(mini_defaults) do
	require('mini.' .. pkg).setup()
end
MiniIcons.mock_nvim_web_devicons()

-- Remap gx to gX to avoid conflict with URL opening
require('mini.operators').setup({
	exchange = { prefix = 'gX' },
	replace  = { prefix = 'gs' }, -- S as in substitute
	sort     = { prefix = 'gS' }, -- s as in sort
})

-- Animations and delay were annoying for this one
local no_indent_anim = require('mini.indentscope').gen_animation.none
require('mini.indentscope').setup({
	draw = {
		delay = 0,
		animation = no_indent_anim(),
	},
})
vim.api.nvim_set_hl(0, 'MiniIndentscopeSymbol', { link = 'Folded' })

-- Better 'A'round/'I'nner  + Custom treesitter mappings
local gen_spec = require('mini.ai').gen_spec
require('mini.ai').setup({
	n_lines = 300,
	custom_textobjects = {
		f = gen_spec.treesitter({ -- function *definition*; overrides builtin `f` (function call)
			a = '@function.outer',
			i = '@function.inner',
		}),
		o = gen_spec.treesitter({ -- `l` taken by `:h location-list`
			a = '@loop.outer',
			i = '@loop.inner',
		}),
		c = gen_spec.treesitter({
			a = '@conditional.outer',
			i = '@conditional.inner',
		}),
		s = gen_spec.treesitter({
			a = '@class.outer',
			i = '@class.inner',
		}),
	},
})

-- Quickest save in the west (without the `l` delay)
require('mini.keymap').map_combo('n', 'lkj', function()
	vim.cmd.update()
	vim.notify("Saved " .. vim.fn.expand('%:t'))
end)

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
