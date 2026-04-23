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
	'jsonls',
	-- 'arduino_language_server',
	-- No 'rust_analyzer' as it's handled by rustaceanvim
})

require('bundles.lsp.arduino')
require('bundles.lsp.latex')
require('bundles.lsp.lua')
require('bundles.lsp.python')
require('bundles.lsp.rust')
require('bundles.lsp.typst')

-- Load more stuff now that the lsp is installed+configured
require('plugins.blink')

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
		local client = vim.lsp.get_client_by_id(ev.data.client_id)
		if client then
			local orig_handler = client.handlers['textDocument/publishDiagnostics']
					or vim.lsp.handlers['textDocument/publishDiagnostics']
			client.handlers['textDocument/publishDiagnostics'] = function(err, params,
																																		ctx)
				if params and params.diagnostics then
					local filtered = {}
					for _, diag in ipairs(params.diagnostics) do
						local is_summary = false
						if diag.relatedInformation then
							for _, ri in ipairs(diag.relatedInformation) do
								if ri.message == 'original diagnostic' then
									is_summary = true
									break
								end
							end
						end
						if not is_summary then
							table.insert(filtered, diag)
						end
					end
					params.diagnostics = filtered
				end
				orig_handler(err, params, ctx)
			end
		end

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
