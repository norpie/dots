local create_augroup = vim.api.nvim_create_augroup
local create_autocmd = vim.api.nvim_create_autocmd

local packer_user_config = 'packer_user_config'
create_augroup(packer_user_config, { clear = true })
create_autocmd('BufWritePost', { command = 'luafile <afile>', pattern = '*/plugins/init.lua', group = packer_user_config })

local latex_auto_compile = 'latexautocompile'
create_augroup(latex_auto_compile, { clear = true})
create_autocmd('InsertEnter', { command = 'write', pattern = '*.tex', group = latex_auto_compile })
create_autocmd('InsertLeave', { command = 'write', pattern = '*.tex', group = latex_auto_compile })

local save_file_group = 'writegroup'
create_augroup(save_file_group, { clear = true })
create_autocmd('BufWritePost', { pattern = '*.lua', command = 'source %' })
create_autocmd('BufWritePost', { pattern = 'Xresources', command = 'silent !xrdb -merge ~/.config/X11/Xresources && notify-send "Xresources saved\\! 💾"' })
create_autocmd('BufWritePost', { pattern = 'dunstrc', command = 'silent !restart dunst && notify-send "dunstrc saved\\! 💾"' })

local pandoc_syntax_group = 'pandocsyntaxgroup'
create_augroup(pandoc_syntax_group, { clear = true })
create_autocmd('BufNewFile', { pattern = '*.md', command = 'set filetype=markdown.pandoc' })
create_autocmd('BufFilePre', { pattern = '*.md', command = 'set filetype=markdown.pandoc' })
create_autocmd('BufRead', { pattern = '*.md', command = 'set filetype=markdown.pandoc' })
