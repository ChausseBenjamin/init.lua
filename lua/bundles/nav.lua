--  _ __   __ ___   __
-- | '_ \ / _` \ \ / /
-- | | | | (_| |\ V /
-- |_| |_|\__,_| \_/
--
-- Navigation tooling

require('plugins.oil')
require('plugins.telescope')
require('plugins.dropship')
require('plugins.winresize')
local res = require('plugins.resize')
require('plugins.harpoon')

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
