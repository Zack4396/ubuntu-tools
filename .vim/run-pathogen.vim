"
" VIM Plugin manager tools - <Pathogen>
"
" Github: https://github.com/tpope/vim-pathogen
" 
" DIY Install:
"   1) Copy 'run-pathogen.vim' & 'run-pathogen.sh' into '$HOME/.vim/'
"     $ cp run-pathogen.vim $HOME/.vim/
"     $ cp run-pathogen.sh $HOME/.vim/
"
" Configure:
"   2) Run 'run-pathogen.sh' to install the plugins
"     # -a                  - install all plugins
"     # -i <plugins name>   - install <plugin_name>
"     # -l                  - show installed plugins
"     # -t                  - show supported plugins
"     #
"     $ bash $HOME/.vim/run-pathogen.sh -a
"   
"   3) Add a new line at the begin of '$HOME/.vimrc'
"     + source $HOME/.vim/run-pathogen.vim
"
" Load Once:
if exists('g:loaded_run_pathogen_vim')
  finish
endif
let g:loaded_run_pathogen_vim = 1

" Fixed from https://github.com/tpope/vim-pathogen/issues/50#issuecomment-51521621
if has('win32') || has('win64')
    set runtimepath=$HOME/.vim,$VIM/vimfiles,$VIMRUNTIME,$VIM/vimfiles/after,$HOME/.vim/after
    set nocompatible
    set backspace=2
    set mouse=
    set lines=999 columns=999
    set guioptions+=m
    set guifont=Consolas:h12
endif

" --------------------------------------------------------------------------------------------------
" **************************************************************************************************
" *                               Plugin Enable/Disable - Global Hold                              *
" **************************************************************************************************
"  [Disable it] - let s:bypass_*** = 1
"  [Enable  it] - let s:bypass_*** = 0
" --------------------------------------------------------------------------------------------------
let g:ignore_warning_msg      = 1
let s:bypass_pathogen         = 0
let s:bypass_winmanager       = 0
let s:bypass_nerd_tree        = 0
let s:bypass_minibufexplorer  = 0
let s:bypass_taglist          = 0
let s:bypass_tagbar           = 0
let s:bypass_lightline        = 0
let s:bypass_airline          = 0
let s:bypass_airline_themes   = 0
let s:bypass_colors_solarized = 0
let s:bypass_colorschemes     = 0
let s:bypass_youcompleteme    = 0
let s:bypass_coc              = 0
let s:bypass_global           = 0
let s:bypass_ctrlp            = 0
let s:bypass_drawit           = 0

" --------------------------------------------------------------------------------------------------
"  let g:loaded_pathogen = 1                  "pathogen " [O] From ~/.vim/autoload/pathogen.vim
"  let g:loaded_winmanager = 1              "winmanager " [O] From ~/.vim/bundle/winmanager/plugin/winmanager.vim
"  let g:loaded_nerd_tree = 1                "nerd_tree " [O] From ~/.vim/bundle/nerdtree/plugin/NERD_tree.vim'
"  let g:loaded_minibufexplorer = 1    "minibufexplorer " [O] From ~/.vim/bundle/bufexplorer/plugin/minibufexpl.vim
"  let g:loaded_taglist = 1                    "taglist " [O] From ~/.vim/bundle/taglist/plugin/taglist.vim
"  let g:loaded_tagbar = 1                      "tagbar " [O] From ~/.vim/bundle/tagbar/plugin/tagbar.vim
"  let g:loaded_lightline = 1                "lightline " [O] From ~/.vim/bundle/lightline/plugin/lightline.vim
"  let g:loaded_airline = 1                    "airline " [O] From ~/.vim/bundle/airline/plugin/airline.vim
"  let g:loaded_airline_themes = 1       "airline_theme " [O] From ~/.vim/bundle/airline_themes/plugin/airline-themes.vim
"  let g:loaded_colors_solarized = 1  "colors_solarized " [O] From none
"  let g:loaded_colorschemes = 1          "colorschemes " [O] From none
"  let g:loaded_youcompleteme = 1        "youcompleteme " [O] From ~/.vim/bundle/youcompleteme/plugin/youcompleteme.vim
"  let g:did_coc_loaded = 1                   "coc nvim " [O] From ~/.vim/bundle/coc.nvim/plugin/coc.vim
"  let g:loaded_gtags_cscope = 1          "gtags-cscope " [O] From ~/.vim/bundle/global-6.6.9/plugin/gtags-cscope.vim
"  let g:loaded_gtags = 1                        "gtags " [O] From ~/.vim/bundle/global-6.6.9/plugin/gtags.vim
"  let g:loaded_ctrlp = 1                        "ctrlp " [O] From ~/.vim/bundle/ctrlp/plugin/ctrlp.vim
"  let g:loaded_DrawItPlugin = 1                 "drawit" [O] From ~/.vim/bundle/drawIt/plugin/DrawItPlugin.vim
" --------------------------------------------------------------------------------------------------

