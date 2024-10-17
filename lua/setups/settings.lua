vim.o.exrc           = true
vim.o.syntax         = 'enable'
vim.o.background     = 'dark'
vim.o.colorcolumn    = "80,100,120,200"
vim.o.termguicolors  = true

vim.o.number         = true
vim.o.relativenumber = true

vim.o.mouse          = 'a'
vim.o.mousefocus     = true
vim.o.hls            = true
vim.o.wrap           = false
vim.o.scrolloff      = 3
vim.o.hidden         = true
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
vim.wo.foldmethod = "expr"
vim.o.foldexpr = "nvim_treesitter#foldexpr()"
vim.o.foldlevelstart = 99
vim.o.foldcolumn = 'auto:9'
vim.opt.formatoptions:remove({ 'o' })

vim.o.updatetime = 300
vim.o.timeout    = true
vim.o.timeoutlen = 500

vim.o.splitright = true
vim.o.splitbelow = true
vim.o.pumblend   = 45

vim.opt.undodir  = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

vim.o.signcolumn = 'yes'
-- vim.o.statuscolumn = '%r%=%s'

vim.o.cmdheight  = 0
vim.o.laststatus = 3
vim.o.showcmd    = true
vim.o.showcmdloc = 'statusline'
vim.o.showmode   = false
