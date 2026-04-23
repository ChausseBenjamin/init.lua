vim.g.rustaceanvim = {
	server = {
		default_settings = {
			['rust-analyzer'] = {
				-- checkOnSave = false,
				checkOnSave = true,
				check = {
					-- command = 'check',
					command = 'clippy',
					allTargets = false,
					features = {},
					noDefaultFeatures = false,
				},
				numThreads = tonumber(vim.fn.system('getconf _NPROCESSORS_ONLN')) or 4,
				cachePriming = {
					-- enable = false,
					enable = true,
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
					watcher = 'client',
				},
			},
		},
	},
	tools = {
		test_executor = 'background',
	},
}
