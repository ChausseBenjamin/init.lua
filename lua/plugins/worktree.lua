--                      _    _
-- __      _____  _ __| | _| |_ _ __ ___  ___
-- \ \ /\ / / _ \| '__| |/ / __| '__/ _ \/ _ \
--  \ V  V / (_) | |  |   <| |_| | |  __/  __/
--   \_/\_/ \___/|_|  |_|\_\\__|_|  \___|\___|
--
-- Parallel development like a boss

vim.pack.add {
	{ src = GH .. 'ThePrimeagen/git-worktree.nvim' },
	{ src = GH .. 'nvim-telescope/telescope.nvim' },
}

require('git-worktree').setup({
	change_directory_command = 'tcd',
})

require('telescope').load_extension('git_worktree')

vim.keymap.set('n', '<leader>pB', function()
	require('telescope').extensions.git_worktree.git_worktrees()
end, { desc = '[P]aruse the [B]ranches' })

vim.keymap.set('n', '<leader>pn', function()
	require('telescope').extensions.git_worktree.create_git_worktree()
end, { desc = '[P]ut a [N]ew worktree here! (idk man...)' })

