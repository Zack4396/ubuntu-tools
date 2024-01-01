" you can choose another path as your home path
" e.g.
" let g:my_home = "/mnt/nfsroot/user01"
let g:my_home = "$HOME"

" default
let g:my_home = expand(g:my_home)
let g:my_vim = g:my_home . "/.vim"
let g:my_vim_main = g:my_vim . "/main.vim"
if filereadable(g:my_vim_main)
  execute "source " . g:my_vim_main
endif
let g:my_vim_misc = g:my_vim . "/misc.vim"
if filereadable(g:my_vim_misc)
  execute "source " . g:my_vim_misc
else
endif

" 2. Basic Settings
filetype on     " Enable filetype detect
syntax   on     " Enable highlight syntax
set number      " Enable line number
set autoindent  " Enable auto indent
set hlsearch    " Always highlight the search word.
set incsearch   " While typing a search word, highlight it at the same time.

" 3. Vim Diff Theme
hi DiffAdd    ctermbg=235  ctermfg=108  guibg=#262626 guifg=#87af87 cterm=reverse gui=reverse
hi DiffDelete ctermbg=235  ctermfg=131  guibg=#262626 guifg=#af5f5f cterm=reverse gui=reverse
hi DiffChange ctermbg=235  ctermfg=103  guibg=#262626 guifg=#8787af cterm=reverse gui=reverse
hi DiffText   ctermbg=235  ctermfg=208  guibg=#262626 guifg=#ff8700 cterm=reverse gui=reverse

" 4. Restore cursor to file position in previous editing session
set viminfo='10,\"100,:20,n~/.viminfo
au BufReadPost * if line("'\"") > 0|if line("'\"") <= line("$")|exe("norm '\"")|else|exe "norm $"|endif|endif

" Line Number - Switch
nmap <F7> :set invnumber<CR>
