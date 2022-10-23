local set = vim.opt
local g = vim.g

HOME = os.getenv('HOME')

-- disable header folding
g.vim_markdown_folding_disabled = 1

-- do not use conceal feature, the implementation is not so good
g.vim_markdown_conceal = 0

-- disable math tex conceal feature
g.tex_conceal = ''
g.vim_markdown_math = 1

-- support front matter of various format
g.vim_markdown_frontmatter = 1  -- for YAML format
g.vim_markdown_toml_frontmatter = 1  -- for TOML format
g.vim_markdown_json_frontmatter = 1  -- for JSON format

-- autosave
g.auto_save_silent = 1
g.auto_save = 1

-- leader
g.mapleader = ' '

set.encoding = 'utf8'

--set.completeopt = {'menu', 'menuone', 'noselect'}

vim.wo.fillchars = 'eob: '

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
set.mouse = 'a'
set.cursorline = true
set.wrap = false
set.ruler = true
set.foldenable = false

set.ignorecase = true
set.smartcase = true
set.incsearch = true

set.swapfile = false
set.backup = false
set.undofile = true
set.undodir = HOME .. '/.cache/nvim/undodir'

set.termguicolors = true
set.scrolloff = 20
set.cmdheight = 0
set.updatetime = 25
--set.background = 'dark'
set.spelllang = 'nl,en'
set.laststatus = 3
set.showmode = false
set.conceallevel = 0
set.showtabline = 0

set.guifont = 'LiterationMono Nerd Font:h15'

g.neovide_transparency=0.9
