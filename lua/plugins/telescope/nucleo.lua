--                 _
--  _ __  _   _  ___| | ___  ___
-- | '_ \| | | |/ __| |/ _ \/ _ \
-- | | | | |_| | (__| |  __/ (_) |
-- |_| |_|\__,_|\___|_|\___|\___/
--
-- I can't believe I haven't grown cat ears at this point...

-- telescope-nucleo-sorter.nvim ships Rust source, not a compiled module, and
-- vim.pack has no build step (:help vim.pack.Spec carries only `data`, `name`,
-- `src` and `version`). The cargo invocation therefore lives in a PackChanged
-- hook.
--
-- Registration order matters: vim.pack only emits PackChanged for plugins it
-- is actually installing (lua/vim/pack.lua: `if not p.info.installed`), so a
-- hook registered after vim.pack.add() misses a first-time install entirely.
-- Afterwards it fires on install/update only, never on an ordinary startup.

local repo = 'AntoineGagne/telescope-nucleo-sorter.nvim'
local name = repo:match('[^/]+$')
local lib = ('target/release/libnucleo_nvim.%s'):format(
	vim.uv.os_uname().sysname == 'Darwin' and 'dylib' or 'so')

local function notify(msg, level)
	vim.schedule(function() vim.notify(msg, level) end)
end

local build = { 'cargo', 'rustc', '--release' }
if vim.uv.os_uname().sysname == 'Darwin' then
	vim.list_extend(build,
		{ '--', '-C', 'link-arg=-undefined', '-C', 'link-arg=dynamic_lookup' })
end

vim.api.nvim_create_autocmd('PackChanged', {
	callback = function(ev)
		if ev.data.spec.name ~= name then return end
		if ev.data.kind ~= 'install' and ev.data.kind ~= 'update' then return end

		local ok, err = pcall(vim.system, build, { cwd = ev.data.path, text = true },
			function(res)
				if res.code == 0 then
					notify('nucleo sorter: built, :restart to activate')
				else
					notify('nucleo sorter: build failed\n' .. (res.stderr or ''),
						vim.log.levels.ERROR)
				end
			end)
		if not ok then
			notify('nucleo sorter: could not run cargo\n' .. tostring(err),
				vim.log.levels.ERROR)
		end
	end,
})

vim.pack.add {
	{ src = GH .. repo },
}

if vim.api.nvim_get_runtime_file(lib, false)[1] then
	require('telescope').load_extension('nucleo')
else
	vim.notify_once(
		'nucleo sorter: ' .. lib .. ' not built yet, :restart once cargo finishes',
		vim.log.levels.WARN)
end
