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
}
for _, pkg in ipairs(mini_defaults) do
	require('mini.' .. pkg).setup()
end

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
		F = gen_spec.treesitter({ -- `f` is for function calls not definitions
			a = '@function.outer',
			i = '@function.inner',
		}),
		o = gen_spec.treesitter({
			a = '@loop.outer',
			i = '@loop.inner',
		}),
		c = gen_spec.treesitter({
			a = '@conditional.outer',
			i = '@conditional.inner',
		}),
		C = gen_spec.treesitter({
			a = '@class.outer',
			i = '@class.inner',
		}),
	},
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
