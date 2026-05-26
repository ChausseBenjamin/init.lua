--
-- __   ____ _  __ _ _   _  ___
-- \ \ / / _` |/ _` | | | |/ _ \
--  \ V / (_| | (_| | |_| |  __/
--   \_/ \__,_|\__, |\__,_|\___|
--             |___/
--
-- A cool, dark, low contrast colorscheme

vim.pack.add {
	{ src = GH .. 'vague-theme/vague.nvim' },
}

require('vague').setup({
	transparent = true,
	style = {
		boolean = 'bold',
		comments = 'italic',
		conditionals = 'none',
		functions = 'none',
		headings = 'bold',
		keywords = 'none',
		keyword_return = 'italic',
		strings = 'italic',
		variables = 'none',
		builtin_constants = 'bold',
		builtin_functions = 'none',
		builtin_types = 'bold',
		builtin_variables = 'none',
	},
	plugins = {
		cmp = {
			match = 'bold',
			match_fuzzy = 'bold',
		},
		lsp = {
			diagnostic_error = 'bold',
			diagnostic_info = 'italic',
			diagnostic_ok = 'none',
			diagnostic_warn = 'bold',
		},
		telescope = {
			match = 'bold',
		},
	},
})

vim.cmd.colorscheme('vague')

local plt = {
	black   = '#1C1C24',
	dark    = '#252530',
	coral   = '#b4d4cf',
	pale    = '#90a0b5',
	blue    = '#405065',
	lilac   = '#c3c3d5',
	green   = '#80a766',
	yellow  = '#e8b589',
	red     = '#d56380',
	magenta = '#b7416e'
}
-- Custom highlight tweaks
local rules = {
	['WinSeparator'] = { fg = plt.blue },
	['hline.out'] = { bg = plt.dark, fg = plt.lilac },
	['hline.in'] = { bg = plt.black, fg = plt.lilac },

	['hline.out.mode'] = { fg = plt.black },
	['hline.out.mode.norm'] = { bg = plt.pale, fg = plt.black },
	['hline.out.mode.cmd'] = { link = 'hline.out.mode.norm' },
	['hline.out.mode.insert'] = { bg = plt.yellow },
	['hline.out.mode.replace'] = { link = 'hline.out.mode.insert' },
	['hline.out.mode.vis'] = { bg = plt.coral },
	['hline.out.mode.term'] = { bg = plt.magenta, fg = plt.lilac },
	['hline.out.mode.sel'] = { link = 'hline.out.mode.term' },
	['hline.out.mode.shell'] = { link = 'hline.out.mode.term' },

	['hline.out.tabs.focused'] = { link = 'hline.out.mode.norm' },

	['hline.diff.added'] = { fg = plt.green },
	['hline.diff.modified'] = { fg = plt.yellow },
	['hline.diff.deleted'] = { fg = plt.red },
}
for rule, opts in pairs(rules) do
	vim.api.nvim_set_hl(0, rule, opts)
end
