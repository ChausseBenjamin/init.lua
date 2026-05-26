--           _                     _
-- __      _(_)_ __  _ __ ___  ___(_)_______
-- \ \ /\ / / | '_ \| '__/ _ \/ __| |_  / _ \
--  \ V  V /| | | | | | |  __/\__ \ |/ /  __/
--   \_/\_/ |_|_| |_|_|  \___||___/_/___\___|
--
-- Resizing splits the correct way


vim.pack.add {
	{ src = GH .. 'simeji/winresizer' },
}

vim.g.winresizer_vert_resize = 7
vim.g.winresizer_horiz_resize = 10
vim.g.winresizer_start_key = '<leader><leader>w'
