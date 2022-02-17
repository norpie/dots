vim.cmd([[
    augroup goyo
        autocmd!
        autocmd User GoyoEnter Limelight
        autocmd User GoyoLeave Limelight!
    augroup END

    augroup filetype_settings
        autocmd!
        autocmd FileType python,java,cpp,c set nowrap
    augroup END

    augroup packer_user_config
        autocmd!
        autocmd BufWritePost plugins.lua source <afile> | PackerCompile
    augroup END

    augroup formatting
        autocmd!
    augroup END
    
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
