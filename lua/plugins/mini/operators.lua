vim.pack.add({
	{ src = GH .. 'nvim-mini/mini.operators' },
})

-- Remap gx to gX to avoid conflict with URL opening
require('mini.operators').setup({
	exchange = { prefix = 'gX' },
	replace  = { prefix = 'gs' }, -- S as in substitute
	sort     = { prefix = 'gS' }, -- s as in sort
})
