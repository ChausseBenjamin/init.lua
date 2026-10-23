--    _        _       _
--   (_)_   _ (_)_   _| |_ ___ _   _
--   | | | | || | | | | __/ __| | | |
--   | | |_| || | |_| | |_\__ \ |_| |
--  _/ |\__,_|/ |\__,_|\__|___/\__,_|
-- |__/     |__/
--
-- git with chops

local loaded = false -- becomes `require('jujutsu-nvim')` once loaded
local jj = {}
local function lazy_load()
	if loaded then return end
	require('plugins.difftastic')
	vim.pack.add({
		{ src = GH .. 'yannvanhalewyn/jujutsu.nvim' },
	})

	jj = require('jujutsu-nvim')
	loaded = true
end

vim.keymap.set('n', '<leader>jj', function()
	if not loaded then lazy_load() end
	jj.log()
end, { desc = 'JJ Log' })

vim.keymap.set('n', '<leader>ji', function()
	local confirm = vim.fn.confirm('Initialize jujutsu to colocate with git?',
		'&Yes\n&No', 2)
	if confirm == 1 then
		local output = vim.fn.system('jj git init --colocate')
		if vim.v.shell_error ~= 0 then
			vim.print('Error: ' .. output)
		else
			vim.print('Successfully initialized jj to colocate with git')
		end
	end
end, { desc = 'Initialize jujutsu to colocate with git' })