function DecouplePlugins()
  " If you enable coc.nvim, let's disable youcompleteme by default
  if !(exists('s:bypass_coc') && s:bypass_coc)
    let s:bypass_youcompleteme = 1
  endif

  " If you didn't install ctags, let's disable taglist/tagbar by default
  if !executable('ctags')
    let s:bypass_taglist = 1
    let s:bypass_tagbar = 1
  endif
endfunction

" --------------------------------------------------------------------------------------------------
" Plugins: Plugins AutoLoad                 -   g:loaded_pathogen
" --------------------------------------------------------------------------------------------------
"| 1). <pathogen>
"                                                              https://github.com/tpope/vim-pathogen
" --------------------------------------------------------------------------------------------------
function Check_kiki_pathogen()
  if !filereadable(expand("$HOME/.vim/autoload/pathogen.vim"))
    if !g:ignore_warning_msg
      echom expand("please run    bash $HOME/.vim/run-pathogen.sh -i pathogen")
    endif
    let g:loaded_pathogen = 1
  else
    " If you define this local variable and set it to 1: Plugin won't be loaded.
    "
    " And the custom settings will be disabled.
    "
    if exists('s:bypass_pathogen') && s:bypass_pathogen
      let g:loaded_pathogen = 1
    endif
  endif
endfunction
" --------------------------------------------------------------------------------------------------
" Plugins: File Tree                        -   g:loaded_winmanager
"                                               (show select Floder, it can mark the folder)
"                                               use 'f' to mark
"
"                                           -   g:loaded_nerd_tree 
"                                               (Show Current Floder tree, but it can't mark the floder)
" --------------------------------------------------------------------------------------------------
"| 1). <winmanager>
"                                                          https://github.com/vim-scripts/winmanager
" --------------------------------------------------------------------------------------------------
function Check_kiki_winmanager()
  if !filereadable(expand("$HOME/.vim/bundle/winmanager/plugin/winmanager.vim"))
    if !g:ignore_warning_msg
      echom expand("please run    bash $HOME/.vim/run-pathogen.sh -i winmanager")
    endif
    let s:loaded_winmanager = 1
  else
    " If you define this local variable and set it to 1: Plugin won't be loaded.
    "
    " And the custom settings will be disabled.
    "
    if exists('s:bypass_winmanager') && s:bypass_winmanager
      let g:loaded_winmanager = 1
    endif
  endif
endfunction
" --------------------------------------------------------------------------------------------------
"| 2). <nerdtree_red>
"                                                             https://github.com/scrooloose/nerdtree
" --------------------------------------------------------------------------------------------------
function Check_kiki_nerdtree_red()
  if !filereadable(expand("$HOME/.vim/bundle/nerdtree/plugin/NERD_tree.vim"))
    if !g:ignore_warning_msg
      echom expand("please run    bash $HOME/.vim/run-pathogen.sh -i nerdtree_red")
    endif
    let g:loaded_nerd_tree = 1
  else
    " If you define this local variable and set it to 1: Plugin won't be loaded.
    "
    " And the custom settings will be disabled.
    "
    if exists('s:bypass_nerd_tree') && s:bypass_nerd_tree
      let g:loaded_nerd_tree = 1
    endif
  endif
endfunction
" --------------------------------------------------------------------------------------------------
" Plugins: Opened File switch               -   g:loaded_minibufexplorer
" --------------------------------------------------------------------------------------------------
"| 3). <bufexplorer>
"                                                        https://github.com/fholgado/minibufexpl.vim   
" --------------------------------------------------------------------------------------------------
function Check_kiki_bufexplorer()
  if !filereadable(expand("$HOME/.vim/bundle/bufexplorer/plugin/minibufexpl.vim"))
    if !g:ignore_warning_msg
      echom expand("please run    bash $HOME/.vim/run-pathogen.sh -i bufexplorer")
    endif
    let g:loaded_minibufexplorer = 1
  else
    " If you define this local variable and set it to 1: Plugin won't be loaded.
    "
    " And the custom settings will be disabled.
    "
    if exists('s:bypass_minibufexplorer') && s:bypass_minibufexplorer
      let g:loaded_minibufexplorer = 1
    endif
  endif
endfunction
" --------------------------------------------------------------------------------------------------
" Plugins: Show func/var list               -   g:loaded_taglist 
"                                               g:loaded_tagbar
" --------------------------------------------------------------------------------------------------
"| 4). <taglist>
"                                                                 http://github.com/yegappan/taglist
" --------------------------------------------------------------------------------------------------
function Check_kiki_taglist()
  if !filereadable(expand("$HOME/.vim/bundle/taglist/plugin/taglist.vim"))
    if !g:ignore_warning_msg
      echom expand("please run    bash $HOME/.vim/run-pathogen.sh -i taglist")
    endif
    let g:loaded_taglist = 1
  else
    " If you define this local variable and set it to 1: Plugin won't be loaded.
    "
    " And the custom settings will be disabled.
    "
    if exists('s:bypass_taglist') && s:bypass_taglist
      let g:loaded_taglist = 1
    endif
  endif
