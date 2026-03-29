--  _
-- | |___ _ __
-- | / __| '_ \
-- | \__ \ |_) |
-- |_|___/ .__/
--       |_|
--
-- Custom tweaks to pre-made lsp configurations

vim.pack.add {
	{ src = GH .. 'neovim/nvim-lspconfig' },
}
DevPack('mrcjkb/rustaceanvim')

vim.lsp.enable({
	'gopls',
	'golangci_lint_ls',
	'lua_ls',
	'bashls',
	'ruff',
	'zls',
	'ty',
	'tinymist',
	'texlab',
	-- No 'rust_analyzer' as it's handled by rustaceanvim
})

-- Use new vim.lsp.config API for texlab
vim.lsp.config('texlab', {
	settings = {
		texlab = {
			build = {
				executable = 'pdflatex',
				args = { '-pdf', '-interaction=nonstopmode', '-synctex=1', '%f' },
				onSave = true,
				forwardSearchAfter = false,
			},
			chktex = {
				onOpenAndSave = true,
				onEdit = false,
			},
			forwardSearch = {
				executable = 'zathura-nofocus',
				args = { '--synctex-forward', '%l:1:%f', '%p' },
			},
		},
	},
})

vim.g.rustaceanvim = {
	server = {
		default_settings = {
			['rust-analyzer'] = {
				checkOnSave = false,
				check = {
					command = "check",
					allTargets = false,
					features = {},
					noDefaultFeatures = false,
				},
				numThreads = tonumber(vim.fn.system('getconf _NPROCESSORS_ONLN')) or 4,
				cachePriming = {
					enable = false,
				},
				procMacro = {
					enable = true,
				},
				cargo = {
					buildScripts = {
						enable = true,
						rebuildOnSave = true,
					},
					targetDir = true,
					autoreload = true,
				},
				lru = {
					capacity = 512,
				},
				diagnostics = {
					experimental = {
						enable = false,
					},
				},
				files = {
					watcher = "client",
				},
			},
		},
	},
	tools = {
		test_executor = "background",
	},
}


-- Load more stuff now that the lsp is installed
require('plugins.blink')

-- tweaks to mute lua errors in the Neovim config:
vim.lsp.config('lua_ls', {
	settings = {
		Lua = {
			workspace = {
				library = vim.api.nvim_get_runtime_file('', true)
			}
		}
	}
})

-- Helper function to auto-install and start LSP tools from uv projects
local function uv_lsp_cmd(tool_name, args)
	return function(dispatchers, config)
		local root_dir = config.root_dir
		if root_dir then
			local venv_tool = root_dir .. '/.venv/bin/' .. tool_name
			local pyproject = root_dir .. '/pyproject.toml'

			-- If pyproject.toml exists but tool is not installed, install it
			if vim.fn.filereadable(pyproject) == 1 and vim.fn.executable(venv_tool) == 0 then
				vim.notify(
				string.format('Auto-installing %s via uv add --dev...', tool_name),
					vim.log.levels.INFO)
				local result = vim.fn.system(string.format(
					'cd %s && uv add --dev %s 2>&1',
					vim.fn.shellescape(root_dir), tool_name))
				if vim.v.shell_error ~= 0 then
					vim.notify(
					string.format('Failed to install %s: %s', tool_name, result),
						vim.log.levels.ERROR)
					error(string.format('%s installation failed', tool_name))
				else
					vim.notify(string.format('%s installed successfully', tool_name),
						vim.log.levels.INFO)
				end
			end

			-- Now check if tool is available in venv
			if vim.fn.executable(venv_tool) == 1 then
				local cmd = vim.list_extend({ venv_tool }, args or {})
				return vim.lsp.rpc.start(cmd, dispatchers, { cwd = root_dir })
			end
		end

		-- Fall back to global tool if available
		if vim.fn.executable(tool_name) == 1 then
			local cmd = vim.list_extend({ tool_name }, args or {})
			return vim.lsp.rpc.start(cmd, dispatchers, { cwd = root_dir })
		end

		-- If no tool found anywhere, notify and don't start server
		vim.notify(
		string.format('%s not found. Install with: uv add --dev %s', tool_name,
			tool_name), vim.log.levels.WARN)
		error(string.format('%s not found', tool_name))
	end
