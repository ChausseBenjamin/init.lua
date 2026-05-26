let SessionLoad = 1
let s:so_save = &g:so | let s:siso_save = &g:siso | setg so=0 siso=0 | setl so=-1 siso=-1
let v:this_session=expand("<sfile>:p")
doautoall SessionLoadPre
silent only
silent tabonly
cd ~/Workspace/plugins/rafta.nvim
if expand('%') == '' && !&modified && line('$') <= 1 && getline(1) == ''
  let s:wipebuf = bufnr('%')
endif
let s:shortmess_save = &shortmess
set shortmess+=aoO
badd +1 lua/rafta/startup/filetypes.lua
badd +7 tests/assets/raw/rafta:basic-example
badd +10 lua/rafta/ui/init.lua
badd +17 ~/.config/nvim/lua/bundles/misc.lua
badd +24 ~/.config/nvim/lua/core/dev.lua
argglobal
%argdel
tabnew +setlocal\ bufhidden=wipe
tabrewind
edit lua/rafta/startup/filetypes.lua
let s:save_splitbelow = &splitbelow
let s:save_splitright = &splitright
set splitbelow splitright
wincmd _ | wincmd |
vsplit
1wincmd h
wincmd _ | wincmd |
split
1wincmd k
wincmd w
wincmd w
let &splitbelow = s:save_splitbelow
let &splitright = s:save_splitright
wincmd t
let s:save_winminheight = &winminheight
let s:save_winminwidth = &winminwidth
set winminheight=0
set winheight=1
set winminwidth=0
set winwidth=1
exe '1resize ' . ((&lines * 20 + 22) / 45)
exe 'vert 1resize ' . ((&columns * 90 + 79) / 159)
exe '2resize ' . ((&lines * 21 + 22) / 45)
exe 'vert 2resize ' . ((&columns * 90 + 79) / 159)
exe 'vert 3resize ' . ((&columns * 68 + 79) / 159)
tcd ~/Workspace/plugins/rafta.nvim
argglobal
balt ~/Workspace/plugins/rafta.nvim/tests/assets/raw/rafta:basic-example
setlocal foldmethod=manual
setlocal foldexpr=v:lua.vim.treesitter.foldexpr()
setlocal foldmarker={{{,}}}
setlocal foldignore=#
setlocal foldlevel=0
setlocal foldminlines=1
setlocal foldnestmax=20
setlocal foldenable
silent! normal! zE
let &fdl = &fdl
let s:l = 1 - ((0 * winheight(0) + 10) / 20)
if s:l < 1 | let s:l = 1 | endif
keepjumps exe s:l
normal! zt
keepjumps 1
normal! 0
wincmd w
argglobal
if bufexists(fnamemodify("~/Workspace/plugins/rafta.nvim/lua/rafta/ui/init.lua", ":p")) | buffer ~/Workspace/plugins/rafta.nvim/lua/rafta/ui/init.lua | else | edit ~/Workspace/plugins/rafta.nvim/lua/rafta/ui/init.lua | endif
if &buftype ==# 'terminal'
  silent file ~/Workspace/plugins/rafta.nvim/lua/rafta/ui/init.lua
endif
balt ~/Workspace/plugins/rafta.nvim/lua/rafta/startup/filetypes.lua
setlocal foldmethod=manual
setlocal foldexpr=v:lua.vim.treesitter.foldexpr()
setlocal foldmarker={{{,}}}
setlocal foldignore=#
setlocal foldlevel=0
setlocal foldminlines=1
setlocal foldnestmax=20
setlocal foldenable
silent! normal! zE
let &fdl = &fdl
let s:l = 10 - ((9 * winheight(0) + 10) / 21)
if s:l < 1 | let s:l = 1 | endif
keepjumps exe s:l
normal! zt
keepjumps 10
normal! 07|
wincmd w
argglobal
if bufexists(fnamemodify("~/Workspace/plugins/rafta.nvim/tests/assets/raw/rafta:basic-example", ":p")) | buffer ~/Workspace/plugins/rafta.nvim/tests/assets/raw/rafta:basic-example | else | edit ~/Workspace/plugins/rafta.nvim/tests/assets/raw/rafta:basic-example | endif
if &buftype ==# 'terminal'
  silent file ~/Workspace/plugins/rafta.nvim/tests/assets/raw/rafta:basic-example
