--  _                   _
-- | |_ _   _ _ __  ___| |_
-- | __| | | | '_ \/ __| __|
-- | |_| |_| | |_) \__ \ |_
--  \__|\__, | .__/|___/\__|
--      |___/|_|
--
-- A worthy successor to LaTeX?


vim.pack.add {
	{ src = GH .. 'chomosuke/typst-preview.nvim' }
}

require('plugins.images')

require('typst-preview').setup({
	invert_colors = '{"rest": "auto", "image": "never"}',
	open_cmd = 'wl-surf %s'
})
require('typst-preview.commands').create_commands()
