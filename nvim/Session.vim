let SessionLoad = 1
let s:so_save = &g:so | let s:siso_save = &g:siso | setg so=0 siso=0 | setl so=-1 siso=-1
let v:this_session=expand("<sfile>:p")
silent only
silent tabonly
cd ~/dotfiles/nvim
if expand('%') == '' && !&modified && line('$') <= 1 && getline(1) == ''
  let s:wipebuf = bufnr('%')
endif
let s:shortmess_save = &shortmess
if &shortmess =~ 'A'
  set shortmess=aoOA
else
  set shortmess=aoO
endif
badd +1 lua/tsxoxo/lazy/oil.lua
badd +64 lua/tsxoxo/lazy/telescope.lua
badd +17 lua/tsxoxo/remap.lua
badd +26 lua/tsxoxo/lazy/theme.lua
badd +12 lua/tsxoxo/lazy/lua-line.lua
badd +7 lua/tsxoxo/lazy/lint.lua
badd +24 lua/tsxoxo/lazy/lsp/mason.lua
badd +1 init.lua
badd +6 lua/tsxoxo/init.lua
badd +75 README.md
badd +3 lsp/lua_ls.lua
badd +74 lua/tsxoxo/lsp-setup.lua
badd +45 _lspconfig.lua
badd +2 lua/tsxoxo/lazy/treesitter.lua
badd +1 lua/tsxoxo/lazy/auto-session.lua
badd +2 lua/tsxoxo/lazy/init.lua
argglobal
%argdel
tabnext 1
if exists('s:wipebuf') && len(win_findbuf(s:wipebuf)) == 0 && getbufvar(s:wipebuf, '&buftype') isnot# 'terminal'
  silent exe 'bwipe ' . s:wipebuf
endif
unlet! s:wipebuf
set winheight=1 winwidth=20
let &shortmess = s:shortmess_save
let s:sx = expand("<sfile>:p:r")."x.vim"
if filereadable(s:sx)
  exe "source " . fnameescape(s:sx)
endif
let &g:so = s:so_save | let &g:siso = s:siso_save
set hlsearch
nohlsearch
let g:this_session = v:this_session
let g:this_obsession = v:this_session
doautoall SessionLoadPost
unlet SessionLoad
" vim: set ft=vim :
