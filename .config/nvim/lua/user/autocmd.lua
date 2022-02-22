vim.cmd([[
    augroup filetype_settings
        autocmd!
        autocmd FileType python,java,cpp,lua,c set nowrap
    augroup END

    augroup packer_user_config
        autocmd!
        autocmd BufWritePost packer.lua source <afile> | PackerCompile
    augroup END

    "augroup formatting
    "    autocmd!
    "    autocmd BufWritePre *.py,*.js,*.c lua vim.lsp.buf.formatting_sync(nil, 1000)
    "augroup END

    augroup latexautocompile
        autocmd!
        autocmd InsertEnter *.tex write
        autocmd InsertLeave *.tex write
    augroup END

    augroup writegroup
        autocmd!
        autocmd BufWritePost *.lua source %
        autocmd BufWritePost Xresources silent !xrdb -merge ~/.config/X11/Xresources && notify-send "Xresources saved\! 💾"
        autocmd BufWritePost dunstrc silent !restart dunst && notify-send "dunstrc saved\! 💾"
    augroup END
]])
