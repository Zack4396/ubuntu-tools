" 1. Load Basic Vim Plugins
source $HOME/.vim/run-pathogen.vim
source $HOME/.vim/mis-func.vim

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
