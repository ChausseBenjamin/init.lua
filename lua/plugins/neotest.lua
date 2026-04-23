--                   _            _
--  _ __   ___  ___ | |_ ___  ___| |_
-- | '_  \/ _ \/ _ \| __/ _ \/ __| __|
-- | | | |  __/ (_) | ||  __/\__ \ |_
-- |_| |_|\___|\___/ \__\___||___/\__|
--
-- test away without leaving neovim

require('bundles.lsp') -- Ensures rustaceanvim is loaded

vim.pack.add({
	-- Dependencies
	{ src = GH .. 'nvim-lua/plenary.nvim' },
	{ src = GH .. 'antoinemadec/FixCursorHold.nvim' },
	{ src = GH .. 'nvim-treesitter/nvim-treesitter' },
	{ src = GH .. 'nvim-neotest/nvim-nio' },
	{ src = GH .. 'nvim-neotest/neotest' },
	-- Adapters
	{ src = GH .. 'nvim-neotest/neotest-plenary' },
})

local nt = require('neotest')

nt.setup({
	-- projects = {
	--  ['~/Workspace/plugins/raf'] = require('neotest-plenary')({
	--    min_init = './path/to/test_init.lua',
	--  }),
	adapters = {
		require('neotest-plenary'),
		require('rustaceanvim.neotest'),
	},
})
local keys = {
	{
		d = 'Run the nearest test',
		k = '<leader>tt',
		cmd = nt.run.run,
		m = 'n',
	},
	{
		d = 'Stop the nearest test',
		k = '<leader>ts',
		cmd = nt.run.stop,
		m = 'n',
	},
	{
		d = 'Attach to the nearest test',
		k = '<leader>ta',
		cmd = nt.run.attach,
		m = 'n',
	},
	{
		d = 'Watch the nearest test',
		k = '<leader>tw',
		cmd = nt.watch.watch,
		m = 'n',
	},
	{
		d = 'Run all tests in file',
		k = '<leader>tT',
		cmd = function() nt.run.run(vim.fn.expand('%')) end,
		m = 'n',
	},
	{
		d = 'Stop all tests in file',
		k = '<leader>tS',
		cmd = function() nt.run.stop(vim.fn.expand('%')) end,
		m = 'n',
	},
	{
		d = 'Attach to all tests in file',
		k = '<leader>tA',
		cmd = function() nt.run.attach(vim.fn.expand('%')) end,
		m = 'n',
	},
	{
		d = 'Watch all tests in file',
		k = '<leader>tW',
		cmd = function() nt.watch.watch(vim.fn.expand('%')) end,
		m = 'n',
	},
}

for _, map in ipairs(keys) do
	vim.keymap.set(map.m, map.k, map.cmd, { desc = map.d })
end
