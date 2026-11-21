vim.pack.add({
	{ src = GH .. 'nvim-mini/mini.ai' },
})

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
