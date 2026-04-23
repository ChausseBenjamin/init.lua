--                       _       _
--  _ __ ___   __ _ _ __| | ____| | _____      ___ ___
-- | '_ ` _ \ / _` | '__| |/ / _` |/ _ \ \ /\ / / '_  \
-- | | | | | | (_| | |  |   < (_| | (_) \ V  V /| | | |
-- |_| |_| |_|\__,_|_|  |_|\_\__,_|\___/ \_/\_/ |_| |_|
--
-- The best document format for note-taking/wikis

vim.pack.add({
	{ src = GH .. 'iamcco/markdown-preview.nvim' }
})

-- Somehow vim.pack.add isn't enough for this one...
vim.cmd('packadd markdown-preview.nvim')

-- pcall(require, 'plugins.images')
