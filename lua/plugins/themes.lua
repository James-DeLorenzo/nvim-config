return {
    -- themes {{{
    'rktjmp/lush.nvim',
    {
        "rktjmp/shipwright.nvim",
        dependencies = { 'rktjmp/lush.nvim' }
    },
    {
        'uloco/bluloco.nvim',
        -- lazy = false,
        event = "VimEnter",
        priority = 1000,
        dependencies = { 'rktjmp/lush.nvim' },
        opts = {
            style = "auto", -- "auto" | "dark" | "light"
            transparent = false,
            italics = false,
            terminal = vim.fn.has("gui_running") == 1, -- bluoco colors are enabled in gui terminals per default.
        },
        config = function()
            vim.cmd([[colorscheme bluloco]])
        end,
    },
    {
        'james-delorenzo/bluloco_custom.nvim',
        dependencies = { 'rktjmp/lush.nvim' },
    }
    -- }}}
}
