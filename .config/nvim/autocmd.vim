" General
autocmd VimEnter * silent exec "! echo -ne '\e[1 q'"
autocmd InsertEnter * silent exec "! echo -ne '\e[5 q'"
autocmd InsertLeave * silent exec "! echo -ne '\e[1 q'"
autocmd VimLeave * silent exec "! echo -ne '\e[5 q'"
autocmd! BufWritePost *.vim source %

" Perspective Customization
autocmd FileType python,java,cpp,c TagbarOpen
autocmd FileType python,java,cpp,c set nowrap

" Merge Xresources on edit
autocmd BufWritePost Xresources silent !xrdb -merge ~/.config/X11/Xresources

" Reload dunst on edit
autocmd BufWritePost dunstrc silent !restart-dunst && notify-send "dunstrc saved\! 💾"
