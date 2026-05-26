--  ____
-- |  _ \  ___ _   __
-- | | | |/ _ \ \ / /
-- | |_| |  __/\ V /
-- |____/ \___| \_/
--
-- Misc. tools for plugin development

require('core.tools') -- ensures I have `GH` loaded
vim.pack.add({ { src = GH .. 'nvim-lua/plenary.nvim' } })

-- Utility for my plugin development workflow
function DevPack(repo)
	local name = repo:match('.+/(.+)$')
	local local_path = vim.fn.expand('~/Workspace/plugins/' .. name)

	if vim.fn.isdirectory(local_path) == 1 then
		vim.opt.runtimepath:prepend(local_path)
	else
		vim.pack.add({ { src = GH .. repo } })
	end
end

-- vim.api.nvim_create_user_command('Resess', function()
-- 	local fn = '.session.vim'
-- 	vim.cmd('mksession! ' .. fn)
-- 	vim.cmd('restart source ' .. fn)
-- end, {})

-- P for Preview
function P(v)
	print(vim.inspect(v))
	return v
end

-- R for Reload
function R(name)
	require('plenary.reload').reload_module(name)
	return require(name)
end
