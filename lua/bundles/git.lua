--        _ _
--   __ _(_) |_
--  / _` | | __|
-- | (_| | | |_
--  \__, |_|\__|
--  |___/
--
-- Because making linux wasn't enough for Torvalds


-- Not lazy-loaded when entering a repo since
-- yadm uses bare git repos (harder to detect)
require('plugins.fugitive')
require('plugins.gitsigns')
require('plugins.worktree')
require('plugins.jujutsu')
