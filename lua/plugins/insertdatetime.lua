--      _       _       _   _
--   __| | __ _| |_ ___| |_(_)_ __ ___   ___
--  / _` |/ _` | __/ _ \ __| | '_ ` _ \ / _ \
-- | (_| | (_| | ||  __/ |_| | | | | | |  __/
--  \__,_|\__,_|\__\___|\__|_|_| |_| |_|\___|
--
-- Nah, mañana...

vim.pack.add {
	{ src = GH .. 'AntonVanAssche/date-time-inserter.nvim' },
}

local date_time_inserter_status_ok, dti =
		pcall(require, 'date-time-inserter')
if not date_time_inserter_status_ok then
	return
end

dti.setup({
	date_format = '%Y-%m-%d',
	date_separator = '-',
	time_format = '%H:%M',
	show_seconds = false,
})

local dti_keys = {
	{
		d = 'Insert [T]imestamp [D]ate',
		k = '<leader>td',
		f = function() dti.insert_date() end,
	},
	{
		d = 'Insert [T]imestamp [T]ime',
		k = '<leader>tt',
		f = function() dti.insert_time() end,
	},
	{
		d = 'Insert [T]imestamp [F]ull',
		k = '<leader>tf',
		f = function() dti.insert_date_time() end,
	},
}

for _, map in ipairs(dti_keys) do
	vim.keymap.set('n', map.k, map.f, { desc = map.d })
end
