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

require('typst-preview.commands').create_commands()
