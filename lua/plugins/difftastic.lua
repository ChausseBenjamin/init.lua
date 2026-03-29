--      _ _  __  __ _            _   _
--   __| (_)/ _|/ _| |_ __ _ ___| |_(_) ___
--  / _` | | |_| |_| __/ _` / __| __| |/ __|
-- | (_| | |  _|  _| || (_| \__ \ |_| | (__
--  \__,_|_|_| |_|  \__\__,_|___/\__|_|\___|
--
-- Syntax aware diffs

vim.pack.add({
	{ src = GH .. 'clabby/difftastic.nvim' },
	{ src = GH .. 'MunifTanjim/nui.nvim' },
	{ src = GH .. 'clabby/difftastic.nvim' },
})

require("difftastic-nvim").setup({
    download = false,              -- Auto-download pre-built binary (default: false)
    vcs = "jj",                    -- "jj" (default) or "git"
    highlight_mode = "treesitter", -- "treesitter" (default) or "difftastic"
    hunk_wrap_file = true,          -- Next hunk at last hunk goes to next file
    scroll_to_first_hunk = true,  -- Auto-scroll to first hunk after opening a file (default: true)
    snacks_picker = {
        enabled = false,          -- opt-in snacks.nvim integration (default: false)
        limit = 200,              -- number of revisions/commits to list in :DifftPick
        jj_log_revset = nil,      -- optional: jj revset for picker log (nil = omit -r and use jj default)
    },
    keymaps = {
        next_file = "]f",
        prev_file = "[f",
        next_hunk = "]c",
        prev_hunk = "[c",
        close = "q",
        focus_tree = "<Tab>",
        focus_diff = "<Tab>",
        select = "<CR>",
        goto_file = "gf",
    },
    tree = {
        width = 40,
        icons = {
            enable = true,    -- use nvim-web-devicons if available
            dir_open = "",
            dir_closed = "",
        },
    },
    highlights = {
        -- Override any highlight group (see Highlight Groups below)
        -- DifftAdded = { bg = "#2d4a3e" },
    },
})
