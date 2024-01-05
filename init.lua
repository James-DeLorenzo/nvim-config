-- bootstrap {{{
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)
vim.g.mapleader = " "
-- }}}

require('setups.settings')
require("lazy").setup('plugins', {
    defaults = {
        lazy = true
    },
    checker = {
        frequency = 86400
    },
    change_detection = {
        notify = false,
    }
})
require('setups.autocommands')
require('setups.keybinds')
require('setups.lsp_setup')
require('setups.treesitter-extras')

-- vim: foldmethod=marker foldlevel=0