end

-- Configure ruff to follow 80 column limit and use uv environment if available
vim.lsp.config('ruff', {
	cmd = uv_lsp_cmd('ruff', { 'server' }),
	init_options = {
		settings = {
			lineLength = 80,
		}
	}
})

-- Configure tinymist for PDF export on type
vim.lsp.config('tinymist', {
	settings = {
		exportPdf = "onType",
		outputPath = "$root/target/$dir/$name",
		formatterMode = "typstyle",
	}
})

-- Configure ty to use uv environment if available
vim.lsp.config('ty', {
	cmd = uv_lsp_cmd('ty', { 'server' }),
})


local lsp_keys = {
	{
		k = '<leader>r',
		f = vim.lsp.buf.rename,
		d = 'Rename object across all occurences'
	},
	{
		k = '<leader>fa',
		f = vim.lsp.buf.code_action,
		d = 'Run code Action'
	},
	{
		k = 'K',
		f = vim.lsp.buf.hover,
		d = 'Show object description on hover',
	},
	{
		k = 'gd',
		f = vim.lsp.buf.definition,
		d = 'Go to the location where the object is defined',
	},
	{
		k = 'gt',
		f = vim.lsp.buf.type_definition,
		d = 'Go to the definition of the objects type'
	},
	{
		k = 'gi',
		f = vim.lsp.buf.implementation,
		d = 'Go to the method implementation'
	},
	{
		k = 'gl',
		f = vim.lsp.buf.references,
		d = 'Go to references of the object'
	},
	{
		k = ']d',
		f = function() vim.diagnostic.jump({ count = 1, float = true }) end,
		d = 'Go to the next diagnostic/issue'
	},
	{ -- S is the same as cc, I'd rather use it for something more useful
		k = '[d',
		f = function() vim.diagnostic.jump({ count = -1, float = true }) end,
		d = 'Go to the previous diagnostic/issue'
	},
	{
		k = 'S',
		f = vim.diagnostic.open_float,
		d = 'View diagnostics information in a floating window',
	},
	{
		k = '<leader>z',
		f = function()
			local tex_file = vim.fn.expand('%:p')
			local pdf_file = vim.fn.fnamemodify(tex_file, ':r') .. '.pdf'
			local line = vim.fn.line('.')
			vim.fn.system(string.format(
				'zathura --synctex-forward="%d:1:%s" "%s" &',
				line, tex_file, pdf_file
			))
		end,
		d = 'Forward search to PDF (Zathura)'
	},
}

-- Bootstrap shortcuts on LspAttach
vim.api.nvim_create_autocmd('LspAttach', {
	callback = function(ev)
		-- Attach LSP keybinds to the current buffer
		for _, map in ipairs(lsp_keys) do
			vim.keymap.set('n', map.k, map.f, { desc = map.desc, buffer = ev.buf })
		end

		-- Override gq to use built-in text wrapping instead of formatprg
		vim.opt_local.formatprg = ''
		vim.opt_local.formatexpr = ''
	end
})

-- Populate quickfix with diagnostics on LSP notify
vim.api.nvim_create_autocmd('LspNotify', {
	callback = function(args)
		if args.data.method == 'textDocument/publishDiagnostics' then
			vim.diagnostic.setqflist()
		end
	end,
})

-- Format on save
vim.api.nvim_create_autocmd('BufWritePre', {
	callback = function()
		local orig_notify = vim.notify
		---@diagnostic disable-next-line: duplicate-set-field
		vim.notify = function(_, _) end
		vim.lsp.buf.format({ async = false })
		vim.notify = orig_notify
	end,
})

-- Override formatprg for all files to use built-in text wrapping
vim.api.nvim_create_autocmd('FileType', {
	pattern = '*',
	callback = function()
		vim.opt_local.formatprg = ''
		vim.opt_local.formatexpr = ''
		vim.opt_local.textwidth = 80 -- Force textwidth to 80
	end,
})
