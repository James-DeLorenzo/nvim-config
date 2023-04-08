return {
    {
        'tpope/vim-sensible',
        lazy = false
    },
    {
        'tpope/vim-fugitive',
        enabled = function()
            return 0 == os.execute("git status &> /dev/null")
        end,
    },
    {
        'matze/vim-move',
        init = function()
            vim.api.nvim_set_var('move_key_modifier', 'C')
            vim.api.nvim_set_var('move_key_modifier_visualmode', 'C')
        end,
        keys = {
            { '<C-h>', mode = { 'n', 'v' } },
            { '<C-j>', mode = { 'n', 'v' } },
            { '<C-k>', mode = { 'n', 'v' } },
            { '<C-l>', mode = { 'n', 'v' } }
        }
    }
}
