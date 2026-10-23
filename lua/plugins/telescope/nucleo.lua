--                 _
--  _ __  _   _  ___| | ___  ___
-- | '_ \| | | |/ __| |/ _ \/ _ \
-- | | | | |_| | (__| |  __/ (_) |
-- |_| |_|\__,_|\___|_|\___|\___/
--
-- I can't believe I haven't grown cat ears at this point...

-- telescope-nucleo-sorter.nvim ships Rust source, not a compiled module, and
-- vim.pack has no build step (:help vim.pack.Spec carries only `data`, `name`,
-- `src` and `version`). So we build the shared library ourselves, in two ways:
--
--   * on startup, whenever the library is missing (self-heal: first install,
--     an interrupted/killed build, a failed build, or a hand-cleaned target/);
--   * on PackChanged 'update', when `:packupdate` moves the plugin's source.
--
-- The startup check runs after vim.pack.add(), which both installs the plugin
-- (vim.pack waits for install to finish) and puts it on 'runtimepath' via
-- :packadd, so the library can be found by its path under the plugin dir.
--
-- Because a missing library is re-checked on every launch, a broken build (or
-- a cargo that is not on PATH) would otherwise spawn a doomed `cargo` each
-- time. A small state file records the revision we last attempted, and the
-- build is retried only when that revision changes or RETRY_AFTER has passed.

local repo = 'AntoineGagne/telescope-nucleo-sorter.nvim'
local name = repo:match('[^/]+$')

local is_mac = vim.uv.os_uname().sysname == 'Darwin'
local lib = ('target/release/libnucleo_nvim.%s'):format(is_mac and 'dylib' or 'so')

-- Seconds after which a failed build for the same revision is retried.
local RETRY_AFTER = 60 * 60
local state_path = vim.fs.joinpath(vim.fn.stdpath 'state', 'telescope-nucleo-build.json')

local function notify(msg, level)
	vim.schedule(function() vim.notify(msg, level) end)
end

<<<<<<< HEAD
local build = { 'cargo', '+stable', 'rustc', '--release' }
if vim.uv.os_uname().sysname == 'Darwin' then
	vim.list_extend(build,
		{ '--', '-C', 'link-arg=-undefined', '-C', 'link-arg=dynamic_lookup' })
||||||| a4d8b8a
local build = { 'cargo', 'rustc', '--release' }
if vim.uv.os_uname().sysname == 'Darwin' then
	vim.list_extend(build,
		{ '--', '-C', 'link-arg=-undefined', '-C', 'link-arg=dynamic_lookup' })
=======
local function notify_once(msg, level)
	vim.schedule(function() vim.notify_once(msg, level) end)
>>>>>>> 74825e498050b591a0462fd1d98dbd8fbeab7871
end

local function read_state()
	local fd = vim.uv.fs_open(state_path, 'r', 420)
	if not fd then return {} end
	local stat = vim.uv.fs_fstat(fd)
	local data = stat and vim.uv.fs_read(fd, stat.size, 0)
	vim.uv.fs_close(fd)
	local ok, decoded = pcall(vim.json.decode, data or '')
	return ok and decoded or {}
end

local function write_state(state)
	vim.fn.mkdir(vim.fn.stdpath 'state', 'p')
	local fd = vim.uv.fs_open(state_path, 'w', 420)
	if not fd then return end
	vim.uv.fs_write(fd, vim.json.encode(state))
	vim.uv.fs_close(fd)
end

-- Where vim.pack installed the plugin; works for active plugins and for
-- lockfile entries that are not loaded this session.
local function plug_path()
	local p = vim.pack.get({ name })[1]
	return p and p.path
end

local function rev_at(path)
	local res = vim.system({ 'git', '-C', path, 'rev-parse', 'HEAD' }, { text = true }):wait()
	return res.code == 0 and vim.trim(res.stdout) or nil
end

local function cargo_cmd()
	local cmd = { 'cargo', 'rustc', '--release' }
	-- A cdylib on macOS needs the symbols resolved at load time by the host.
	if is_mac then
		vim.list_extend(cmd,
			{ '--', '-C', 'link-arg=-undefined', '-C', 'link-arg=dynamic_lookup' })
	end
	return cmd
end

--- Compile the shared library, unless this exact revision was already
--- attempted within the throttle window.
--- @param opts? { force?: boolean } force rebuilds regardless of the throttle
local function build(opts)
	opts = opts or {}
	local path = plug_path()
	if not path then return end

	local rev = rev_at(path)
	local state = read_state()
	local throttled = rev ~= nil and state.rev == rev
		and type(state.time) == 'number' and (os.time() - state.time) < RETRY_AFTER
	if not opts.force and throttled then
		return
	end

	if vim.fn.executable 'cargo' ~= 1 then
		notify_once(('nucleo sorter: cargo not on PATH, build manually in %s')
			:format(path), vim.log.levels.ERROR)
		return
	end

	write_state { rev = rev, time = os.time() }

	local ok, err = pcall(vim.system, cargo_cmd(), { cwd = path, text = true },
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
end

-- Rebuild when `:packupdate` moves this plugin's source. The install case is
-- covered by the startup check below, so only updates need an event.
vim.api.nvim_create_autocmd('PackChanged', {
	callback = function(ev)
		if ev.data.spec.name ~= name then return end
		if ev.data.kind ~= 'update' then return end
		build { force = true }
	end,
})

vim.pack.add {
	{ src = GH .. repo },
}

-- vim.pack.add() has now installed the plugin and run :packadd, so the library
-- resolves against 'runtimepath'.
if vim.api.nvim_get_runtime_file(lib, false)[1] then
	require('telescope').load_extension('nucleo')
else
	build() -- self-heal; activation happens on the next :restart
end
