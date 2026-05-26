return {
	provider = function()
		local name = vim.api.nvim_buf_get_name(0)
		if name == '' then return '' end
		return ' ' .. vim.fn.fnamemodify(name, ':.') .. ' '
	end,
}
