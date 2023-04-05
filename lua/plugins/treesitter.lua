return {
    { 'nvim-treesitter/nvim-treesitter',
        dependencies = {
            'lincheney/nvim-ts-rainbow',
            'nvim-treesitter/nvim-treesitter-refactor',
            'nvim-treesitter/playground',
            'nvim-treesitter/nvim-treesitter-context'
        },
        build = ':TSUpdate',
        opts = {
            highlight = {
                enable = true,
                -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
                -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
                -- Using this option may slow down your editor, and you may see some duplicate highlights.
                -- Instead of true it can also be a list of languages
                additional_vim_regex_highlighting = false,
            },
            -- ts-rainbow
            rainbow = {
                enable = true,
                highlight_middle = false
            },
            -- refactor
            refactor = {
                highlight_definitions = {
                    enable = true,
                    -- Set to false if you have an `updatetime` of ~100.
                    clear_on_cursor_move = true,
                },
                highlight_current_scope = { enable = false },
                smart_rename = {
                    enable = true,
                    -- keymaps = {
                    --     smart_rename = "grr"
                    -- }
                },
                navigation = {
                    enable = true
                }
            },
            -- playground
            playground = {
                enable = true
            }
        }
    }

}
