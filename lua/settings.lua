vim.o.syntax = 'enable'
vim.o.signcolumn = 'yes'
vim.o.background = 'dark'
vim.o.colorcolumn = "80,100,120,200"
vim.o.termguicolors = true

vim.o.number = true
vim.o.relativenumber = true

vim.o.mouse = 'a'
vim.o.mousefocus = true
-- vim.o.foldmethod = "marker"
vim.o.hls = true
vim.o.wrap = false
vim.o.scrolloff = 3
vim.o.hidden = true
vim.o.cmdheight = 2
vim.opt.iskeyword:append({ '-' })
vim.opt.nrformats:append({ 'unsigned' })
-- tab stuffs
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.softtabstop = -1
vim.o.expandtab = true
vim.o.cursorline = true

vim.o.confirm = true
vim.opt.completeopt = { 'menu', 'menuone', 'preview', 'noselect', 'noinsert' }

-- whitespace chars
vim.opt.listchars = { tab = ">-<", multispace = "", extends = ">", precedes = "<" }
vim.o.list = true
vim.o.modeline = true
vim.o.foldlevelstart = 99
vim.opt.formatoptions:remove({ 'o' })

vim.o.updatetime = 300
vim.o.timeoutlen = 500

vim.o.laststatus = 3
