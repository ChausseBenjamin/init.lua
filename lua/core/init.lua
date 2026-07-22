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

vim.o.textwidth = 80
vim.opt.formatoptions:append('c') -- Auto-wrap comments
vim.opt.formatoptions:append('r') -- Insert comment leader after <Enter>
vim.opt.formatoptions:append('q') -- Allow formatting comments with gq
vim.opt.formatoptions:append('j') -- Remove comment leader when joining lines

-- Shutup about missing providers when running `:checkhealth`
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0

-- ALWAYS start vim from the root of a git repo {{{
-- (helps keeping harpoons consistent)
function Is_git_repo()
	local git_dir = vim.fn.systemlist('git rev-parse --show-toplevel')
	if vim.v.shell_error ~= 0 then
		return false
	end
	return git_dir[1]
end

local function cd_to_git_root()
	local git_root = Is_git_repo()
	if git_root then
		vim.cmd('tcd ' .. git_root)
	end
end

cd_to_git_root()
