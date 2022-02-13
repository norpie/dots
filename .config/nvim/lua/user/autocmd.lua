vim.cmd([[
    autocmd User GoyoEnter Limelight
    autocmd User GoyoLeave Limelight!
    autocmd FileType python,java,cpp,c TagbarOpen
    autocmd FileType python,java,cpp,c set nowrap
    
    augroup latexautocompile
        autocmd!
        autocmd InsertEnter *.tex write
        autocmd InsertLeave *.tex write
    augroup END
    
    augroup writegroup
        autocmd!
        autocmd BufWritePost *.lua source %
        autocmd BufWritePost Xresources silent !xrdb -merge ~/.config/X11/Xresources
        autocmd BufWritePost dunstrc silent !restart dunst && notify-send "dunstrc saved\! 💾"
    augroup END 
]])
