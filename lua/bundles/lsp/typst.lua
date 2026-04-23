-- Configure tinymist for PDF export on type
vim.lsp.config('tinymist', {
	settings = {
		exportPdf = 'onType',
		outputPath = '$root/target/$dir/$name',
		formatterMode = 'typstyle',
	}
})
