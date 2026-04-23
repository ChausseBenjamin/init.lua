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

-- Configure ty to use uv environment if available
vim.lsp.config('ty', {
	cmd = uv_lsp_cmd('ty', { 'server' }),
})
