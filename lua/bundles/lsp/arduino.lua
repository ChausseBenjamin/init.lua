-- Configure arduino_language_server for .ino sketches
-- Requires: arduino-cli, clangd, and sketch.yaml in project root
-- Create sketch.yaml with: arduino-cli board attach -p /dev/ttyACM0 -b arduino:avr:uno your_sketch.ino
vim.lsp.config('arduino-language-server', {
	cmd = { 'arduino-language-server' },
	filetypes = { 'arduino' },
	root_markers = { '*.ino', 'sketch.yaml' },
})
