return {
    { 'nvim-telescope/telescope.nvim',
        branch = '0.1.x',
        dependencies = {
            'nvim-lua/plenary.nvim'
        },
        opts = {
            defaults = {
                path_display = {
                    shorten = 5,
                    truncate = 3
                },
                hl_result_eol = false,
                dynamic_preview_title = true,
                -- layouts
                sorting_strategy = 'ascending',
                layout_config = {
                    horizontal = {
                        prompt_position = 'top',
                    }
                }
            }
        }
    },
    { "nvim-telescope/telescope-file-browser.nvim",
        config = function()
            require('telescope').load_extension("file_browser")
        end
    }
}