endfunction
" --------------------------------------------------------------------------------------------------
"| 5). <tagbar>
"                                                                https://github.com/preservim/tagbar
" --------------------------------------------------------------------------------------------------
function Check_kiki_tagbar()
  if !filereadable(expand("$HOME/.vim/bundle/tagbar/plugin/tagbar.vim"))
    if !g:ignore_warning_msg
      echom expand("please run    bash $HOME/.vim/run-pathogen.sh -i tagbar")
    endif
    let g:loaded_tagbar = 1
  else
    " If you define this local variable and set it to 1: Plugin won't be loaded.
    "
    " And the custom settings will be disabled.
    "
    if exists('s:bypass_tagbar') && s:bypass_tagbar
      let g:loaded_tagbar = 1
    endif
  endif
endfunction
" --------------------------------------------------------------------------------------------------
" Plugins: Status line                      -   g:loaded_lightline 
"                                               g:loaded_airline
" --------------------------------------------------------------------------------------------------
"| 1). <lightline>
"                                                           https://github.com/itchyny/lightline.vim
" --------------------------------------------------------------------------------------------------
function Check_kiki_lightline()
  if !filereadable(expand("$HOME/.vim/bundle/lightline/plugin/lightline.vim"))
    if !g:ignore_warning_msg
      echom expand("please run    bash $HOME/.vim/run-pathogen.sh -i lightline")
    endif
    let g:loaded_lightline = 1
  else
    " If you define this local variable and set it to 1: Plugin won't be loaded.
    "
    " And the custom settings will be disabled.
    "
    if exists('s:bypass_lightline') && s:bypass_lightline
      let g:loaded_lightline = 1
    endif
  endif
endfunction
" --------------------------------------------------------------------------------------------------
"| 2). <airline>
"                                                         https://github.com/vim-airline/vim-airline
" --------------------------------------------------------------------------------------------------
function Check_kiki_airline()
  if !filereadable(expand("$HOME/.vim/bundle/airline/plugin/airline.vim"))
    if !g:ignore_warning_msg
      echom expand("please run    bash $HOME/.vim/run-pathogen.sh -i airline")
    endif
    let g:loaded_airline = 1
  else
    " If you define this local variable and set it to 1: Plugin won't be loaded.
    "
    " And the custom settings will be disabled.
    "
    if exists('s:bypass_airline') && s:bypass_airline
      let g:loaded_airline = 1
    endif
  endif
endfunction
" --------------------------------------------------------------------------------------------------
" Plugins: Status line theme                -   g:loaded_airline_themes
" --------------------------------------------------------------------------------------------------
"| 1). <airline_themes>
"                                                  https://github.com/vim-airline/vim-airline-themes
" --------------------------------------------------------------------------------------------------
function Check_kiki_airline_themes()
  if !filereadable(expand("$HOME/.vim/bundle/airline_themes/plugin/airline-themes.vim"))
    if !g:ignore_warning_msg
      echom expand("please run    bash $HOME/.vim/run-pathogen.sh -i airline_themes")
    endif
    let g:loaded_airline_themes = 1
  else
    " If you define this local variable and set it to 1: Plugin won't be loaded.
    "
    " And the custom settings will be disabled.
    "
    if exists('s:bypass_airline_themes') && s:bypass_airline_themes
      let g:loaded_airline_themes = 1
    endif
  endif
endfunction

" --------------------------------------------------------------------------------------------------
" Plugins: Vim color theme                  -   g:loaded_colors_solarized
"                                           -   g:loaded_colorschemes
" --------------------------------------------------------------------------------------------------
"| 1). colors_solarized
"                                                https://github.com/altercation/vim-colors-solarized
" --------------------------------------------------------------------------------------------------
function Check_kiki_colors_solarized()
  if !filereadable(expand("$HOME/.vim/bundle/colors_solarized/colors/solarized.vim"))
    if !g:ignore_warning_msg
      echom expand("please run    bash $HOME/.vim/run-pathogen.sh -i colors_solarized")
    endif
    let g:loaded_colors_solarized = 1
  else
    " If you define this local variable and set it to 1: Plugin won't be loaded.
    "
    " And the custom settings will be disabled.
    "
    if exists('s:bypass_colors_solarized') && s:bypass_colors_solarized
      let g:loaded_colors_solarized = 1
    endif
  endif
endfunction
" --------------------------------------------------------------------------------------------------
"| 2). colorschemes
"                                                      https://github.com/flazz/vim-colorschemes.git
" --------------------------------------------------------------------------------------------------
function Check_kiki_colorschemes()
  if !filereadable(expand("$HOME/.vim/bundle/colorschemes/README.md"))
    if !g:ignore_warning_msg
      echom expand("please run    bash $HOME/.vim/run-pathogen.sh -i colorschemes")
    endif
    let g:loaded_colorschemes = 1
  else
    " If you define this local variable and set it to 1: Plugin won't be loaded.
    "
    " And the custom settings will be disabled.
    "
    if exists('s:bypass_colorschemes') && s:bypass_colorschemes
      let g:loaded_colorschemes = 1
    endif
  endif
