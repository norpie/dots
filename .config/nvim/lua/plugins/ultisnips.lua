HOME = os.getenv("HOME")

vim.g.UltiSnipsSnippetsDir = HOME .. "/.config/nvim/snips"
vim.g.UltiSnipsSnippetDirectories = {"snips"}

vim.g.UltiSnipsExpandTrigger="<tab>"
vim.g.UltiSnipsJumpForwardTrigger="<tab>"
vim.g.UltiSnipsJumpBackwardTrigger="<s-tab>"
