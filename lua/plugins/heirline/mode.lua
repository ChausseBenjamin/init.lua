return {
	hl = 'hline.out.mode',
	{
		init = function(self)
			self.mode = vim.fn.mode(1)
		end,
		static = {
			mode_names = {
				n = "N",
				i = "I",
				v = "V",
				V = "VL",
				["\22"] = "VB",
				c = "C",
				s = "S",
				S = "SL",
				["\19"] = "SB",
				R = "R",
				r = "P",
				["!"] = "SH",
				t = "T",
			},
		},
		provider = function(self)
			return " " .. (self.mode_names[self.mode] or self.mode:upper()) .. " "
		end,
		hl = function(self)
			local mode = self.mode:sub(1, 1)
			local mode_colors = {
				n       = 'hline.out.mode.norm', -- { fg = "#282828", bg = "#a9b665" },
				i       = 'hline.out.mode.insert', -- { fg = "#282828", bg = "#89b482" },
				v       = 'hline.out.mode.vis', -- { fg = "#282828", bg = "#d3869b" },
				V       = 'hline.out.mode.vis', -- { fg = "#282828", bg = "#d3869b" },
				["\22"] = 'hline.out.mode.vis', -- { fg = "#282828", bg = "#d3869b" },
				c       = 'hline.out.mode.cmd', -- { fg = "#282828", bg = "#d8a657" },
				s       = 'hline.out.mode.sel', -- { fg = "#282828", bg = "#d3869b" },
				S       = 'hline.out.mode.sel', -- { fg = "#282828", bg = "#d3869b" },
				["\19"] = 'hline.out.mode.sel', -- { fg = "#282828", bg = "#d3869b" },
				R       = 'hline.out.mode.replace', -- { fg = "#282828", bg = "#ea6962" },
				r       = 'hline.out.mode.replace', -- { fg = "#282828", bg = "#ea6962" },
				["!"]   = 'hline.out.mode.shell', -- { fg = "#282828", bg = "#ea6962" },
				t       = 'hline.out.mode.term', -- { fg = "#282828", bg = "#ea6962" },
			}
			return mode_colors[mode] or 'hline.out.mode.norm'
			-- { fg = "#282828", bg = "#a9b665" }
		end,
		update = {
			"ModeChanged",
			pattern = "*:*",
			callback = vim.schedule_wrap(function()
				vim.cmd("redrawstatus")
			end),
		},
	},
}
