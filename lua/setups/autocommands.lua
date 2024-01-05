local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd
--
-- vim.cmd([[
--     augroup keybind_user_config
--         autocmd!
--         autocmd BufWritePost keybinds.lua source <afile>
--     augroup end
-- ]])


autocmd({ "BufWritePre" }, {
    group = augroup("TrimWhitespace", {}),
    pattern = "*",
    command = [[%s/\s\+$//e]],

})
