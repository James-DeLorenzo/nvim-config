return {
    { 'romgrk/barbar.nvim',
        dependencies = { 'kyazdani42/nvim-web-devicons' },
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
