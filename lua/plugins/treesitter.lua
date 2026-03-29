--  _                      _ _   _
-- | |_ _ __ ___  ___  ___(_) |_| |_ ___ _ __
-- | __| '__/ _ \/ _ \/ __| | __| __/ _ \ '__|
-- | |_| | |  __/  __/\__ \ | |_| ||  __/ |
--  \__|_|  \___|\___||___/_|\__|\__\___|_|
--
-- Sweet, sweet AST-based syntax

vim.pack.add {
	{ src = GH .. 'nvim-treesitter/nvim-treesitter' },
	{ src = GH .. 'nvim-treesitter/nvim-treesitter-textobjects' }
}

-- Add custom parser for Pest
local parser_config = require('nvim-treesitter.parsers').get_parser_configs()
parser_config.pest = {
	install_info = {
		url = "https://github.com/pest-parser/tree-sitter-pest",
		files = { "src/parser.c" },
		branch = "main",
		generate_requires_npm = false,
	},
	filetype = "pest",
}

-- Add custom parser for Go templates
parser_config.gotmpl = {
	install_info = {
		url = "https://github.com/ngalaiko/tree-sitter-go-template",
		files = { "src/parser.c" },
		branch = "master",
		generate_requires_npm = false,
	},
	filetype = "gotmpl",
}

-- Add filetype detection for template files
vim.filetype.add({
	extension = {
		pest = 'pest',
		tmpl = 'gotmpl',
	},
})

-- Base treesitter config
local configs = require('nvim-treesitter.configs')
configs.setup({
	ensure_installed = {
		'bash',
		'c',
		'diff',
		'go',
		'gotmpl',
		'graphql',
		'javascript',
		'json',
		'lua',
		'markdown',
		'markdown_inline',
		'mermaid',
		'python',
		'rust',
		'toml',
		'typescript',
		'typst',
		'yaml',
		'zig',
	},
	sync_install = false,
	ignore_install = {},
	auto_install = true,
	modules = {},
	highlight = { enable = true },
	indent = { enable = false },
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

-- Add custom directive for filename-based injection
vim.treesitter.query.add_directive("inject-by-filename!", function(_, _, bufnr, _, metadata)
	local fname = vim.fs.basename(vim.api.nvim_buf_get_name(bufnr))
	-- Match pattern like "file.ext.tmpl" and extract "ext"
	local ext = fname:match("%.(%w+)%.tmpl$")
	if ext then
		metadata["injection.language"] = ext
		metadata["injection.combined"] = true
	end
end, {})

-- Add predicate for mise file detection
require('vim.treesitter.query').add_predicate('is-mise?',
	function(_, _, bufnr, _)
		local filepath = vim.api.nvim_buf_get_name(tonumber(bufnr) or 0)
		local filename = vim.fn.fnamemodify(filepath, ':t')
		return string.match(filename, '.*mise.*%.toml$') ~= nil
	end, { force = true, all = false })

-- Treesitter Text Objects (repeatable moves)
local tsrm = require('nvim-treesitter.textobjects.repeatable_move')
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
-- Also use `;` and `,` with the default vim `f` and `F`
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
