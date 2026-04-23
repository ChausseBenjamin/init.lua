--  _                      _ _   _
-- | |_ _ __ ___  ___  ___(_) |_| |_ ___ _ __
-- | __| '__/ _ \/ _ \/ __| | __| __/ _ \ '__|
-- | |_| | |  __/  __/\__ \ | |_| ||  __/ |
--  \__|_|  \___|\___||___/_|\__|\__\___|_|
--
-- Sweet, sweet AST-based syntax

vim.pack.add {
	{ src = GH .. 'nvim-treesitter/nvim-treesitter',             version = 'main' },
	{ src = GH .. 'nvim-treesitter/nvim-treesitter-textobjects', version = 'main' }
}

-- Patch vim.treesitter.get_node_text to fix nil node issues
local original_get_node_text = vim.treesitter.get_node_text
vim.treesitter.get_node_text = function(node, source, opts)
	if not node then
		return ''
	end
	-- Check if node has range method before calling get_node_text
	local ok, result = pcall(function()
		return node:range()
	end)
	if not ok then
		return ''
	end
	return original_get_node_text(node, source, opts)
end

-- Base treesitter config
require('nvim-treesitter').setup({
	highlight = { enable = true },
	indent = { enable = false },
	local_parsers = {
		pest = {
			source = {
				type = 'self_contained',
				url = 'https://github.com/pest-parser/tree-sitter-pest',
			},
			filetype = 'pest',
		},
		gotmpl = {
			source = {
				type = 'self_contained',
				url = 'https://github.com/ngalaiko/tree-sitter-go-template',
			},
			filetype = 'gotmpl',
		},
	},
	additional_vim_regex_highlighting = false,
	textobjects = {
		swap = {
			enable = true,
			swap_next = {
				['<leader>s'] = '@parameter.inner',
			},
			swap_previous = {
				['<leader>S'] = '@parameter.inner',
			},
		},
		move = {
			enable = true,
			set_jumps = true,

			goto_next_start = {
				[']f'] = '@function.outer',
			},
			goto_next_end = {
				[']F'] = '@function.outer',
			},

			goto_previous_start = {
				['[f'] = '@function.outer',
			},
			goto_previous_end = {
				['[F'] = '@function.outer',
			},

			goto_next = {
				[']m'] = '@function.inner',
				[']o'] = '@loop.inner',
				[']O'] = '@loop.outer',
				[']c'] = '@conditional.*',
				[']C'] = '@class.*',
			},
			goto_previous = {
				['[m'] = '@function.inner',
				['[o'] = '@loop.inner',
				['[O'] = '@loop.outer',
				['[c'] = '@conditional.*',
				['[C'] = '@class.*',
			},
		},
	},
})

-- Add filetype detection for custom parsers
vim.filetype.add({
	extension = {
		pest = 'pest',
		tmpl = 'gotmpl',
	},
})

-- Add custom directive for filename-based injection
vim.treesitter.query.add_directive('inject-by-filename!',
	function(_, _, bufnr, pred, metadata)
		if not bufnr or not vim.api.nvim_buf_is_valid(bufnr) then
			return
		end
		local ok, fname = pcall(vim.fs.basename, vim.api.nvim_buf_get_name(bufnr))
		if not ok or not fname then
			return
		end
		-- Match pattern like 'file.ext.tmpl' and extract "ext"
		local ext = fname:match('%.(%w+)%.tmpl$')
		if ext then
			metadata['injection.language'] = ext
			metadata['injection.combined'] = true
		end
	end, {})

-- Add predicate for mise file detection
require('vim.treesitter.query').add_predicate('is-mise?',
	function(_, _, bufnr, _)
		if not bufnr then
			return false
		end
		local ok, filepath = pcall(vim.api.nvim_buf_get_name, tonumber(bufnr) or 0)
		if not ok or not filepath or filepath == '' then
			return false
		end
		local filename = vim.fn.fnamemodify(filepath, ':t')
		return string.match(filename, '.*mise.*%.toml$') ~= nil
	end, { force = true, all = false })

-- Treesitter Text Objects (repeatable moves)
local ok_tsrm, tsrm = pcall(require,
	'nvim-treesitter.textobjects.repeatable_move')
if not ok_tsrm then
	return
end
vim.keymap.set(
	{ 'n', 'x', 'o' },
	';',
	tsrm.repeat_last_move_next
)
vim.keymap.set(
	{ 'n', 'x', 'o' },
	',',
	tsrm.repeat_last_move_previous
)
vim.keymap.set(
	{ 'n', 'x', 'o' },
	'f',
	tsrm.builtin_f_expr,
	{ expr = true }
)
vim.keymap.set(
	{ 'n', 'x', 'o' },
	'F',
	tsrm.builtin_F_expr,
	{ expr = true }
)
vim.keymap.set(
	{ 'n', 'x', 'o' },
	't',
	tsrm.builtin_t_expr,
	{ expr = true }
)
vim.keymap.set(
	{ 'n', 'x', 'o' },
	'T',
	tsrm.builtin_T_expr,
	{ expr = true }
)