endif
balt ~/Workspace/plugins/rafta.nvim/lua/rafta/ui/init.lua
setlocal foldmethod=manual
setlocal foldexpr=0
setlocal foldmarker={{{,}}}
setlocal foldignore=#
setlocal foldlevel=0
setlocal foldminlines=1
setlocal foldnestmax=20
setlocal foldenable
silent! normal! zE
let &fdl = &fdl
let s:l = 4 - ((3 * winheight(0) + 21) / 42)
if s:l < 1 | let s:l = 1 | endif
keepjumps exe s:l
normal! zt
keepjumps 4
normal! 011|
wincmd w
exe '1resize ' . ((&lines * 20 + 22) / 45)
exe 'vert 1resize ' . ((&columns * 90 + 79) / 159)
exe '2resize ' . ((&lines * 21 + 22) / 45)
exe 'vert 2resize ' . ((&columns * 90 + 79) / 159)
exe 'vert 3resize ' . ((&columns * 68 + 79) / 159)
tabnext
edit ~/.config/nvim/lua/core/dev.lua
let s:save_splitbelow = &splitbelow
let s:save_splitright = &splitright
set splitbelow splitright
wincmd _ | wincmd |
split
1wincmd k
wincmd w
let &splitbelow = s:save_splitbelow
let &splitright = s:save_splitright
wincmd t
let s:save_winminheight = &winminheight
let s:save_winminwidth = &winminwidth
set winminheight=0
set winheight=1
set winminwidth=0
set winwidth=1
exe '1resize ' . ((&lines * 20 + 22) / 45)
exe '2resize ' . ((&lines * 21 + 22) / 45)
tcd ~/.config/nvim
argglobal
balt ~/.config/nvim/lua/bundles/misc.lua
setlocal foldmethod=manual
setlocal foldexpr=v:lua.vim.treesitter.foldexpr()
setlocal foldmarker={{{,}}}
setlocal foldignore=#
setlocal foldlevel=0
setlocal foldminlines=1
setlocal foldnestmax=20
setlocal foldenable
silent! normal! zE
let &fdl = &fdl
let s:l = 24 - ((10 * winheight(0) + 10) / 20)
if s:l < 1 | let s:l = 1 | endif
keepjumps exe s:l
normal! zt
keepjumps 24
normal! 0
wincmd w
argglobal
enew | setl bt=help
help 
balt ~/.config/nvim/lua/core/dev.lua
setlocal foldmethod=manual
setlocal foldexpr=0
setlocal foldmarker={{{,}}}
setlocal foldignore=#
setlocal foldlevel=0
setlocal foldminlines=1
setlocal foldnestmax=20
setlocal nofoldenable
silent! normal! zE
let &fdl = &fdl
let s:l = 89 - ((19 * winheight(0) + 10) / 21)
if s:l < 1 | let s:l = 1 | endif
keepjumps exe s:l
normal! zt
keepjumps 89
normal! 048|
wincmd w
exe '1resize ' . ((&lines * 20 + 22) / 45)
exe '2resize ' . ((&lines * 21 + 22) / 45)
tabnext 2
if exists('s:wipebuf') && len(win_findbuf(s:wipebuf)) == 0 && getbufvar(s:wipebuf, '&buftype') isnot# 'terminal'
  silent exe 'bwipe ' . s:wipebuf
endif
unlet! s:wipebuf
set winheight=1 winwidth=20
let &shortmess = s:shortmess_save
let &winminheight = s:save_winminheight
let &winminwidth = s:save_winminwidth
let s:sx = expand("<sfile>:p:r")."x.vim"
if filereadable(s:sx)
  exe "source " . fnameescape(s:sx)
endif
let &g:so = s:so_save | let &g:siso = s:siso_save
set hlsearch
doautoall SessionLoadPost
unlet SessionLoad
" vim: set ft=vim :
