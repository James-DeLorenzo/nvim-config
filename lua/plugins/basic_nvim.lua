return {
    -- basic nvim plugins {{{
    'ThePrimeagen/vim-be-good',
    'wbthomason/packer.nvim',
    {
    "folke/which-key.nvim",
    config = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
      require("which-key").setup({
        -- your configuration comes here
        -- or leave it empty to use the default settings
        -- refer to the configuration section below
      })
    end,
  },
  {
        'pwntester/octo.nvim',
        dependencies = {
            'nvim-lua/plenary.nvim',
            'nvim-telescope/telescope.nvim',
            'kyazdani42/nvim-web-devicons',
        },
        config = function()
            require "octo".setup()
        end
    },
    'eandrju/cellular-automaton.nvim',
    'kyazdani42/nvim-web-devicons',
    'famiu/bufdelete.nvim',
    'folke/trouble.nvim',
    { 'lukas-reineke/indent-blankline.nvim',
        config = function()
            require("indent_blankline").setup {
                show_current_context = true,
                show_current_context_start = true,
                use_treesitter = true,
                space_char_highlight_list = { "Float" }
                -- use_treesitter_scope = true,

            }
        end
    },
    { 'ggandor/leap.nvim',
        enabled = false,
        config = function()
            require('leap').add_default_mappings()
        end
    },
    { "kylechui/nvim-surround",
        version = "*", -- Use for stability; omit to use `main` branch for the latest features
        event = "VeryLazy",
        config = function()
            require("nvim-surround").setup({})
        end
    },
    { 'windwp/nvim-autopairs',
        config = function()
            require('nvim-autopairs').setup {}
        end
    },
    { 'lewis6991/gitsigns.nvim',
        dependencies = {
            'nvim-lua/plenary.nvim'
        },
        config = function()
            require('gitsigns').setup {
                signcolumn = true,
                numhl = false,
            }
        end
    },
    { 'numToStr/Comment.nvim',
        config = function()
            require('Comment').setup {}
            local ft = require('Comment.ft')
            ft.terraform = '#%s'
        end
    },
    { 'gelguy/wilder.nvim',
        lazy = false,
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
    { 'norcalli/nvim-colorizer.lua',
        config = function()
            require('colorizer').setup({ '*', }, { names = false, RRGGBBAA = true, })
        end
    },
    -- }}}
}
