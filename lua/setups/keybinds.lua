-- mapping and settings helpers {{{
local utils = {}

function utils.map(type, key, value, opts) -- the other functions are just for more vim-feel usage
    local options = opts or {}
    vim.keymap.set(type, key, value, options)
end

function utils.noremap(type, key, value, opts)
    local options = { noremap = true }
    if opts then
        options = vim.tbl_extend('force', options, opts)
    end
    vim.keymap.set(type, key, value, options)
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
utils.nmap('<Space>', '<Nop>')
utils.map({ 'n', 'i' }, '<F1>', '<Nop>')

-- lspSaga stuffs {{{
utils.noremap({ 'n', 'i' }, '<C-S-SPACE>', vim.lsp.buf.signature_help)
-- }}}

-- window movement {{{
if vim.fn.has('macunix') == 1 then
    utils.nnoremap('∆', '<c-w>j', { silent = true })
    utils.nnoremap('˚', '<c-w>k', { silent = true })
    utils.nnoremap('¬', '<c-w><c-l>', { silent = true })
    utils.nnoremap('˙', '<c-w><c-h>', { silent = true })
else
    utils.nnoremap('<A-j>', '<c-w>j')
    utils.nnoremap('<A-k>', '<c-w>k')
    utils.nnoremap('<A-l>', '<c-w><c-l>', { silent = true })
    utils.nnoremap('<A-h>', '<c-w><c-h>', { silent = true })
end
-- }}}

vim.keymap.set("n", "<c-D>", "<c-D>zz")
vim.keymap.set("n", "<c-U>", "<c-U>zz")

-- greatest remap ever
-- vim.keymap.set("x", "<leader>p", [["_dP]])

-- next greatest remap ever : asbjornHaland
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set({ "n", "v" }, "<leader>Y", [["+Y]])
vim.keymap.set({ "n", "v" }, "<leader>p", [["+p]])
vim.keymap.set({ "n", "v" }, "<leader>P", [["+P]])

vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]])

utils.nnoremap('gX', [[:execute '!open ' . shellescape(expand('<cfile>'), 1)<CR>]], { silent = true })
utils.nnoremap('<leader>nh', '<CMD>noh<CR>')
utils.nnoremap('<F5>', '<CMD>e!<CR>', { silent = true })


-- TODO: wait until this is fixed in nvim
-- utils.cnoremap('w!!', 'w !sudo -S tee %')

-- vim: foldmethod=marker foldlevel=0
