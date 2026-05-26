return {
	condition = function() return vim.bo.filetype ~= '' end,
	provider = function()
		local icon = require('nvim-web-devicons').get_icon_by_filetype(
			vim.bo.filetype, { default = true })
		return ' ' .. (icon and icon .. ' ' or '') .. vim.bo.filetype
	end,
}
