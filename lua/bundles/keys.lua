--  _
-- | | _____ _   _ ___
-- | |/ / _ \ | | / __|
-- |   <  __/ |_| \__ \
-- |_|\_\___|\__, |___/
--           |___/
--
-- General purpose keybindings

-- Emacs pinky prevention
vim.keymap.set(
	'n',
	'<leader>w',
	'<C-w>',
	{ desc = 'Window/Split Management' }
)

-- Unmap `S`
-- Sometimes used for lsp stuff and causes issues when buffer has none
vim.keymap.set('n', 'S', '<nop>')

-- quickSave
vim.keymap.set('n', '<C-Space>',
	function()
		vim.cmd.update()
		vim.print('Saved ' .. vim.fn.expand('%'))
	end, { desc = 'Save file' })

-- Easy acccess to the `:make` command
vim.keymap.set('n', '<leader>mk', function() vim.cmd.make() end,
	{ desc = 'run :make' })

-- Don't mess with pasted text
vim.keymap.set('i', '<C-r>+', '<C-r><C-o>+')

-- Capital 'Y' for system clipboard
vim.keymap.set(
	{ 'n', 'v', 'x' },
	'Y',
	'"+y',
	{ desc = 'Yank to clipboard', noremap = true }
)

-- `^` to navigate to the first non-space character feels off...
-- `gI` feels like "go to where I would go if I pressed `I` which is natural"
vim.keymap.set({ 'n', 'v', 'x' }, 'gI', '^')

-- Quick tab  and  buffer navigation
local navkeys = {
	{ '<Bslash>',   function() vim.cmd.tabnext() end,   'View next tab' },
	{ '<C-\\>',     function() vim.cmd.tabnew() end,    'Create a new tab' },
	{ '<S-Tab>',    function() vim.cmd.bprevious() end, 'Previous buffer' },
	{ '<leader>bd', function() vim.cmd.bdelete() end,   'Delete buffer' },
}
for _, map in ipairs(navkeys) do
	vim.keymap.set('n', map[1], map[2], { desc = map[3] })
end

-- Clear search highlights
vim.keymap.set('n', '<leader><leader>l', function()
	vim.cmd.nohlsearch()
end, { desc = 'Clear search highlights' })
