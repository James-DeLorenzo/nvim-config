vim.cmd([[
    augroup packer_user_config
        autocmd!
        autocmd BufWritePost plugins.lua source <afile> | PackerCompile
    augroup end
]])
vim.cmd([[
    augroup keybind_user_config
        autocmd!
        autocmd BufWritePost keybinds.lua source <afile> | PackerCompile
    augroup end
]])
