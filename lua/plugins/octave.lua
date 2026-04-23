--             _
--   ___   ___| |_ __ ___   _____
--  / _ \ / __| __/ _` \ \ / / _ \
-- | (_) | (__| || (_| |\ V /  __/
-- \___/ \___|\__\__,_| \_/ \___|
--
-- F*ck MATLAB

vim.pack.add({
	{ src = GH .. 'gnu-octave/vim-octave' },
	{ src = GH .. 'NewComer00/octavetui.vim' },
})

vim.g.octavetui_octave_executable = '/home/master/.local/bin/woctave-cli'

local lspconfig = require('lspconfig')
local lspconfig_config = require('lspconfig.configs')
-- mlang
if not lspconfig_config.mlang then
	local mlang_server = '/home/master/.local/share/mlang/server.js'
	lspconfig_config.mlang = {
		default_config = {
			name = 'mlang',
			cmd = { 'node', mlang_server, '--stdio' },
			filetypes = { 'matlab', 'octave', 'm' },
			root_dir = function()
				return vim.fn.getcwd()
			end,
			settings = {
				settings = {
					maxNumberOfProblems = 1000,
				},
			},
		},
	}
end
