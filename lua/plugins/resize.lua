--                _
--  _ __ ___  ___(_)_______
-- | '__/ _ \/ __| |_  / _ \
-- | | |  __/\__ \ |/ /  __/
-- |_|  \___||___/_/___\___|
--
-- quickly change sizes for splits

DevPack('ChausseBenjamin/resizer.nvim')

local res = require('resizer')
res.setup({
	trigger = '<leader>s',
	hi = { link = '@markup.strong' },
	keymaps = {
		['h'] = function() res.left(10) end,
		['j'] = function() res.down(7) end,
		['k'] = function() res.up(7) end,
		['l'] = function() res.right(10) end,
		['H'] = function() res.left(1) end,
		['J'] = function() res.down(1) end,
		['K'] = function() res.up(1) end,
		['L'] = function() res.right(1) end,
		['q'] = res.quit,
	},
})
