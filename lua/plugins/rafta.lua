--             __ _
--  _ __ __ _ / _| |_ __ _
-- | '__/ _` | |_| __/ _` |
-- | | | (_| |  _| || (_| |
-- |_|  \__,_|_|  \__\__,_|
--

DevPack('ChausseBenjamin/rafta.nvim')
local rafta = require('rafta')

local styles = {
	['@rafta.priority.value'] = { link = '@number' },
	['@rafta.priority.bracket'] = { link = '@punctuation' },
	['@rafta.title'] = { link = '@label' },
	['@rafta.id'] = { link = '@comment' },
	['@rafta.state.unspecified'] = { link = '@comment.error' },
	['@rafta.state.done'] = { link = 'Added' },
	['@rafta.state.pending'] = { link = '@comment.todo' },
	['@rafta.state.ongoing'] = { link = '@character.special' },
	['@rafta.state.blocked'] = { link = '@character' },
}
for style, opts in pairs(styles) do
	vim.api.nvim_set_hl(0, style, opts)
end

rafta.setup({
	logging = {
		level = vim.log.levels.DEBUG,
		formatter = require 'rafta.util.log'.formatters.json
		-- path = '', -- force fallback to vim.notify
	},
	ui = {},
})
