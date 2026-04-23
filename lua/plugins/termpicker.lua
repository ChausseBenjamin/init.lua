--  _                            _      _
-- | |_ ___ _ __ _ __ ___  _ __ (_) ___| | _____ _ __
-- | __/ _ \ '__| '_ ` _ \| '_ \| |/ __| |/ / _ \ '__|
-- | ||  __/ |  | | | | | | |_) | | (__|   <  __/ |
--  \__\___|_|  |_| |_| |_| .__/|_|\___|_|\_\___|_|
--                        |_|
-- pick colors!

DevPack('ChausseBenjamin/termpicker.nvim')

local termpicker = require('termpicker')
termpicker.setup({})

-- Main Picker
vim.keymap.set({ 'i', 'n', 'o', 'x' }, '<C-g>', function()
	termpicker.pick()
end, { desc = 'Pick color' })

-- Picker into Yank Buffer
vim.keymap.set('n', '<leader>cy', function()
	require('termpicker').pick({ output = '"' })
end, { desc = 'Pick color to yank buffer' })

-- Picker with dynamic preview text
vim.keymap.set('x', '<leader>cp', function()
	-- Get the visual selection text
	vim.cmd('normal! y')
	local selected_text = vim.fn.getreg('"')

	require('termpicker').pick({
		output = '"',
		preview = { text = selected_text },
		behaviour = { preserve_selection = true }
	})
end, { desc = 'Pick color with selection as preview' })
