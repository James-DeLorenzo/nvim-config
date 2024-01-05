return {
    {
        url = 'https://gitlab.com/HiPhish/rainbow-delimiters.nvim',
        main = 'rainbow-delimiters.setup',
        event = 'BufReadPost',

    },
    {
        'nvim-treesitter/nvim-treesitter',
        event = 'BufEnter',
        main = 'nvim-treesitter.configs',
        dependencies = {
            'nvim-treesitter/nvim-treesitter-refactor',
            'nvim-treesitter/playground',
            'nvim-treesitter/nvim-treesitter-context'
        },
        build = function()
            require("nvim-treesitter.install").update({ with_sync = true })
        end,
        opts = {
            highlight = {
                enable = true,
                -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
                -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
                -- Using this option may slow down your editor, and you may see some duplicate highlights.
                -- Instead of true it can also be a list of languages
                additional_vim_regex_highlighting = false,
            },
            -- refactor
            refactor = {
                highlight_definitions = {
                    enable = true,
                    -- Set to false if you have an `updatetime` of ~100.
                    clear_on_cursor_move = true,
                },
                highlight_current_scope = { enable = false },
                smart_rename = { enable = false },
                navigation = { enable = false }
            },
            -- playground
            playground = {
                enable = true
            }
        }
    }
}
