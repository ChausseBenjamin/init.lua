-- Helper utilities for python-related LSP servers
local M = {}

-- Returns a cmd function suitable for use as { cmd = <fn> } in an LSP config.
-- The function will try: project .venv/<tool>, then global <tool>.
M.uv_lsp_cmd = function(tool_name, args)
	return function(dispatchers, config)
		local root_dir = config.root_dir
		if root_dir then
			local venv_tool = root_dir .. '/.venv/bin/' .. tool_name
			local pyproject = root_dir .. '/pyproject.toml'

			if vim.fn.filereadable(pyproject) == 1 and vim.fn.executable(venv_tool) == 0 then
				vim.notify(
				string.format('Auto-installing %s via uv add --dev...', tool_name),
					vim.log.levels.INFO)
				local result = vim.fn.system(string.format(
				'cd %s && uv add --dev %s 2>&1', vim.fn.shellescape(root_dir), tool_name))
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

			if vim.fn.executable(venv_tool) == 1 then
				local cmd = vim.list_extend({ venv_tool }, args or {})
				return vim.lsp.rpc.start(cmd, dispatchers, { cwd = root_dir })
			end
		end

		if vim.fn.executable(tool_name) == 1 then
			local cmd = vim.list_extend({ tool_name }, args or {})
			return vim.lsp.rpc.start(cmd, dispatchers, { cwd = root_dir })
		end

		vim.notify(
		string.format('%s not found. Install with: uv add --dev %s', tool_name,
			tool_name), vim.log.levels.WARN)
		error(string.format('%s not found', tool_name))
	end
end

return M
