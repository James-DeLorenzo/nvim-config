return {
    -- basic nvim plugins {{{
    {
        'ThePrimeagen/vim-be-good',
        cmd = 'VimBeGood'
    },
    {
        "folke/which-key.nvim",
        lazy = false,
        config = function()
            vim.o.timeout = true
            vim.o.timeoutlen = 300
            require('which-key').setup {
            }
        end,
    },
    {
        'pwntester/octo.nvim',
        cmd = 'Octo',
        enabled = function()
            return 0 == os.execute("git status &> /dev/null")
        end,
        dependencies = {
            'nvim-lua/plenary.nvim',
            'nvim-telescope/telescope.nvim',
            'kyazdani42/nvim-web-devicons',
        },
        config = function()
            require('octo').setup()
        end
    },
    {
        'eandrju/cellular-automaton.nvim',
        keys = {
            { '<leader>mir', "<cmd>CellularAutomaton make_it_rain<CR>", noremap = true },
            { '<leader>gol', "<cmd>CellularAutomaton game_of_life<CR>", noremap = true }
        }
    },
    'kyazdani42/nvim-web-devicons',
    {
        'famiu/bufdelete.nvim',
        event = 'BufEnter'
    },
    'folke/trouble.nvim',
    {
        'lukas-reineke/indent-blankline.nvim',
        event = 'BufEnter',
        opts = {
            show_current_context = true,
            show_current_context_start = true,
            use_treesitter = true,
            space_char_highlight_list = { "Float" }
            -- use_treesitter_scope = true,

        }
    },
    {
        'ggandor/leap.nvim',
        enabled = false,
        config = function()
            require('leap').add_default_mappings()
        end
    },
    {
        "kylechui/nvim-surround",
        version = "*", -- Use for stability; omit to use `main` branch for the latest features
        event = "VeryLazy",
        config = function()
            require("nvim-surround").setup({})
        end
    },
    {
        'windwp/nvim-autopairs',
        event = 'BufReadPost'
    },
    {
        'lewis6991/gitsigns.nvim',
        event = 'BufReadPost',
        dependencies = {
            'nvim-lua/plenary.nvim'
        },
        keys = {
            { '<leader>glb', '<CMD>Gitsigns blame_line<CR>',   silent = true, noremap = true },
            { '<leader>ghb', '<CMD>Gitsigns preview_hunk<CR>', silent = true, noremap = true },
            { '<leader>ghr', '<CMD>Gitsigns reset_hunk<CR>',   silent = true, noremap = true },
            { '<leader>gd',  '<CMD>Gitsigns diffthis<CR>',     silent = true, noremap = true },
            { '<leader>gbr', '<CMD>Gitsigns reset_buffer<CR>', silent = true, noremap = true }
        },
        opts = {
            signcolumn = true,
            numhl = false,
        }
    },
    {
        'numToStr/Comment.nvim',
        event = 'BufReadPost'
        -- config = function()
        --     require('Comment').setup {}
        --     local ft = require('Comment.ft')
        --     ft.terraform = '#%s'
        -- end
    },
    {
        'gelguy/wilder.nvim',
        dependencies = {
            'romgrk/fzy-lua-native',
            'roxma/nvim-yarp'
        },
        config = function()
            local wilder = require('wilder')
            wilder.setup({
                modes = { ':', '/', '?' },
                enable_cmdline_enter = 0
            })

            wilder.set_option('pipeline', {
                wilder.branch(
                    wilder.python_file_finder_pipeline({
                        file_command = function(ctx, arg)
                            if string.find(arg, '.') ~= nil then
                                return { 'fd', '-tf', '-H', '-I' }
                            else
                                return { 'fd', '-tf' }
                            end
                        end,
                        dir_command = { 'fd', '-td' },
                        -- filters = { 'cpsm_filter' },
                    }),
                    wilder.substitute_pipeline({
                        pipeline = wilder.python_search_pipeline({
                            skip_cmdtype_check = 1,
                            pattern = wilder.python_fuzzy_pattern({
                                start_at_boundary = 0,
                            }),
                        }),
                    }),
                    wilder.cmdline_pipeline({
                        fuzzy = 2,
                        fuzzy_filter = wilder.lua_fzy_filter(),
                    }),
                    {
                        wilder.check(function(ctx, x) return x == '' end),
                        wilder.history(),
                    },
                    wilder.python_search_pipeline({
                        pattern = wilder.python_fuzzy_pattern({
                            start_at_boundary = 0,
                        }),
                    })
                ),
            })

            local highlighters = {
                -- wilder.pcre2_highlighter(),
                wilder.lua_fzy_highlighter(),
            }

            local popupmenu_renderer = wilder.popupmenu_renderer(
                wilder.popupmenu_border_theme({
                    border = 'rounded',
                    empty_message = wilder.popupmenu_empty_message_with_spinner(),
                    highlighter = highlighters,
                    left = {
                        ' ',
                        wilder.popupmenu_devicons(),
                        wilder.popupmenu_buffer_flags({
                            flags = ' a + ',
                            icons = { ['+'] = '', a = '', h = '' },
                        }),
                    },
                    right = {
                        ' ',
                        wilder.popupmenu_scrollbar(),
                    },
                })
            )

            local wildmenu_renderer = wilder.wildmenu_renderer({
                highlighter = highlighters,
                separator = ' · ',
                left = { ' ', wilder.wildmenu_spinner(), ' ' },
                right = { ' ', wilder.wildmenu_index() },
            })

            wilder.set_option('renderer', wilder.renderer_mux({
                [':'] = popupmenu_renderer,
                ['/'] = wildmenu_renderer,
                substitute = wildmenu_renderer,
            }))
            wilder.set_option('debounce', 200)
        end,
    },
    {
        'norcalli/nvim-colorizer.lua',
        config = function()
            require('colorizer').setup({ '*', }, { names = false, RRGGBBAA = true, })
        end
    },
    -- }}}
}
