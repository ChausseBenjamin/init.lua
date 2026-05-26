return {
	init = function(self)
		-- 1. jj attempt
		if vim.fn.executable('jj') == 1 then
			local ok, result = pcall(vim.fn.system,
				'jj log -r "ancestors(@, 100) & bookmarks()" --no-graph --limit 1 '
				.. '-T \'bookmarks.map(|ref| ref.name()).join(",")\' 2>/dev/null')
			if ok then
				self.branch = vim.trim(result or ''):gsub(',.*$', '')
				if self.branch ~= '' then return end
			end
		end
		-- 2. gitsigns attempt
		if vim.b.gitsigns_status_dict then
			self.branch = vim.b.gitsigns_status_dict.head
			if self.branch then return end
		end
		-- 3. raw git fallback
		if vim.fn.executable('git') == 1 then
			local ok, result = pcall(vim.fn.system,
				'git branch --show-current 2>/dev/null')
			if ok then
				self.branch = vim.trim(result or '')
				if self.branch ~= '' then return end
			end
		end
	end,
	provider = function(self)
		if not self.branch then return '' end
		return '  ' .. self.branch .. ' '
	end,
	update = {
		'User',
		'BufWritePost',
		pattern = { 'GitSignsUpdate', 'FugitiveChanged' },
		callback = vim.schedule_wrap(function()
			vim.cmd.redrawstatus()
		end)
	},
}
