local py_helpers = require('bundles.lsp.python')

return {
	cmd = py_helpers.uv_lsp_cmd('ty', { 'server' }),
}
