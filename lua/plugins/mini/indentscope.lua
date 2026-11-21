vim.pack.add({
	{ src = GH .. 'nvim-mini/mini.indentscope' },
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
