--                  _ _
--  _ __ ___   ___ | | |_ ___ _ __
-- | '_ ` _ \ / _ \| | __/ _ \ '_ \
-- | | | | | | (_) | | ||  __/ | | |
-- |_| |_| |_|\___/|_|\__\___|_| |_|
--
-- jupyter inside neovim

vim.pack.add {
	{ src = GH .. 'benlubas/molten-nvim' }
}

require('plugins.images')


vim.keymap.set('n', '<leader>mi', ':MoltenInit<CR>',
	{ silent = true, desc = 'Initialize the plugin' })
vim.keymap.set('n', '<leader>e', ':MoltenEvaluateOperator<CR>',
	{ silent = true, desc = 'run operator selection' })
vim.keymap.set('n', '<leader>rl', ':MoltenEvaluateLine<CR>',
	{ silent = true, desc = 'evaluate line' })
vim.keymap.set('n', '<leader>rr', ':MoltenReevaluateCell<CR>',
	{ silent = true, desc = 're-evaluate cell' })
vim.keymap.set('v', '<leader>r', ':<C-u>MoltenEvaluateVisual<CR>gv',
	{ silent = true, desc = 'evaluate visual selection' })

vim.keymap.set('n', '<leader>rd', ':MoltenDelete<CR>',
	{ silent = true, desc = 'molten delete cell' })
vim.keymap.set('n', '<leader>oh', ':MoltenHideOutput<CR>',
	{ silent = true, desc = 'hide output' })
vim.keymap.set('n', '<leader>os', ':noautocmd MoltenEnterOutput<CR>',
	{ silent = true, desc = 'show/enter output' })

-- Molten configuration options
-- vim.g.molten_auto_image_popup = true
vim.g.molten_image_location = 'virt'
vim.g.molten_image_provider = 'image.nvim'
vim.g.molten_auto_open_output = true
vim.g.molten_output_win_border = { '', '━', '', '' }
vim.g.molten_output_show_more = true
vim.g.molten_virt_text_output = true
vim.g.molten_wrap_output = true
