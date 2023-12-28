return {
    {
        'romgrk/barbar.nvim',
        event = "BufEnter",
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        keys = {
            { '<Leader>bc', '<CMD>BufferPick<CR>',     silent = true, noremap = true },
            { '<Leader>bq', '<CMD>BufferClose<CR>',    silent = true, noremap = true },
            { '<Leader>bn', '<CMD>BufferNext<CR>',     silent = true, noremap = true },
            { '<Leader>bp', '<CMD>BufferPrevious<CR>', silent = true, noremap = true }
        },
        opts = {
            auto_hide = true,
            insert_at_end = true,
            highlight_alternate = true,
            icons = {
                button = false,
                modified = {
                    button = false
                },
                diagnostics = {
                    [vim.diagnostic.severity.ERROR] = { enabled = true },
                    [vim.diagnostic.severity.WARN] = { enabled = true },
                    [vim.diagnostic.severity.INFO] = { enabled = true },
                    [vim.diagnostic.severity.HINT] = { enabled = true, icon = "" },
                },
            }
        }
    }
}
