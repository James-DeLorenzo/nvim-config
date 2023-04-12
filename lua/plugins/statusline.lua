return {
    {
        'feline-nvim/feline.nvim',
        dependencies = { 'james-delorenzo/bluloco_custom.nvim' }
    },
    {
        'rebelot/heirline.nvim',
        event = 'BufReadPre',
        dependencies = {
            'lewis6991/gitsigns.nvim',
            "uloco/bluloco.nvim"
        },
        config = function()
            require('setups.heirline_setup')
        end
    }
}
