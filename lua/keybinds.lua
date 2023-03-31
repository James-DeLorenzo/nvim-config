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
vim.g.mapleader = " "

-- utils.nnoremap('<F3>', '<CMD>lua require("FTerm").toggle()<CR>', {silent = true})
-- utils.tnoremap('<F3>', '<C-\\><C-n><CMD>lua require("FTerm").toggle()<CR>', { silent = true })

-- lspSaga stuffs {{{
utils.nnoremap('<F2>', '<CMD>Lspsaga rename<CR>', { silent = true })
utils.nnoremap('<F24>', '<CMD>Lspsaga lsp_finder<CR>', { silent = true })
utils.nnoremap('<C-S-SPACE>', '<CMD>Lspsaga signature_help<CR>')
utils.inoremap('<C-S-SPACE>', '<CMD>Lspsaga signature_help<CR>')
-- }}}

-- barbar {{{
utils.nnoremap('<Leader>bc', '<CMD>BufferPick<CR>', { silent = true })
utils.nnoremap('<Leader>bq', '<CMD>BufferClose<CR>', { silent = true })
utils.nnoremap('<Leader>bn', '<CMD>BufferNext<CR>', { silent = true })
utils.nnoremap('<Leader>bp', '<CMD>BufferPrevious<CR>', { silent = true })
-- utils.nnoremap('<C-^I>', 'BufferNext', { silent = true })
-- }}}

-- Telescope {{{
utils.nnoremap('<leader>fa', '<CMD>Telescope lsp_code_actions<CR>')
utils.nnoremap('<leader>fb', '<CMD>Telescope buffers<CR>')
utils.nnoremap('<leader>fd', '<CMD>Telescope diagnostics<CR>')
utils.nnoremap('<leader>ff', function() require('telescope.builtin').find_files() end, { desc = "Find Files" })
utils.nnoremap('<leader>fhf', function() require('telescope.builtin').find_files({ hidden = true }) end)
utils.nnoremap('<leader>fg', '<CMD>Telescope live_grep<CR>')
utils.nnoremap('<leader>fh', '<CMD>Telescope help_tags<CR>')
utils.nnoremap('<leader>fl', '<CMD>Telescope current_buffer_fuzzy_find<CR>')
utils.nnoremap('<leader>fn', '<CMD>Telescope lsp_document_symbols<CR>')
utils.nnoremap('<leader>fs', '<CMD>Telescope grep_string<CR>')
utils.nnoremap('<leader><leader>ft', '<CMD>Telescope filetypes<CR>')
utils.nnoremap('<leader>gf', '<CMD>Telescope git_files<CR>')
utils.nnoremap('<leader>bb', '<CMD>Telescope file_browser<CR>')
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

-- Git {{{
utils.nnoremap('<leader>glb', '<CMD>Gitsigns blame_line<CR>', { silent = true })
utils.nnoremap('<leader>ghb', '<CMD>Gitsigns preview_hunk<CR>', { silent = true })
utils.nnoremap('<leader>ghr', '<CMD>Gitsigns reset_hunk<CR>', { silent = true })
utils.nnoremap('<leader>gd', '<CMD>Gitsigns diffthis<CR>', { silent = true })
utils.nnoremap('<leader>gbr', '<CMD>Gitsigns reset_buffer<CR>', { silent = true })
-- }}}

-- local function test()
--     print("test")
-- end
-- utils.nnoremap('<leader>te', [[]])

vim.keymap.set("n", "<c-D>", "<c-D>zz")
vim.keymap.set("n", "<c-U>", "<c-U>zz")

-- greatest remap ever
vim.keymap.set("x", "<leader>p", [["_dP]])

-- next greatest remap ever : asbjornHaland
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]])

utils.nnoremap('gX', [[:execute '!open ' . shellescape(expand('<cfile>'), 1)<CR>]], { silent = true })
utils.nnoremap('<leader>nh', '<CMD>noh<CR>')
utils.nnoremap('<F5>', '<CMD>e!<CR>', { silent = true })


utils.nnoremap('<leader>mir', "<cmd>CellularAutomaton make_it_rain<CR>")
utils.nnoremap('<leader>gol', "<cmd>CellularAutomaton game_of_life<CR>")
-- TODO: wait until this is fixed in nvim
-- utils.cnoremap('w!!', 'w !sudo -S tee %')

-- vim: foldmethod=marker foldlevel=0
