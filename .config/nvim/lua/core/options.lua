local set = vim.opt

HOME = os.getenv("HOME")

set.encoding = 'utf8'

set.relativenumber = true
set.hlsearch = true
set.hidden = true
set.errorbells = false

set.tabstop = 4
set.softtabstop = 4
set.shiftwidth = 4
set.expandtab = true
set.smartindent = true

set.number = true
set.wrap = true
set.ruler = true
set.foldenable = false

set.ignorecase = true
set.smartcase = true
set.incsearch = true

set.swapfile = false
set.backup = false
set.undofile = true
set.undodir = HOME .. "/.cache/nvim/undodir"

set.termguicolors = true
set.scrolloff = 20
set.cmdheight = 0
set.updatetime = 25
set.background = 'dark'
set.spelllang = 'nl,en'
set.laststatus = 2
set.showmode = false
set.conceallevel = 0
