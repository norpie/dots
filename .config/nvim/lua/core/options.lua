local set = vim.opt

HOME = os.getenv('HOME')

-- disable header folding
vim.g.vim_markdown_folding_disabled = 1

-- do not use conceal feature, the implementation is not so good
vim.g.vim_markdown_conceal = 0

-- disable math tex conceal feature
vim.g.tex_conceal = ''
vim.g.vim_markdown_math = 1

-- support front matter of various format
vim.g.vim_markdown_frontmatter = 1  -- for YAML format
vim.g.vim_markdown_toml_frontmatter = 1  -- for TOML format
vim.g.vim_markdown_json_frontmatter = 1  -- for JSON format

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
set.mouse = 'a'
set.wrap = true
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
set.background = 'dark'
set.spelllang = 'nl,en'
set.laststatus = 2
set.showmode = false
set.conceallevel = 0


