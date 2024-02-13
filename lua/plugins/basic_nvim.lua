return {
    -- basic nvim plugins {{{
    'nvim-tree/nvim-web-devicons',
    {
        'folke/trouble.nvim',
        event = "VeryLazy",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        opts = {},
        keys = {
            { '<leader>xx', function() require('trouble').toggle() end },
            { '<leader>xq', function() require('trouble').toggle("quickfix") end },
            { '<leader>xl', function() require('trouble').toggle("loclist") end },
            { '<leader>xw', function() require('trouble').toggle("lsp_workspace_diagnostics") end },
            { '<leader>xd', function() require('trouble').toggle("lsp_document_diagnostics") end },
        }
    },
    {
        "folke/zen-mode.nvim",
        dependencies = {
            { 'folke/twilight.nvim', opts = { dimming = { alpha = .4 }, context = 20 } }
        },
        keys = {
            { "<leader>zz", "<cmd>ZenMode<CR>", desc = "Zen Mode" },
        },
        opts = {
            window = {
                options = {
                    foldcolumn = '0',
                }
            },
            plugins = {
                options = {
                    showcmd = 0,
                },
                gitsigns = { enabled = false },
            },
        }
    },
    {
        "folke/persistence.nvim",
        enabled = false,
        -- lazy = false,
        keys = {
            { '<leader>qs', function() require("persistence").load() end },
        }
        -- event = "VimEnter",
        -- config = function()
        --     require("persistence").setup {}
        --     vim.api.nvim_create_autocmd("VimEnter", {
        --         group = vim.api.nvim_create_augroup("persistencegroup", { clear = true }),
        --         callback = function()
        --             require("persistence").load()
        --         end,
        --     })
        -- end
    },
    {
        'zbirenbaum/copilot.lua',
        lazy = false,
        opts = {
            panel = { enabled = false, },
            suggestion = { enabled = false, },
        }
    },
    {
        'famiu/bufdelete.nvim',
        event = 'BufEnter'
    },
    {
        'ThePrimeagen/vim-be-good',
        cmd = 'VimBeGood'
    },
    {
        "ThePrimeagen/harpoon",
        branch = "harpoon2",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            local harpoon = require("harpoon")

            -- REQUIRED
            harpoon:setup {}
            -- REQUIRED
        end,
        keys = {
            {
                "<leader>ha",
                function()
                    local harpoon = require('harpoon'); harpoon:list():append()
                end,
                desc = "append to harpoon"
            },
            { "<leader>ho", function()
                local harpoon = require('harpoon'); harpoon.ui:toggle_quick_menu(harpoon:list())
            end },
            { "<C-A-j>", function()
                local harpoon = require('harpoon'); harpoon:list():select(1)
            end },
            { "<C-A-k>", function()
                local harpoon = require('harpoon'); harpoon:list():select(2)
            end },
            { "<C-A-l>", function()
                local harpoon = require('harpoon'); harpoon:list():select(3)
            end },
            { "<C-A-;>", function()
                local harpoon = require('harpoon'); harpoon:list():select(4)
            end },
            { "<C-A-P>", function()
                local harpoon = require('harpoon'); harpoon:list():prev()
            end },
            { "<C-A-N>", function()
                local harpoon = require('harpoon'); harpoon:list():next()
            end },
            -- Toggle previous & next buffers stored within Harpoon list
        }
    },
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        init = function()
            vim.o.timeout = true
            vim.o.timeoutlen = 300
        end,
        opts = {}
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
            'nvim-tree/nvim-web-devicons',
        },
    },
    {
        'eandrju/cellular-automaton.nvim',
        keys = {
            { '<leader>mir', "<cmd>CellularAutomaton make_it_rain<CR>", noremap = true },
            { '<leader>gol', "<cmd>CellularAutomaton game_of_life<CR>", noremap = true }
        }
    },
    {
        'lukas-reineke/indent-blankline.nvim',
        --enabled = false,
        event = 'BufEnter',
        main = "ibl",
        opts = {
            indent = {
                smart_indent_cap = true,
                highlight = { "Whitespace" }
            },
            scope = {
                show_start = true,
                highlight = { "Statement" }
            },
            whitespace = {
                highlight = { "Whitespace" }
            }
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
        opts = {}
    },
    {
        'windwp/nvim-autopairs',
        event = 'BufReadPost',
        opts = {}
    },
    {
        'lewis6991/gitsigns.nvim',
        lazy = false,
        -- event = 'BufReadPost',
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
        event = 'BufReadPost',
        opts = {}
    },
    {
        'gelguy/wilder.nvim',
        enabled = false,
        -- event = 'VeryLazy',
        dependencies = {
            'romgrk/fzy-lua-native',
            'roxma/nvim-yarp'
        },
        config = function()
            local wilder = require('wilder')
            wilder.setup({
                modes = { ':', '/', '?' },
                -- enable_cmdline_enter = 0
            })

            wilder.set_option('pipeline', {
                wilder.branch(
                -- wilder.python_file_finder_pipeline({
                --             file_command = function(ctx, arg)
                --                 if string.find(arg, '.') ~= nil then
                --                     return { 'fd', '-tf', '-H', '-I' }
                --                 else
                --                     return { 'fd', '-tf' }
                --                 end
                --             end,
                -- dir_command = { 'fd', '-td' },
                --             -- filters = { 'cpsm_filter' },
                -- }),
                    wilder.substitute_pipeline({
                        pipeline = wilder.python_search_pipeline({
                            --                 skip_cmdtype_check = 1,
                            --                 pattern = wilder.python_fuzzy_pattern({
                            --                     start_at_boundary = 0,
                            --                 }),
                        }),
                    }),
                    wilder.python_search_pipeline({
                        pattern = wilder.python_fuzzy_pattern({
                            start_at_boundary = 0,
                        }),
                    }),
                    wilder.cmdline_pipeline({
                        language = 'python',
                        fuzzy = 2,
                        fuzzy_filter = wilder.lua_fzy_filter(),
                    }),
                    {
                        wilder.check(function(ctx, x) return x == '' end),
                        wilder.history(),
                    }
                )
            })

            -- local highlighters = {
            --     -- wilder.pcre2_highlighter(),
            --     wilder.lua_fzy_highlighter(),
            -- }

            local popupmenu_renderer = wilder.popupmenu_renderer({
                pumblend = 30,
                highlighter = wilder.lua_fzy_highlighter()

                --     wilder.popupmenu_border_theme({
                --         border = 'rounded',
                --         empty_message = wilder.popupmenu_empty_message_with_spinner(),
                --         highlighter = highlighters,
                --         left = {
                --             ' ',
                --             wilder.popupmenu_devicons(),
                --             wilder.popupmenu_buffer_flags({
                --                 flags = ' a + ',
                --                 icons = { ['+'] = '', a = '', h = '' },
                --             }),
                --         },
                --         right = {
                --             ' ',
                --             wilder.popupmenu_scrollbar(),
                --         },
                --     })
            })

            -- local wildmenu_renderer = wilder.wildmenu_renderer({
            --     highlighter = highlighters,
            --     separator = ' · ',
            --     left = { ' ', wilder.wildmenu_spinner(), ' ' },
            --     right = { ' ', wilder.wildmenu_index() },
            -- })

            wilder.set_option('renderer', popupmenu_renderer)
            -- wilder.set_option('debounce', 200)
        end,
    },
    {
        'norcalli/nvim-colorizer.lua',
        event = 'BufReadPost',
        config = function()
            require('colorizer').setup({ '*', }, { names = false, RRGGBBAA = true, })
        end
    },
    {
        'mbbill/undotree',
        keys = {
            { '<leader>u', vim.cmd.UndotreeToggle, silent = true, noremap = true, desc = "Open UndoTree" }
        }
    },
    -- }}}
}

-- vim: foldmethod=marker foldlevel=99
