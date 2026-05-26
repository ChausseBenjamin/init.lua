return {
	provider = function()
		local cwd = vim.fn.getcwd()
		local short = vim.fn.fnamemodify(cwd, ':~')
		return short .. '/ '
	end,
	update = { 'DirChanged', 'TabEnter' }
}
