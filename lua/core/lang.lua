--  _
-- | | __ _ _ __   __ _
-- | |/ _` | '_ \ / _` |
-- | | (_| | | | | (_| |
-- |_|\__,_|_| |_|\__, |
--                |___/
--
-- Because I am cursed with the knowlege of french

-- Ensure search (and it's reverse) works even on the wrong kb layout
local langmaps = {
	'é/', 'É?', "'<", '">', '?^', 'à\\\\',
	'À|', "è'", 'È"', 'ù`', 'Ù~', '¨{', 'Ç}',
}
vim.opt.langmap = table.concat(langmaps)

-- k.ey c.har
local digraphs = {
	{ "[A", 'Â', }, { "'A", "À", }, { "[A", 'Â', }, { "'A", "À", },
	{ "[a", 'â', }, { "'a", "à", }, { "[a", 'â', }, { "'a", "à", },
	{ "/e", 'é', }, { "[e", 'ê', }, { "'e", 'è', },
	{ "/E", 'É', }, { "[E", 'Ê', }, { "'E", 'È', },
	{ "]c", 'ç', }, { "[o", 'ô', }, { "'u", 'ù', },
	{ "]C", 'Ç', }, { "[O", 'Ô', }, { "'U", 'Ù', },
}
vim.fn.digraph_setlist(digraphs)

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
