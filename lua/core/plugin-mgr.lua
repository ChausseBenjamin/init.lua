local view_logs = function()
	local log_path = vim.fs.joinpath(vim.fn.stdpath('log'), 'nvim-pack.log')
	if vim.fn.filereadable(log_path) == 1 then
		vim.cmd.tabedit(log_path)
	else
		vim.notify('No update log found', vim.log.levels.INFO)
	end
end

local clean_unused = function()
	local unused = vim.iter(vim.pack.get())
			:filter(function(p) return not p.active end)
			:map(function(p) return p.spec.name end)
			:totable()
	if #unused > 0 then
		vim.pack.del(unused)
	else
		vim.notify('No unused plugins to clean', vim.log.levels.INFO)
	end
end

local rollback_updates = function()
	local config_dir = vim.fn.stdpath('config')
	local res = vim.system({ 'git', '-C', config_dir, 'checkout', 'HEAD', '--',
		'nvim-pack-lock.json' }):wait()
	if res.code ~= 0 then
		vim.notify('Failed to revert lockfile: ' .. (res.stderr or 'git error'),
			vim.log.levels.ERROR)
		return
	end
	vim.notify(
		'Lockfile reverted. Restart nvim to apply, then run Sync plugins.',
		vim.log.levels.INFO)
end

local options = {
	{
		desc = 'View Update Log',
		cmd = view_logs,
	},
	{
		desc = 'Update All Plugins',
		cmd = function() vim.pack.update() end,
	},
	{
		desc = 'Clean unused plugins',
		cmd = clean_unused,
	},
	{
		desc = 'Sync plugins (match lockfile versions)',
		cmd = function()
			vim.pack.update(nil, { target = 'lockfile' })
		end,
	},
	{
		desc = 'Rollback updates (last commited lockfile)',
		cmd = rollback_updates,
	},
}

local menu = function()
	vim.ui.select(options, {
		prompt = 'Plugin Updater',
		format_item = function(item)
			return item.desc
		end,
	}, function(selected)
		if selected then
			selected.cmd()
		end
	end)
end

vim.keymap.set('n', '<leader>pu', menu, {
	desc = '[P]lugins [U]pdater'
})