endfunction
" --------------------------------------------------------------------------------------------------
" Plugins: Code Edit                        -   g:loaded_youcompleteme
" --------------------------------------------------------------------------------------------------
"| 1). youcompleteme
"                                                          https://github.com/valloric/youcompleteme
" --------------------------------------------------------------------------------------------------
function Check_kiki_youcompleteme()
  if !filereadable(expand("$HOME/.vim/bundle/youcompleteme/plugin/youcompleteme.vim"))
    if !g:ignore_warning_msg
      echom expand("please run    bash $HOME/.vim/run-pathogen.sh -i youcompleteme")
    endif
    let g:loaded_youcompleteme = 1
  else
    if !filereadable(expand("$HOME/.vim/bundle/youcompleteme/cpp/ycm/.ycm_extra_conf.py"))
      echom expand("please run    bash $HOME/.vim/run-pathogen.sh -i youcompleteme")
      let g:loaded_youcompleteme = 1
    else
      " If you define this local variable and set it to 1: Plugin won't be loaded.
      "
      " And the custom settings will be disabled.
      "
      if exists('s:bypass_youcompleteme') && s:bypass_youcompleteme
        let g:loaded_youcompleteme = 1
      endif
    endif
  endif
endfunction

" --------------------------------------------------------------------------------------------------
"| 2). coc nvim
"                                                          https://github.com/neoclide/coc.nvim
" --------------------------------------------------------------------------------------------------
function Check_kiki_coc_nvim()
  if !filereadable(expand("$HOME/.vim/bundle/coc.nvim/autoload/coc.vim"))
    if !g:ignore_warning_msg
      echom expand("please run    bash $HOME/.vim/run-pathogen.sh -i coc")
    endif
    let g:did_coc_loaded = 1
  else
      " If you define this local variable and set it to 1: Plugin won't be loaded.
      "
      " And the custom settings will be disabled.
      "
      if exists('s:bypass_coc') && s:bypass_coc
        let g:did_coc_loaded = 1
      else
        let g:coc_disable_startup_warning = 1
        "set verbosefile=$HOME/.cache/nvim/coc.log
      endif
  endif
endfunction

" --------------------------------------------------------------------------------------------------
" Plugins: Code Search                      -   g:loaded_gtags_cscope & g:loaded_gtags
" --------------------------------------------------------------------------------------------------
"| 1). global
"                                                                          http://tamacom.com/global
"                                                      http://tamacom.com/global/global-6.6.9.tar.gz
" --------------------------------------------------------------------------------------------------
function Check_kiki_global()
  if !filereadable(expand("$HOME/.vim/bundle/global-6.6.9/plugin/gtags-cscope.vim"))
    if !g:ignore_warning_msg
      echom expand("please run    bash $HOME/.vim/run-pathogen.sh -i global")
    endif
    let g:loaded_gtags = 1
    let g:loaded_gtags_cscope = 1
  else
    " If you didn't install global/gtags/gtags-cscope/htags, let's disable global by default
    if !executable('global') || !executable('gtags') || !executable('gtags-cscope') || !executable('htags')
      let s:bypass_global = 1
    endif
    " If you define this local variable and set it to 1: Plugin won't be loaded.
    "
    " And the custom settings will be disabled.
    "
    if exists('s:bypass_global') && s:bypass_global
      let g:loaded_gtags = 1
      let g:loaded_gtags_cscope = 1
    endif
  endif
endfunction
" --------------------------------------------------------------------------------------------------
" Plugins: Fast Search                      -   g:loaded_ctrlp
"                                           -   g:EasyGrepVersion
" --------------------------------------------------------------------------------------------------
"| 1). ctrlp
"                                                                  https://github.com/kien/ctrlp.vim
" --------------------------------------------------------------------------------------------------
function Check_kiki_ctrlp()
  if !filereadable(expand("$HOME/.vim/bundle/ctrlp/plugin/ctrlp.vim"))
    if !g:ignore_warning_msg
      echom expand("please run    bash $HOME/.vim/run-pathogen.sh -i ctrlp")
    endif
    let g:loaded_ctrlp = 1
  else
    " If you define this local variable and set it to 1: Plugin won't be loaded.
    "
    " And the custom settings will be disabled.
    "
    if exists('s:bypass_ctrlp') && s:bypass_ctrlp
      let g:loaded_ctrlp = 1
    endif
  endif
endfunction

