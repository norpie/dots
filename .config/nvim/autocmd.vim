" General
autocmd VimEnter * silent exec "! echo -ne '\e[1 q'"
autocmd InsertEnter * silent exec "! echo -ne '\e[5 q'"
autocmd InsertLeave * silent exec "! echo -ne '\e[1 q'"
autocmd VimLeave * silent exec "! echo -ne '\e[5 q'"
autocmd! BufWritePost *.vim source %

" Abstraction
source $VIMDIR/cmd/coding.vim
source $VIMDIR/cmd/scripting.vim
source $VIMDIR/cmd/writing.vim
source $VIMDIR/cmd/compiling.vim 
