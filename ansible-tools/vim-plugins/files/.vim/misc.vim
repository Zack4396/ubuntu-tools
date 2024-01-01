" Load Once:
if exists('g:loaded_mis_func_vim')
  finish
endif
let g:loaded_mis_func_vim = 1 

" 1. Switch Tab width
nnoremap  <F6> :<C-u>call <SID>TabToggle()<CR>
inoremap  <F6> <ESC>:<C-u>call <SID>TabToggle()<CR>i

let g:kiki_4tabs = 2 
function! s:TabToggle()
  if exists("g:kiki_4tabs")
    if g:kiki_4tabs == 0
      let g:kiki_4tabs = 1|setl ts=4 sts=4 shiftwidth=4 noet|echom "Use 1 Tab"
    elseif g:kiki_4tabs == 1
      let g:kiki_4tabs = 2|setl ts=4 sts=4 shiftwidth=4 et|echom "Use 4 Space"
    else
      let g:kiki_4tabs = 0|setl ts=2 sts=2 shiftwidth=2 et|echom "Use 2 Space"
    endif
  endif
endfunction

" 2. Automatic numbering 
vnoremap <F3> :<C-u>call <SID>AddCharOfCursor()<CR>
function! s:AddCharOfCursor()
let c = col('.')
let l = line('.')
let l0 = line("'<")
let l1 = line("'>")
let char0 = strpart(getline('.'),c-1,1)
for k in range(1, l1-l0) "Start at 2nd row
let str_before = strpart(getline(l+k),0,c-1)
let str_after = strpart(getline(l+k),c)
if char0 =~ '\d'
let char1 = char0 + k 
else
let char1 = nr2char(char2nr(char0)+k)
endif
call setline(l+k, str_before . char1 . str_after)
endfor
endfunction

" 3. Autocommand
au BufRead,BufNewFile *.bind setfiletype bind
au BufRead,BufNewFile *.fidl setfiletype fidl
au BufRead,BufNewFile *.bb setfiletype yocto_bb
" Use Tab=2 with space
au FIletype python,sh,json,xml,c,cpp,vim,conf,bind,gitcommit,fidl,bind,yocto_bb setlocal tabstop=2 softtabstop=2 shiftwidth=2 expandtab
" Use Tab=4 without space
au FIletype make,dts,tags,kconfig,txt setlocal tabstop=4 softtabstop=4 shiftwidth=4 noexpandtab
