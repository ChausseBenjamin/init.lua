--  _          _      _ _
-- | |__   ___(_)_ __| (_)_ __   ___
-- | '_ \ / _ \ | '__| | | '_ \ / _ \
-- | | | |  __/ | |  | | | | | |  __/
-- |_| |_|\___|_|_|  |_|_|_| |_|\___|
--

vim.pack.add({
	{ src = GH .. 'rebelot/heirline.nvim' }
})

local gitbranch = require('plugins.heirline.git_branch')
local gitdiff = require('plugins.heirline.git_diff')
local cwd = require('plugins.heirline.cwd')
local fileflags = require('plugins.heirline.fileflags')
local filepath = require('plugins.heirline.filepath')
local filetype = require('plugins.heirline.filetype')
local mode = require('plugins.heirline.mode')
local tabs = require('plugins.heirline.tabs')

local padding = { provider = '%=' }
local location = { provider = ' %l:%c ' }

vim.o.showtabline = 2 -- always show the tabline
vim.o.laststatus = 3  -- single status line

-- Remove duplicate information that clutters the bottom of the screen
vim.o.ruler = false   -- '100%' linenr/col on the right
vim.o.showcmd = false -- commands on the right
vim.o.showmode = false

---@diagnostic disable: missing-fields
require("heirline").setup({
	statusline = {
		hl = 'hline.out',
		-- left
		mode,
		gitbranch,
		{ -- center
			hl = 'hline.in',
			padding,
			fileflags,
			filepath,
		},
		-- right
		filetype,
		location,
	},
	tabline = {
		hl = 'hline.out',
		-- left
		cwd,
		gitdiff,
		{ -- center
			hl = 'hline.in',
			padding,
			tabs,
		},
		-- right (nothing)
	}
})
