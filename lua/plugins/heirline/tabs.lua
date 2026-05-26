local utils = require('heirline.utils')

local tab = {
	provider = function(self)
		return ' ' .. self.tabnr .. ' '
	end,
	hl = function(self)
		if self.is_active then
			return 'hline.out.tabs.focused'
		end
	end
}

return {
	condition = function()
		return #vim.api.nvim_list_tabpages() > 1
	end,
	utils.make_tablist(tab)
}
