return {
	condition = function()
		if not vim.b.gitsigns_status_dict then return false end
		local d = vim.b.gitsigns_status_dict
		return (d.added or 0) > 0 or (d.removed or 0) > 0 or (d.changed or 0) > 0
	end,
	init = function(self)
		local d = vim.b.gitsigns_status_dict
		self.added = d.added or 0
		self.removed = d.removed or 0
		self.changed = d.changed or 0
	end,
	{
		provider = function(self)
			return self.added > 0 and ("+" .. self.added .. ' ') or ""
		end,
		hl = "hline.diff.added",
	},
	{
		provider = function(self)
			return self.changed > 0 and ("~" .. self.changed .. ' ') or ""
		end,
		hl = "hline.diff.modified",
	},
	{
		provider = function(self)
			return self.removed > 0 and ("-" .. self.removed .. ' ') or ""
		end,
		hl = "hline.diff.deleted",
	},
	update = {
		"User",
		"BufWritePost",
		pattern = { "GitSignsUpdate", "FugitiveChanged" },
		callback = vim.schedule_wrap(function() vim.cmd.redrawstatus() end),
	},
}
