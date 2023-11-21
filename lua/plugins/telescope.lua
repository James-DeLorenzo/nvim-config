return {
    {
        'nvim-telescope/telescope.nvim',
        branch = '0.1.x',
        dependencies = {
            'nvim-lua/plenary.nvim',
            'nvim-telescope/telescope-file-browser.nvim'
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
        },
        cmd = 'Telescope',
        keys = {
            { '<leader>fa', '<CMD>Telescope lsp_code_actions<CR>', noremap = true },
            { '<leader>fb', '<CMD>Telescope buffers<CR>',          noremap = true },
            { '<leader>fd', '<CMD>Telescope diagnostics<CR>',      noremap = true },
            {
                '<leader>ff',
                function() require('telescope.builtin').find_files() end,
                noremap = true,
                desc =
                "Find Files"
            },
            {
                '<leader>fhf',
                function() require('telescope.builtin').find_files({ hidden = true }) end,
                noremap = true,
                desc = "Find hidden files"
            },
            { '<leader>fg',         '<CMD>Telescope live_grep<CR>',                 noremap = true },
            -- { '<leader>fh',         '<CMD>Telescope help_tags<CR>',                 noremap = true },
            { '<leader>fl',         '<CMD>Telescope current_buffer_fuzzy_find<CR>', noremap = true },
            { '<leader>fn',         '<CMD>Telescope lsp_document_symbols<CR>',      noremap = true },
            { '<leader>fs',         '<CMD>Telescope grep_string<CR>',               noremap = true },
            { '<leader><leader>ft', '<CMD>Telescope filetypes<CR>',                 noremap = true },
            { '<leader>gf',         '<CMD>Telescope git_files<CR>',                 noremap = true },

        }
    },
    {
        "nvim-telescope/telescope-file-browser.nvim",
        keys = {
            { '<leader>bb', '<CMD>Telescope file_browser<CR>', noremap = true },
        },
        config = function()
            require('telescope').load_extension("file_browser")
        end
    }
}
