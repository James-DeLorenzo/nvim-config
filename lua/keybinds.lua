-- mapping azond settings helpers {{{
local utils = {}

function utils.map(type, key, value, opts) -- the other functions are just for more vim-feel usage
  local options = opts or {}
  vim.api.nvim_set_keymap(type, key, value, options)
end
function utils.noremap(type, key, value, opts)
  local options = {noremap = true}
  if opts then
    options = vim.tbl_extend('force', options, opts)
  end
  vim.api.nvim_set_keymap(type,key,value, options)
end
function utils.nnoremap(key, value, opts)
  utils.noremap('n', key, value, opts)
end
function utils.inoremap(key, value, opts)
  utils.noremap('i', key, value, opts)
end
function utils.vnoremap(key, value, opts)
  utils.noremap('v', key, value, opts)
end
function utils.xnoremap(key, value, opts)
  utils.noremap('x', key, value, opts)
end
function utils.tnoremap(key, value, opts)
  utils.noremap('t', key, value, opts)
end
function utils.cnoremap(key, value, opts)
  utils.noremap('c', key, value, opts)
end
function utils.nmap(key, value, opts)
  utils.map('n', key, value, opts)
end
function utils.imap(key, value, opts)
  utils.map('i', key, value, opts)
end
function utils.vmap(key, value, opts)
  utils.map('v', key, value, opts)
end
function utils.tmap(key, value, opts)
  utils.map('t', key, value, opts)
end
-- }}}

-- NO ARROW KEYS {{{
utils.noremap('', '<Up>', '<Nop>')
utils.inoremap('<Up>', '<Nop>')
utils.noremap('', '<Down>', '<Nop>')
utils.inoremap('<Down>', '<Nop>')
utils.noremap('', '<Left>', '<Nop>')
utils.inoremap('<Left>', '<Nop>')
utils.noremap('', '<Right>', '<Nop>')
utils.inoremap('<Right>', '<Nop>')
-- }}}
-- Change leader key
utils.nnoremap('<Space>', '<Nop>')
vim.g.mapleader = " "

-- nvim tree stuffs {{{
if package.loaded["nvim-tree"] ~= nil then
    utils.nnoremap('<Leader><Tab>', '<CMD>NvimTreeToggle<CR>', { silent= true })
end
-- }}}

utils.nnoremap('<F3>', '<CMD>lua require("FTerm").toggle()<CR>', {silent = true})
utils.tnoremap('<F3>', '<C-\\><C-n><CMD>lua require("FTerm").toggle()<CR>', { silent = true })
-- lspSaga stuffs {{{
utils.nnoremap('gh', '<CMD>Lspsaga lsp_finder<CR>', { silent = true })
utils.nnoremap('K', '<CMD>Lspsaga hover_doc<CR>', { silent = true })
-- }}}

-- barbar {{{
utils.nnoremap('<Leader>bp', '<CMD>BufferPick<CR>', { silent = true })
utils.nnoremap('<Leader>bq', '<CMD>BufferClose<CR>', { silent = true })
-- utils.nnoremap('<C-^I>', 'BufferNext', { silent = true })
-- }}}

-- Telescope {{{
utils.nnoremap('<leader>fa', '<cmd>Telescope lsp_code_actions<CR>')
utils.nnoremap('<leader>fb', '<cmd>Telescope buffers<CR>')
utils.nnoremap('<leader>fd', '<cmd>Telescope diagnostics<CR>')
utils.nnoremap('<leader>ff', '<cmd>Telescope find_files<CR>')
utils.nnoremap('<leader>fg', '<cmd>Telescope live_grep<CR>')
utils.nnoremap('<leader>fh', '<cmd>Telescope help_tags<CR>')
utils.nnoremap('<leader>fl', '<cmd>Telescope current_buffer_fuzzy_find<CR>')
utils.nnoremap('<leader>fn', '<cmd>Telescope lsp_document_symbols<CR>')
utils.nnoremap('<leader>fs', '<cmd>Telescope grep_string<CR>')
utils.nnoremap('<leader><leader>ft', '<cmd>Telescope filetypes<CR>')
utils.nnoremap('<leader>gf', '<cmd>Telescope git_files<CR>')
-- }}}

utils.nnoremap('<leader>gb', '<cmd>Gitsigns blame_line<CR>', { silent = true })

-- window movement {{{
if vim.fn.has('macunix') == 1 then
utils.nnoremap('∆','<c-w>j', { silent = true })
utils.nnoremap('˚','<c-w>k', { silent = true })
utils.nnoremap('¬','<c-w><c-l>', { silent = true })
utils.nnoremap('˙','<c-w><c-h>', { silent = true })
else
utils.nnoremap('<A-j>','<c-w>j')
utils.nnoremap('<A-k>','<c-w>k')
utils.nnoremap('<A-l>','<c-w><c-l>', { silent = true })
utils.nnoremap('<A-h>','<c-w><c-h>', { silent = true })
end
-- }}}

-- local function test()
--     print("test")
-- end
-- utils.nnoremap('<leader>te', [[]])

utils.nnoremap('gX', [[:execute '!open ' . shellescape(expand('<cfile>'), 1)<CR>]], { silent = true })

-- TODO: wait until this is fixed in nvim
-- utils.cnoremap('w!!', 'w !sudo -S tee %')

-- vim: foldmethod=marker
