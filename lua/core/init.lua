--
--   ___ ___  _ __ ___
--  / __/ _ \| '__/ _ \
-- | (_| (_) | | |  __/
--  \___\___/|_|  \___|
--
-- plugin-less sane defaults

vim.g.mapleader = ' '

vim.o.number = true
vim.o.relativenumber = true

vim.o.encoding = 'utf-8'

vim.opt.splitright = true
vim.opt.splitbelow = true

vim.o.tabstop = 2
vim.o.shiftwidth = 2

vim.o.autoread = true
vim.o.exrc = true

vim.o.textwidth = 80
vim.opt.formatoptions:append('c') -- Auto-wrap comments
vim.opt.formatoptions:append('r') -- Insert comment leader after <Enter>
vim.opt.formatoptions:append('q') -- Allow formatting comments with gq
vim.opt.formatoptions:append('j') -- Remove comment leader when joining lines

-- Shutup about missing providers when running `:checkhealth`
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0

-- stolen from vim-sensible (thx tpope, the one true Pope)
vim.o.scrolloff = 1
vim.o.sidescrolloff = 2
vim.opt.display:append('truncate')
vim.opt.listchars:append({ extends = '>', precedes = '<' })

-- ALWAYS start vim from the root of a git repo
-- (helps keeping harpoons consistent)
-- vim.fs.root() walks the filesystem itself, so no `git` subprocess is spawned
-- at startup. It matches a `.git` file too, so linked worktrees and submodules
-- resolve to their own root rather than the main repo's.
function Is_git_repo()
	return vim.fs.root(0, '.git')
end

local function cd_to_git_root()
	local git_root = Is_git_repo()
	if git_root then
		vim.cmd('tcd ' .. vim.fn.fnameescape(git_root))
	end
end

cd_to_git_root()
