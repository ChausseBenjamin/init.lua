return {
	settings = {
		texlab = {
			build = {
				executable = 'xelatex',
				-- executable = 'pdflatex',
				args = { '-pdf', '-interaction=nonstopmode', '-synctex=1', '%f' },
				onSave = true,
				forwardSearchAfter = false,
			},
			chktex = {
				onOpenAndSave = true,
				onEdit = false,
			},
			forwardSearch = {
				executable = 'zathura-nofocus',
				args = { '--synctex-forward', '%l:1:%f', '%p' },
			},
		},
	},
}
