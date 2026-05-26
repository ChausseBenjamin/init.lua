--        _
--  _   _(_)
-- | | | | |
-- | |_| | |
--  \__,_|_|
--
-- Making things pretty

vim.pack.add {
	-- TODO: Maybe switch to this?
	-- https://github.com/nvim-telescope/telescope-ui-select.nvim
	{ src = GH .. 'nvim-telescope/telescope-ui-select.nvim' },
	{ src = GH .. 'r0nsha/multinput.nvim' },
	{ src = GH .. 'nvim-tree/nvim-web-devicons' },
}

-- UI tweaks
require('plugins.themes.vague')
require('plugins.heirline.init')
-- require('plugins.lualine')
require('plugins.treesitter')
require('plugins.telescope')
require('plugins.notifier')

local ts = require('telescope')
ts.setup({
	extensions = {
		['ui-select'] = {
			require('telescope.themes').get_dropdown({
				borderchars = {
					prompt = { '─', '│', '─', '│', '╭', '╮', '╯', '╰' },
					results = { '─', '│', '─', '│', '├', '┤', '╯', '╰' },
					preview = { '─', '│', '─', '│', '╭', '╮', '╯', '╰' },
				},
				layout_config = {
					prompt_position = 'top',
				}
				-- even more opts...
			})
			-- pseudo code / specification for writing custom displays, like the one
			-- for 'codeactions'
			-- specific_opts = {
			--   [kind] = {
			--     make_indexed = function(items) -> indexed_items, width,
			--     make_displayer = function(widths) -> displayer
			--     make_display = function(displayer) -> function(e)
			--     make_ordinal = function(e) -> string
			--   },
			--   -- for example to disable the custom builtin 'codeactions' display
			--      do the following
			--   codeactions = false,
			-- }
		}
	}
})

ts.load_extension('ui-select')

require('multinput').setup({
	opts = {
		numbers = 'never',
	},
	padding = 5,
	width = { min = 8, max = 60 },
	height = { min = 1, max = 6 },
	completion = true,
	winhighlight = '',
	win = {
		title = 'Input: ',
		style = 'minimal',
		focusable = true,
		relative = 'cursor',
		col = -1,
		width = 1,
		height = 1,
	},
})

vim.o.winborder = 'rounded'
vim.o.pumborder = 'rounded'
