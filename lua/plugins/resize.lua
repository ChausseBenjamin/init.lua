local M = {}

local defaults = {
	trigger = '<leader>r',
	keymaps = {},
	hi = { fg = '#c0ffee' },
}

local state = {
	active = false,
	cache = {},
}

-- generic capture-then-replace primitive: stores the prior value plus the
-- setter needed to restore it, keyed by id, in a single cache table.
local swap = function(cache, id, getter, setter, new_value)
	cache[id] = { value = getter(id), setter = setter }
	setter(id, new_value)
end

local restore_all = function(cache)
	for id, entry in pairs(cache) do
		entry.setter(id, entry.value)
	end
end

local get_hl = function(name)
	return vim.api.nvim_get_hl(0, { name = name })
end

local set_hl = function(name, val)
	vim.api.nvim_set_hl(0, name, val)
end

-- buffer-local mappings (LSP's `K`, `gd`, etc., set with buffer = ev.buf)
-- take precedence over global ones regardless of set order, so both the
-- lookup and the override must account for buffer scope.
local get_keymap = function(lhs)
	for _, m in ipairs(vim.api.nvim_buf_get_keymap(0, 'n')) do
		if m.lhs == lhs then return { map = m, buffer_local = true } end
	end
	for _, m in ipairs(vim.api.nvim_get_keymap('n')) do
		if m.lhs == lhs then return { map = m, buffer_local = false } end
	end
	return { map = nil, buffer_local = false }
end

-- new_value is either a function (entering resize mode) or a previously
-- captured snapshot from get_keymap (restoring on quit).
local set_keymap = function(lhs, new_value)
	if type(new_value) == 'function' then
		-- always shadow as buffer-local so it wins over any buffer-local
		-- mapping already on this buffer.
		vim.keymap.set('n', lhs, new_value,
			{ noremap = true, silent = true, buffer = 0 })
		return
	end

	pcall(vim.keymap.del, 'n', lhs, { buffer = 0 })

	if new_value.map and new_value.buffer_local then
		local m = new_value.map
		vim.keymap.set('n', lhs, m.callback or m.rhs, {
			noremap = m.noremap == 1,
			silent  = m.silent == 1,
			expr    = m.expr == 1,
			nowait  = m.nowait == 1,
			buffer  = 0,
		})
	end
	-- if it was global or never existed, deleting our buffer-local override
	-- is enough — the global mapping (or nothing) shows through on its own.
end

-- pure vim.api adjacency check: does another window in this tabpage sit
-- directly against the current window's left/right/top/bottom edge.
local neighbors = function()
	local cur = vim.api.nvim_get_current_win()
	local cr, cc = unpack(vim.api.nvim_win_get_position(cur))
	local cw, ch = vim.api.nvim_win_get_width(cur),
			vim.api.nvim_win_get_height(cur)

	local pos = { on_left = false, on_right = false, above = false, below = false }

	for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
		if win ~= cur then
			local r, c = unpack(vim.api.nvim_win_get_position(win))
			local w, h = vim.api.nvim_win_get_width(win),
					vim.api.nvim_win_get_height(win)

			local row_overlap = r < cr + ch and cr < r + h
			local col_overlap = c < cc + cw and cc < c + w

			if row_overlap and c == cc + cw + 1 then pos.on_left = true end
			if row_overlap and cc == c + w + 1 then pos.on_right = true end
			if col_overlap and r == cr + ch + 1 then pos.above = true end
			if col_overlap and cr == r + h + 1 then pos.below = true end
		end
	end

	return pos
end

-- direction -> { cmd, { pos_field, sign }, { pos_field, sign } }
-- table-driven resize: walk the rules for a direction, apply the first
-- one whose position predicate holds.
local RESIZE = {
	left  = { cmd = 'vertical resize ', { 'on_left', -1 }, { 'on_right', 1 } },
	right = { cmd = 'vertical resize ', { 'on_left', 1 }, { 'on_right', -1 } },
	up    = { cmd = 'resize ', { 'above', -1 }, { 'below', 1 } },
	down  = { cmd = 'resize ', { 'above', 1 }, { 'below', -1 } },
}

local resize = function(direction, qty)
	local entry = RESIZE[direction]
	if not entry then return end

	qty = qty or 1
	local pos = neighbors()

	for _, rule in ipairs(entry) do
		local field, sign = rule[1], rule[2]
		if pos[field] then
			vim.cmd(entry.cmd .. string.format('%+d', sign * qty))
			return
		end
	end
end

M.left = function(qty) resize('left', qty) end
M.right = function(qty) resize('right', qty) end
M.down = function(qty) resize('down', qty) end
M.up = function(qty) resize('up', qty) end

function M.quit()
	if not state.active then return end
	vim.print('Leaving RESIZE')
	restore_all(state.cache)
	state.cache = {}
	state.active = false
end

function M.enter()
	if state.active then return end
	vim.print('Entering RESIZE')
	state.active = true

	swap(state.cache, 'WinSeparator', get_hl, set_hl, M.opts.hi)

	for key, fn in pairs(M.opts.keymaps) do
		swap(state.cache, key, get_keymap, set_keymap, fn)
	end

	swap(state.cache, '<Esc>', get_keymap, set_keymap, M.quit)
end

function M.setup(opts)
	M.opts = vim.tbl_deep_extend('force', defaults, opts or {})
	vim.keymap.set('n', M.opts.trigger, M.enter, { noremap = true, silent = true })
end

return M
