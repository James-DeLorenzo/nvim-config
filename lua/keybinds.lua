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

utils.nnoremap('<Leader><Tab>', ':CHADopen<CR>', { silent= true })

utils.nnoremap('<F3>', ':Lspsaga open_floaterm<CR>', {silent = true})
utils.tnoremap('<F3>', '<C-\\><C-n>:Lspsaga close_floaterm<CR>', { silent = true })
