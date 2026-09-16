--  _              _
-- | |_ ___   ___ | |___
-- | __/ _ \ / _ \| / __|
-- | || (_) | (_) | \__ \
--  \__\___/ \___/|_|___/
--
-- Miscellaneous goodies

-- Prefix used by *all* plugins loaded with vim.pack
-- Ex: `vim.pack.add({ { src = GH .. 'user/repo' } })`
GH = 'git@github.com:'

-- Cancel the redo entry of an internal `normal!` so dot-repeat re-runs `g@`
-- instead of the last normal command (mini.nvim's `cancel_redo` trick).
local ffi_ok, ffi = pcall(require, 'ffi')
local cancel_redo = function() end
if ffi_ok and pcall(ffi.cdef, 'void CancelRedo(void)') then
	cancel_redo = function() pcall(ffi.C.CancelRedo) end
end

-- Turn a function into an operator (mini.nvim pattern).
-- Registers it on the module (so |v:lua-require| can call it) and returns an
-- <expr> mapping body that sets 'operatorfunc' and triggers `g@`.
local M = {}

local function make_operator(name, fn)
	M[name] = fn
	local opfunc = "v:lua.require'core.tools'." .. name
	return function(_)
		vim.o.operatorfunc = opfunc
		return 'g@'
	end
end

-- Join lines under the motion into one (gJip, gJ5j, ...); dot-repeatable
local gJ = make_operator('join', function(optype)
	local first = vim.fn.line("'[")
	local last = vim.fn.line("']")
	if first < 1 or last <= first then
		return
	end
	local save = vim.wo.virtualedit
	vim.wo.virtualedit = ''
	vim.cmd('silent keepjumps normal! ' .. (last - first + 1) .. 'J')
	vim.wo.virtualedit = save
	cancel_redo()
end)
vim.keymap.set({ 'n', 'x' }, 'gJ', gJ, { expr = true, desc = 'Join over {motion}' })

-- Remove trailing white space on save
-- Except current line to avoid moving cursor
vim.api.nvim_create_autocmd({ 'BufWritePre' }, {
	pattern = { '*' },
	callback = function()
		local save_cursor = vim.fn.getpos('.')
		pcall(function()
			vim.cmd([[%s/\s\+$//e]])
		end)
		vim.fn.setpos('.', save_cursor)
	end,
})

return M
