--   __             _ _   _
--  / _|_   _  __ _(_) |_(_)_   _____
-- | |_| | | |/ _` | | __| \ \ / / _ \
-- |  _| |_| | (_| | | |_| |\ V /  __/
-- |_|  \__,_|\__, |_|\__|_| \_/ \___|
--            |___/
--
-- git like the one true Pope intended

vim.pack.add {
	{ src = GH .. 'tpope/vim-fugitive' },
	{ src = GH .. 'tpope/vim-rhubarb' },
	{ src = GH .. 'ChausseBenjamin/yadm.nvim', version = 'fix-vim-validate' },
}

require('yadm').setup({
	yadm_dir = vim.fn.expand('$XDG_DATA_HOME/yadm/repo.git'),
})

-- commands that accept ranges
local git_range_keys = {
	{
		k = '<leader>gh',
		f = function()
			if vim.fn.mode():match('[vV]') then
				local start_line = vim.fn.line("'<")
				local end_line = vim.fn.line("'>")
				vim.cmd(start_line .. ',' .. end_line .. 'Gclog')
			else
				vim.cmd.Gclog()
			end
		end,
		d = '[G]it [H]istory',
	},
	{
		k = '<leader>gb',
		f = function()
			if vim.fn.mode():match('[vV]') then
				local start_line = vim.fn.line("'<")
				local end_line = vim.fn.line("'>")
				vim.cmd(start_line .. ',' .. end_line .. 'G blame')
			else
				vim.cmd.G('blame')
			end
		end,
		d = '[G]it [B]lame',
	},
	{
		k = '<leader>gg',
		f = function()
			if vim.fn.mode():match('[vV]') then
				local start_line = vim.fn.line("'<")
				local end_line = vim.fn.line("'>")
				vim.cmd(start_line .. ',' .. end_line .. 'GBrowse')
			else
				vim.cmd.GBrowse()
			end
		end,
		d = '[G]it [G]o',
	},
}
for _, map in ipairs(git_range_keys) do
	vim.keymap.set({ 'n', 'v', 'x' }, map.k, map.f, { desc = map.d })
end

local git_norm_keys = {
	-- non range commands
	{
		k = '<leader>gs',
		f = vim.cmd.Git,
		d = '[G]it [S]tatus'
	},
	{
		k = '<leader>gd',
		f = function() vim.cmd.Git('difftool') end,
		d = '[G]it [D]iff',
	},
	{
		k = '<leader>gc',
		f = function() vim.cmd.Git('commit') end,
		d = '[G]it [C]ommit',
	},
	{
		k = '<leader>gu',
		f = function() vim.cmd.Git('push') end,
		d = '[G]it p[u]sh',
	},
	{
		k = '<leader>gp',
		f = function() vim.cmd.Git('pull') end,
		d = '[G]it [P]ull',
	},
	{
		k = '<leader>gf',
		f = function() vim.cmd.Git('fetch') end,
		d = '[G]it [F]etch',
	},
	{
		k = '<leader>ds',
		f = '<cmd>Gvdiffsplit!<cr>',
		d = 'Git [D]iff [S]plit'
	},
	{
		k = '<leader>dh',
		f = '<cmd>diffget //2 | diffupdate<cr>',
		d = '[D]iff select left',
	},
	{
		k = '<leader>dl',
		f = '<cmd>diffget //3 | diffupdate<cr>',
		d = '[D]iff select right',
	},
	{
		k = '<leader>do',
		f = vim.cmd.only,
		d = '[D]iff [O]nly'
	},
	-- NOTE: dp (no leader) is already set to diffput | diffupdate by default
}
for _, map in ipairs(git_norm_keys) do
	vim.keymap.set('n', map.k, map.f, { desc = map.d })
end
