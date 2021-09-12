" Merge Xresources on edit
autocmd BufWritePost Xresources !xrdb -merge ~/.config/X11/Xresources