" --------------------------------------------------------------------------------------------------
" Plugins: Draw line                        -   g:loaded_DrawItPlugin
" --------------------------------------------------------------------------------------------------
"| 1). ctrlp
"                                                          https://github.com/vim-scripts/DrawIt.git
" --------------------------------------------------------------------------------------------------
function Check_kiki_drawit()
  if !filereadable(expand("$HOME/.vim/bundle/drawIt/plugin/DrawItPlugin.vim"))
    if !g:ignore_warning_msg
      echom expand("please run    bash $HOME/.vim/run-pathogen.sh -i drawit")
    endif
    let g:loaded_DrawItPlugin = 1
  else
    " If you define this local variable and set it to 1: Plugin won't be loaded.
    "
    " And the custom settings will be disabled.
    "
    if exists('s:bypass_drawit') && s:bypass_drawit
      let g:loaded_DrawItPlugin = 1
    endif
  endif
endfunction

" set leader key - keyboard shortcuts
"let mapleader = ","
"let g:mapleader = ","

call DecouplePlugins()
" --------------------------------------------------------------------------------------------------
" **************************************************************************************************
" *                               vim plugins setting load                                         *
" **************************************************************************************************
" --------------------------------------------------------------------------------------------------

"---------------------------------------------------------------------------------------------------
call Check_kiki_winmanager()           " window manager      - Useful                       winmanger
"                                                                               , + F12 - Open/Close
"
call Check_kiki_nerdtree_red()         " file tree           - Maybe Useful              nerdtree_red
"
"                                                                                   F12 - Open/Close
"---------------------------------------------------------------------------------------------------
call Check_kiki_bufexplorer()          " buffer explorer     - Useful
"---------------------------------------------------------------------------------------------------
call Check_kiki_taglist()              "                     - <taglist> & <tagbar>
call Check_kiki_tagbar()               " tag list            - they have the same features 
"                                     "                     - you can enable one of them.
"
"                                                                                            taglist
"                                                                               , + F11 - Open/Close
"                                                                                             tagbar
"                                                                                   F11 - Open/Close
"---------------------------------------------------------------------------------------------------
call Check_kiki_lightline()            "                     - <lightline> & <airline>
call Check_kiki_airline()              " status line         - maybe airline may Useful
call Check_kiki_airline_themes()       "                     -
"---------------------------------------------------------------------------------------------------


"---------------------------------------------------------------------------------------------------
call Check_kiki_colors_solarized()     "                     - <colors_solarized> support 1 themes
call Check_kiki_colorschemes()         " vim color themes    - <colorschemes>     support n+ themes
                                      "                     - 
"---------------------------------------------------------------------------------------------------

"---------------------------------------------------------------------------------------------------
call Check_kiki_youcompleteme()        " code auto-complete  - Useful
call Check_kiki_coc_nvim()             " code auto-complete  - Useful
call Check_kiki_global()               " code search/jump    - Useful    
call Check_kiki_ctrlp()                " fast search         - Good
"---------------------------------------------------------------------------------------------------

"---------------------------------------------------------------------------------------------------
call Check_kiki_drawit()               " draw line           - Good
"---------------------------------------------------------------------------------------------------

"---------------------------------------------------------------------------------------------------
call Check_kiki_pathogen()             " Basical Plugin      - Must be enabled
"---------------------------------------------------------------------------------------------------

" --------------------------------------------------------------------------------------------------
"                                                                                               Main
" --------------------------------------------------------------------------------------------------
" [Help]                                                                                 1) pathogen
" --------------------------------------------------------------------------------------------------
if !exists('g:loaded_pathogen')
  " Launch ~/.vim/bundle/XXXX/plugin/XXX.vim
  execute pathogen#infect()
  syntax on                               " Overide the settings
  filetype plugin indent on               " plugin -> plugin on
                                          " indent -> indent on
                                          " on     -> detection on
  " FixSomething
  " If pathogen has been loaded youcompleteme/coc.nvim, let's disable youcompleteme by default
  if (!exists('g:loaded_youcompleteme')) && (!exists('g:did_coc_loaded'))
    let g:loaded_youcompleteme = 1
  endif
else
  finish
  echom expand("won't go there");
endif

" --------------------------------------------------------------------------------------------------
"                                                                                             Window
" --------------------------------------------------------------------------------------------------
" [Help]                                                                               1) winmanager
"                                                                   , + F12 - Open/Close Winmannager
"                                                                               CTRL + F - Page Down
"                                                                                 CTRL + B - Page Up
" --------------------------------------------------------------------------------------------------
if !exists('g:loaded_winmanager')

  let g:winManagerWindowLayout = "BufExplorer,FileExplorer"   " set window layout

  let g:AutoOpenWinManager = 0                                " auto open winmanger
  let g:winManagerWidth = 30                                  " set winmanager width
  let g:defaultExplorer = 1                                   " default
  
  " [NORMAL]
  " map - single map key with <leader> key
  " , + F12 - Open/Close Winmannager
 
  if !(exists('s:bypass_nerd_tree') && s:bypass_nerd_tree)
    " If you enable nerdtree, add <leader> key for the hotkey
    map <silent> <leader> <F12> :WMToggle<CR>
  else
    nnoremap <silent> <F12> :WMToggle<CR>
  endif

  " CTRL F - Page Down
  nnoremap <C-W><C-F> :FirstExplorerWindow<CR>
  " CTRL B - Page Up
  nnoremap <C-W><C-B> :BottomExplorerWindow<CR>
