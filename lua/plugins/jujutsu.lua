--    _        _       _
--   (_)_   _ (_)_   _| |_ ___ _   _
--   | | | | || | | | | __/ __| | | |
--   | | |_| || | |_| | |_\__ \ |_| |
--  _/ |\__,_|/ |\__,_|\__|___/\__,_|
-- |__/     |__/
--
-- git with chops

require('plugins.difftastic')
vim.pack.add({
	{ src = GH .. 'yannvanhalewyn/jujutsu.nvim' },
})

local jj = require('jujutsu-nvim')
vim.keymap.set('n', '<leader>jj', jj.log, { desc = 'JJ Log' })

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
