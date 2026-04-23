--  _       _ _     _
-- (_)_ __ (_) |_  | |_   _  __ _
-- | | '_ \| | __| | | | | |/ _` |
-- | | | | | | |_ _| | |_| | (_| |
-- |_|_| |_|_|\__(_)_|\__,_|\__,_|
--
-- Where it all begins...

-- This config:
-- .
-- ├─ init.lua
-- ├─ ftplugin
-- │  ├─ go.lua
-- │  ├─ rust.lua
-- │  ├─ lua.lua
-- │  └─ etc...
-- └─ lua
--    ├─ core
--    │  ├─ init.lua
--    │  ├─ lang.lua
--    │  ├─ dev.lua
--    │  └─ tools.lua
--    ├─ plugins
--    │  ├─ oil.lua
--    │  ├─ nvim-resize
--    │  └─ etc...
--    └─ bundles
--       ├─ nav.lua
--       ├─ colors.lua
--       └─ etc...
--
-- * Each plugin has it's own lua file.
-- * Ftplugin is in charge of loading filetype specific settings.
-- * When multiple filetypes use the same set of plugins, a bundle is used to
--   avoid redeclaring the plugin set/configuration for each filetype.
-- * Domain specific sets of configs/plugins are also considered bundles
--   (ex: ui, navigations shortcuts, etc...)
-- * Plugins are installed with the new vim.pack(...) instead of having a
--   plugin to load plugins (kinda meta and bloated)
-- * Native LSP is used with the new vim.lsp goodies

-- Nvim Native settings
require('core')
require('core.lang')
require('core.tools')
require('core.plugin-mgr')
require('core.dev')

require('bundles.ui')
require('bundles.keys')
require('bundles.lsp')
require('bundles.git')
require('bundles.nav')
require('bundles.misc')
require('bundles.ai')

DevPack('ChausseBenjamin/rafta.nvim')
local rafta = require('rafta')

rafta.setup({
	logging = {
		level = vim.log.levels.DEBUG,
		formatter = require 'rafta.util.log'.formatters.json
		-- path = '', -- force fallback to vim.notify
	},
})