endif

" --------------------------------------------------------------------------------------------------
"                                                                                             Window
" --------------------------------------------------------------------------------------------------
" [Help]                                                                             2) nerdtree_red
"                                                                          F12 - Open/Close NERDTree
" --------------------------------------------------------------------------------------------------
if !exists('g:loaded_nerd_tree')
  let g:NERDTreeDirArrowExpandable = '►'   " change the default arrows
  let g:NERDTreeDirArrowCollapsible = '▼'  " change the default arrows
  let g:NERDTreeWinPos = 'right'           " set window position -  'left' or 'right'
  let g:NERDTreeWinSize = 25               " set size of the NERDTree
  let NERDTreeShowHidden = 1               " Do not hidden

  " Do not show some file or dir
  " Hidden dir
  " .git
  " .github
  " .cache
  " .ccache
  " .camke
  "
  let NERDTreeIgnore=[
    \ '\.bash_history$',
    \ '\.cache$',
    \ '\.ccache$',
    \ '\.cmake$',
    \ '\.config$',
    \ '\.curlrc$',
    \ '\.docker$',
    \ '\.flexlmrc$',
    \ '\.git$',
    \ '\.gitconfig$',
    \ '\.gitcookies$',
    \ '\.gsutil$',
    \ '\.lesshst$',
    \ '\.local$',
    \ '\.nano$',
    \ '\.repoconfig$',
    \ '\.repo_.gitconfig.json$',
    \ '\.rnd$',
    \ '\.rpmdb$',
    \ '\.selected_editor$',
    \ '\.tig_history$',
    \ '\.vpython_cipd_cache$',
    \ '\.vpython-root$',
    \ '\.wget-hsts$',
    \ '\.o$',
    \ '\.o.cmd$',
    \ '\.o.d$',
    \ '\.mod.*$',
    \ '\.cmd$',
    \ '\.ko$',
    \ '\.ko.cmd$',
    \ '\.dtb$',
    \ '\.dtb.cmd$',
    \ '\GPATH$',
    \ '\GRTAGS$',
    \ '\GTAGS$',
    \ '\.order$',
    \ '\.symvers$',
    \ '\built-in.a$',
    \ '\modules.builtin$',
    \ '\.tmp_versions$'
    \ ]
  "autocmd VimEnter * NERDTree | wincmd p        " Start NERDTree and put the cursor back
                                                " in the other window.
  "
  " [NORMAL]
  " nnoremap - single map key without loop
  "  F12 - Open/Close NERDTree
  nnoremap <silent> <F12> :NERDTreeToggle<CR>
endif

" --------------------------------------------------------------------------------------------------
"                                                                                             Window
" --------------------------------------------------------------------------------------------------
"                                                                                     3) bufexplorer
" --------------------------------------------------------------------------------------------------
if !exists('g:loaded_minibufexplorer')
  let g:bufExplorerDefaultHelp=1       " Do not show default help.
  let g:bufExplorerShowRelativePath=1  " Show relative paths.
  let g:bufExplorerSortBy='mru'        " Sort by most recently used.
  let g:bufExplorerSplitRight=0        " Split left.
  let g:bufExplorerSplitVertical=1     " Split vertically.
  let g:bufExplorerSplitVertSize = 35  " Split width
  let g:bufExplorerUseCurrentWindow=1  " Open in new window.
  let g:bufExplorerMaxHeight=13        " Max height
endif

" --------------------------------------------------------------------------------------------------
"                                                                                             Window
" --------------------------------------------------------------------------------------------------
" [Help]                                                                                4) *taglist*
"                                                                       , + F11 - Open/Close taglist
"                                                                           F11 - Open/Close taglist
" --------------------------------------------------------------------------------------------------
if !exists('g:loaded_taglist')
  let Tlist_Exit_OnlyWindow=0          " Do not exit when only windows
  let Tlist_Auto_Open=0                " Do not auto-open taglist 
  let Tlist_Use_Right_Window = 0       " 0 - left window, 1 - right window
  let Tlist_WinWidth = 40              " set size of the taglist

  " When Open C/C++
  " Enable this plugin
  ""autocmd FIletype c,cpp nested :call taglist#Tlist_Window_Open()
  " [NORMAL]
  " map - single map key with <leader> key
  " , + F11 - Open/Close Taglist
  if !(exists('s:bypass_tagbar') && s:bypass_tagbar)
    " If you enable tagbar, add <leader> key for the taglist hotkey
    map <silent> <leader> <F11> :TlistToggle<CR>
  else
    nnoremap <silent> <F11> :TlistToggle<CR>
  endif
