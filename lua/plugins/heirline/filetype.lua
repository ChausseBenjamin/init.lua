return {
	condition = function() return vim.bo.filetype ~= '' end,
	provider = function()
		local icon = MiniIcons.get('filetype', vim.bo.filetype)
		return ' ' .. icon .. ' ' .. vim.bo.filetype
	end,
}
