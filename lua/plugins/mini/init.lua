--            _       _
--  _ __ ___ (_)_ __ (_)
-- | '_ ` _ \| | '_ \| |
-- | | | | | | | | | | |
-- |_| |_| |_|_|_| |_|_|
--
-- The plugin suite that's anything but mini

vim.pack.add {
	{ src = GH .. 'nvim-mini/mini.align' },
	{ src = GH .. 'nvim-mini/mini.surround' },
	{ src = GH .. 'nvim-mini/mini.icons' },
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

require('plugins.mini.ai')
require('plugins.mini.bracketed')
require('plugins.mini.indentscope')
require('plugins.mini.keymap')
require('plugins.mini.operators')
