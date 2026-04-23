--  ____            _
-- |  _ \ _   _ ___| |_
-- | |_) | | | / __| __|
-- |  _ <| |_| \__ \ |_
-- |_| \_\\__,_|___/\__|
--
-- What else would you re-write it in?

require('rustaceanvim')
require('plugins.neotest')

vim.keymap.set('n',
	'<leader>fa',
	function() vim.cmd.RustLsp('codeAction') end,
	{
		desc = 'Run code Action',
		silent = true,
		buffer = 0,
	}
)

vim.keymap.set(
	'n',
	'K', -- Override Neovim's built-in hover keymap
	function()
		vim.cmd.RustLsp({ 'hover', 'actions' })
	end,
	{
		desc = 'Show object description or image on hover',
		silent = true,
		buffer = 0,
	}
)

vim.keymap.set(
	'n',
	'<leader>pe', -- Override Neovim's built-in hover keymap
	function()
		vim.cmd.RustLsp('expandMacro')
	end,
	{
		desc = 'View macro expansion',
		silent = true,
		buffer = 0,
	}
)


-- Run all tests in the file (useful to see compile errors lol)
vim.keymap.set('n', '<leader>mT', function()
	vim.cmd('update')
	-- Close any existing test buffers to avoid clutter
	for _, buf in ipairs(vim.api.nvim_list_bufs()) do
		if vim.api.nvim_buf_is_valid(buf) then
			local name = vim.api.nvim_buf_get_name(buf)
			-- Close buffers that are specifically cargo test terminals or test-related
			if name:match('term://.*cargo test') or
					name:match('rusttest') or
					name:match('test%-output') or
					(vim.bo[buf].buftype == 'quickfix') then
				-- Only close if it's not the current buffer to avoid issues
				if buf ~= vim.api.nvim_get_current_buf() then
					vim.api.nvim_buf_delete(buf, { force = true })
				end
			end
		end
	end
	vim.cmd('RustTest!')
end, { desc = 'Run all tests', buffer = 0 })
