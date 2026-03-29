--  _
-- | | __ _ _ __   __ _
-- | |/ _` | '_ \ / _` |
-- | | (_| | | | | (_| |
-- |_|\__,_|_| |_|\__, |
--                |___/
--
-- Because I am cursed with the knowlege of french

-- Ensure search (and it's reverse) works even on the wrong kb layout
vim.api.nvim_command('set langmap+=é/')
vim.api.nvim_command('set langmap+=É?')

-- k.ey c.har
local digraphs = {
	{ "/e", 'é', },
	{ "[e", 'ê', },
	{ "'e", 'è', },
	{ "[a", 'â', },
	{ "'a", "à", },
	{ "[a", 'â', },
	{ "'a", "à", },
	{ "]c", 'ç', },
	{ "[o", 'ô', },
	{ "'u", 'ù', },
	{ "/E", 'É', },
	{ "[E", 'Ê', },
	{ "'E", 'È', },
	{ "[A", 'Â', },
	{ "'A", "À", },
	{ "[A", 'Â', },
	{ "'A", "À", },
	{ "]C", 'Ç', },
	{ "[O", 'Ô', },
	{ "'U", 'Ù', },
}
for _, v in ipairs(digraphs) do
	vim.cmd.dig(string.format('%s %s',
		v[1],
		vim.fn.char2nr(v[2])
	))
end

-- Control F since I mostly use Digraphs for F.rench
-- (Also, <c-k> is harpoon territory)
vim.keymap.set('i', '<c-f>', function()
	local char1 = vim.fn.getchar()
	local char2 = vim.fn.getchar()

	-- Convert to string if they're numbers
	local str1 = type(char1) == 'number' and vim.fn.nr2char(char1) or char1
	local str2 = type(char2) == 'number' and vim.fn.nr2char(char2) or char2

	local digraph = vim.fn.digraph_get(str1 .. str2)
	if digraph ~= '' then
		return digraph
	else
		return str1 .. str2
	end
end, { expr = true, desc = 'Digraph' })