endif
" --------------------------------------------------------------------------------------------------
"                                                                                             Window
" --------------------------------------------------------------------------------------------------
" [Help]                                                                                   5) tagbar
"                                                                            F11 - Open/Close tagbar
" --------------------------------------------------------------------------------------------------
if !exists('g:loaded_tagbar')
  let g:tagbar_sort = 0                " Sort by most recently used
  let g:tagbar_width = 30              " set size of the tagbar
  let g:tagbar_position = 'left'       " top, bottom, left, right
  let g:tagbar_autopreview = 0         " it will show a preview window for you

  " When Open C/C++/Java/Python/Makefile/vim
  " Enable this plugin
  ""autocmd FIletype c,cpp,java,python,make,vim nested :call tagbar#autoopen(1)
  " [NORMAL]
  " nnoremap - single map key without loop
  " F11 - Open/Close tagbar
  nnoremap <silent> <F11> :TagbarToggle<CR>

endif
" --------------------------------------------------------------------------------------------------
"                                                                                        Status Line
" --------------------------------------------------------------------------------------------------
" [Help]                                                                                1) lightline
" --------------------------------------------------------------------------------------------------
if !exists('g:loaded_lightline')
  set statusline=%F%m%r%h%w\ [FORMAT=%{&ff}]\ [TYPE=%Y]\ [POS=%l,%v][%p%%]\ %{strftime(\"%d/%m/%y\ -\ %H:%M\")}
  set laststatus=0
  let g:lightline = {
        \ 'colorscheme': 'wombat',
        \ }
endif
" --------------------------------------------------------------------------------------------------
"                                                                                        Status Line
" --------------------------------------------------------------------------------------------------
" [Help]                                                                                  2) airline
" --------------------------------------------------------------------------------------------------
if !exists('g:loaded_airline')
endif

" --------------------------------------------------------------------------------------------------
"                                                                                        Status Line
" --------------------------------------------------------------------------------------------------
" [Help]                                                                           3) airline_themes
" --------------------------------------------------------------------------------------------------
if exists('g:loaded_airline_themes')
  " More themes, please check '$HOME/.vim/bundle/airline_themes/autoload/airline/themes'
  let g:airline_theme='jellybeans'    " Select airline theme
endif

" --------------------------------------------------------------------------------------------------
"                                                                                       color themes
" --------------------------------------------------------------------------------------------------
" [Help]                                                                         1) colors_solarized
" --------------------------------------------------------------------------------------------------
if !exists('g:loaded_colors_solarized')
  set t_Co=256                        " tt
  syntax enable                       " Keep your current color settings
  if has('gui_running')
    set background=light
  else
    set background=dark
  endif
endif

" --------------------------------------------------------------------------------------------------
"                                                                                       color themes
" --------------------------------------------------------------------------------------------------
" [Help]                                                                             2) colorschemes
" --------------------------------------------------------------------------------------------------
if !exists('g:loaded_colorschemes')
  " More themes, please check $HOME/.vim/bundle/colorschemes/colors
  "
  " When ssh Session is SecureCRT
  " Session Options
  "   -> Terminal
  "     -> Emulation
  "     select Terminal     - "Xterm"
  "     select Color Mode   - "ANSI with 256color"
  "     [x]                 - Use color scheme
  set t_Co=256                        " tt
  colorscheme koehler                 " Select vim color theme
  colorscheme molokai                 " Select vim color theme
endif

" --------------------------------------------------------------------------------------------------
"                                                                                   Code Edit/Lookup
" --------------------------------------------------------------------------------------------------
" [Help]                                                                            1) youcompleteme
"                                                                  TAB     -     switch matched word
"                                                                  Enter   -     select matched word
" --------------------------------------------------------------------------------------------------
if !exists('g:loaded_youcompleteme')
  let g:ycm_global_ycm_extra_conf='$HOME/.vim/bundle/youcompleteme/cpp/ycm/.ycm_extra_conf.py'
  let g:ycm_complete_in_comments = 1                          " show it - typing inside comments
  let g:ycm_complete_in_strings = 1                           " show it - typing inside strings.
  let g:ycm_collect_identifiers_from_comments_and_strings = 0 " collect 'comments' 'strings'
  let g:ycm_min_num_of_chars_for_completion=2                 " set autocompletion - min-word

  " Enter -  use enter" to select it
  inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<CR>" |
endif

if !exists('g:did_coc_loaded')
  " For coc-nvim, it can't use pumvisible, and it will cause some side effect.
  " More details: please visit "https://github.com/neoclide/coc.nvim/wiki/Completion-with-sources"
  " wiki: https://github.com/neoclide/coc.nvim/wiki
  "
  " <Enter>         : final select
  " <Tab>           : select next
  " <Shift> + <Tab> : Select prev
  inoremap <expr> <cr> coc#pum#visible() ? coc#pum#confirm() : "\<CR>"
  inoremap <expr> <Tab> coc#pum#visible() ? coc#pum#next(1) : "\<Tab>"
  inoremap <expr> <S-Tab> coc#pum#visible() ? coc#pum#prev(1) : "\<S-Tab>"
endif

" --------------------------------------------------------------------------------------------------
"                                                                                   Code Edit/Lookup
" --------------------------------------------------------------------------------------------------
" [Help]                                                                                   2) global
"                                                                                           * gtags
"                                                           CTRL + ]       - Jump to define
"                                                           CTRL + J       - Jump back
"
"                                                                                           * cscope
"                                                           CTRL + \ + s   -  Find symbol
"                                                           CTRL + \ + g   -  Find definition
"                                                           CTRL + \ + d   -  Find functions called
"                                                                             by this function
"                                                           CTRL + \ + c   -  Find reference
"                                                           CTRL + \ + t   -  Find text string
"                                                           CTRL + \ + e   -  Find egrep pattern
"                                                           CTRL + \ + f   -  Find path
"                                                           CTRL + \ + i   -  Find include file
" --------------------------------------------------------------------------------------------------
if !exists('g:loaded_gtags') && !exists('g:loaded_gtags_cscope')
  " gtags-cscope
  let GtagsCscope_Auto_Load = 1       " auto loading
  let GtagsCscope_Auto_Map = 1        " To use the default key/mouse mapping
  let GtagsCscope_Quiet = 1           " Do not display error message

  " Find symbol       :cs find 0 or s
  nmap <C-\>s :cs find s <C-R>=expand("<cword>")<CR><CR>

  " Find definition   :cs find 1 or g
  nmap <C-\>g :cs find g <C-R>=expand("<cword>")<CR><CR>

  " Find functions called by this function  (not implemented)
  nmap <C-\>d :cs find d <C-R>=expand("<cword>")<CR><CR>

  " Find reference    :cs find 3 or c
  nmap <C-\>c :cs find c <C-R>=expand("<cword>")<CR><CR>

  " Find text string  :cs find 4 or t
  nmap <C-\>t :cs find t <C-R>=expand("<cword>")<CR><CR>

  " Find egrep pattern  :cs find 6 or e
  nmap <C-\>e :cs find e <C-R>=expand("<cword>")<CR><CR>

  " Find path   :cs find 7 or f
  "nmap <C-\>f :cs find f <C-R>=expand("<cfile>")<CR><CR>
  "nmap <C-\>f :cs find 7 <C-R>=expand("<cfile>")<CR><CR>

  " Find include file :cs find 8 or i
  "nmap <C-\>i :cs find i <C-R>=expand("<cfile>")<CR><CR>
  "nmap <C-\>i :cs find 8 <C-R>=expand("<cfile>")<CR><CR>

  if filereadable("tags")
  	execute 'set tags =tags'
  endif

  if filereadable(".tags")
  	execute 'set tags =.tags'
  endif

  if has("cscope")
	  set csprg="gtags-cscope"
    set csto=1
    set cst
  endif

  set cscopetag                       " Enable 'CTRL-]' shortcuts
  set cscopeprg='gtags-cscope'        " Select 'gtags-cscope' to execute cscope

endif

" --------------------------------------------------------------------------------------------------
"                                                                                   Code Edit/Lookup
" --------------------------------------------------------------------------------------------------
" [Help]                                                                                    4) ctrlp
" --------------------------------------------------------------------------------------------------
if !exists('g:loaded_ctrlp')
  " Set MRU mode as the ctrlp default mode.
  let g:ctrlp_cmd = 'CtrlPMRUFiles'
  let g:ctrlp_map = '<c-f>'            " Ctrl + f    -   call ctrlp
                                       " Ctrl + r    -   switch search method
  let g:ctrlp_by_filename = 1 

  set wildignore+=*/tmp/*,*.so,*.swp,*.zip     " MacOSX/Linux
  set wildignore+=*\\tmp\\*,*.swp,*.zip,*.exe  " Windows

  let g:ctrlp_custom_ignore = '\v[\/]\.(git|hg|svn)$'
  let g:ctrlp_custom_ignore = {
    \ 'dir':  '\v[\/]\.(git|hg|svn)$',
    \ 'file': '\v\.(exe|so|dll)$',
    \ 'link': 'some_bad_symbolic_links',
    \ }
endif

" --------------------------------------------------------------------------------------------------
"                                                                                               Dra|
" -------------------------------------------------------------------------------------------------+
" [Help]                                                                                   1) drawi|
" -------------------------------------------------------------------------------------------------+
"if !(exists('s:bypass_drawit') && s:bypass_drawit)
if !exists('g:loaded_DrawItPlugin')
  nnoremap <silent> <F3> :DIstart<CR>
  nnoremap <silent> <F2> :DIstop<CR>
endif
" ----------------------------------------------------------------------------
" |******************* vim plugins list - end ********************************
" +---------------------------------------------------------------------------
