local py_helpers = require('bundles.lsp.python')

return {
	cmd = py_helpers.uv_lsp_cmd('ruff', { 'server' }),
	init_options = {
		settings = {
			lineLength = 80,
		},
	},
}
