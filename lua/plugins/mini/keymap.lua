vim.pack.add({
	{ src = GH .. 'nvim-mini/mini.keymap' },
})

-- Quickest save in the west (without the `l` delay)
require('mini.keymap').map_combo('n', 'lkj', function()
	vim.cmd.update()
	vim.notify("Saved " .. vim.fn.expand('%:t'))
end)
