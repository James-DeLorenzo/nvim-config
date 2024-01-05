return {
    {
        'rebelot/heirline.nvim',
        event = 'VimEnter',
        dependencies = {
            'lewis6991/gitsigns.nvim',
            "uloco/bluloco.nvim"
        },
        config = function()
            require('setups.heirline_setup')
        end
    }
}
