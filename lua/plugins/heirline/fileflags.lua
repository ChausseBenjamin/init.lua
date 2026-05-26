return {
	{
		condition = function() return vim.bo.modified end,
		provider = "[+]",
	},
	{
		condition = function() return not vim.bo.modifiable or vim.bo.readonly end,
		provider = "[-]",
	},
}
