return {
    {
        'tpope/vim-sensible',
        lazy = false
    },
    'tpope/vim-fugitive',
    -- use 'tpope/vim-commentary'
    { 'matze/vim-move',
        config = function()
            vim.api.nvim_set_var('move_key_modifier', 'C')
            vim.api.nvim_set_var('move_key_modifier_visualmode', 'C')
        end
    }
}
