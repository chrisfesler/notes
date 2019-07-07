" F10 to toggle in and out of paste mode, disabling auto-indent
set pastetoggle=<F10>
" enable mouse support in all modes
:set mouse=a

" paste from system clipboard with S-Insert
inoremap <S-Insert> <ESC>"+p

" copy to system clipboard with C-Insert
vnoremap <C-Insert> "+y

" this doesn't seem to help with the clipboard, but is suggested
"set clipboard=unnamedplus

let g:markdown_fenced_languages = ['go', 'java', 'pyton', 'bash=sh', 'vim']
" this seems to not work, thanks tpope
"let g:markdown_syntax_conceal = 0
set conceallevel=0
" uncomment if need more fenced code block lines; left out for performance
"let g:markdown_minlines=100

colorscheme NeoSolarized
