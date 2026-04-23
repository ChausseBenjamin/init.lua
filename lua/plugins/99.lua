--  ____       _                    ___   ___
-- |  _ \ _ __(_)_ __ ___   ___    / _ \ / _ \
-- | |_) | '__| | '_ ` _ \ / _ \__| (_) | (_) |
-- |  __/| |  | | | | | | |  __/___\__, |\__, |
-- |_|   |_|  |_|_| |_| |_|\___|     /_/   /_/
--
-- The AI client that Neovim deserves

require('plugins.telescope')
vim.pack.add {
	{ src = GH .. 'ThePrimeagen/99' },
}

local ninety = require('99')

ninety.setup({
	model = 'opencode/big-pickle',
	tmp_dir = './tmp',
	md_files = {
		'AGENT.md',
	},
})

-- 9i operator: works with motions like 9iip, 9i12j, 9ia(, etc.
_G.__ninety_implement = function(motion_type)
	if motion_type == 'line' then
		vim.cmd('normal! `[V`]')
	else
		vim.cmd('normal! `[v`]')
	end

	ninety.visual({ additional_prompt = 'Implement this' })
end

vim.keymap.set('n', '9i', function()
	vim.go.operatorfunc = 'v:lua.__ninety_implement'
	return 'g@'
end, { desc = '[99] Implement operator', expr = true })

vim.keymap.set('x', '9i', function()
	ninety.visual({ additional_prompt = 'Implement this' })
end, { desc = '[99] Implement selection' })

-- 9I operator: works with motions but prompts for custom instruction
_G.__ninety_instruction = function(motion_type)
	if motion_type == 'line' then
		vim.cmd('normal! `[V`]')
	else
		vim.cmd('normal! `[v`]')
	end

	ninety.visual()
end

vim.keymap.set('n', '9I', function()
	vim.go.operatorfunc = 'v:lua.__ninety_instruction'
	return 'g@'
end, { desc = '[99] Implement with instruction', expr = true })

vim.keymap.set('x', '9I', function()
	ninety.visual()
end, { desc = '[99] Implement selection with instruction' })

local ninety_keys = {
	{
		k = '<leader>9x',
		f = function()
			ninety.stop_all_requests()
		end,
		d = '[99] Stop all requests',
	},
	{
		k = '<leader>9s',
		f = function()
			ninety.search()
		end,
		d = '[99] Search',
	},
	{
		k = '<leader>9m',
		f = function()
			require('99.extensions.telescope').select_model()
		end,
		d = '[99] Select model',
	},
	{
		k = '<leader>9p',
		f = function()
			require('99.extensions.telescope').select_provider()
		end,
		d = '[99] Select provider',
	},
	{
		k = '<leader>9o',
		f = function()
			ninety.open()
		end,
		d = '[99] Open last interaction',
	},
	{
		k = '<leader>9l',
		f = function()
			ninety.view_logs()
		end,
		d = '[99] View logs',
	},
	{
		k = '<leader>9c',
		f = function()
			ninety.clear_previous_requests()
		end,
		d = '[99] Clear previous requests',
	},
}

for _, map in ipairs(ninety_keys) do
	vim.keymap.set(map.m or 'n', map.k, map.f, { desc = map.d })
end
