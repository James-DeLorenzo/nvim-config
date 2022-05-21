return require('packer').startup(function(use)
    -- basic vim plugins {{{
    use 'tpope/vim-sensible'
    -- use 'tpope/vim-commentary'
    use {
        'matze/vim-move',
        config = function ()
            vim.api.nvim_set_var('move_key_modifier', 'C')
        end
    }
    -- context {{{
    use {
        'wellle/context.vim',
        config = function () 
            vim.api.nvim_set_var('context_enabled', 0)
        end
    }
    -- }}}
    -- }}}
     -- basic nvim plugins {{{
    use 'wbthomason/packer.nvim'
    use 'kyazdani42/nvim-web-devicons'
    use 'ggandor/lightspeed.nvim'
    use 'famiu/bufdelete.nvim'
    use 'numToStr/FTerm.nvim'
    use {
        'windwp/nvim-autopairs',
        config = function()
            require('nvim-autopairs').setup{}
        end
    }
    use {
        'lewis6991/gitsigns.nvim',
        requires = {
          'nvim-lua/plenary.nvim'
        },
        config = function()
          require('gitsigns').setup {
              signcolumn = true,
              numhl = false,
          }
        end
    }
    use {
        'numToStr/Comment.nvim',
        config = function()
            require('Comment').setup {}
            local ft = require('Comment.ft')
            ft.set('terraform', '#%s')
        end
    }
    -- colorizer {{{
    use {
        'norcalli/nvim-colorizer.lua',
        config = function()
            require('colorizer').setup( { '*'; }, { names = false; RRGGBBAA = true; })
        end
    }
    -- }}}
    -- which-key {{{
    use {
        'folke/which-key.nvim',
        disable = false,
        config = function()
            require('which-key').setup{}
        end
    }
    -- }}}
    -- }}}
    -- buffer line stuff {{{
    use {
        'romgrk/barbar.nvim',
        requires = {'kyazdani42/nvim-web-devicons'},
        config = function ()
            vim.g.bufferline = {
                closable = false,
                insert_at_end = true,
                semantic_letters = true,
            }
        end
    }
    -- }}}
    -- nvim-tree {{{
    use {
        'kyazdani42/nvim-tree.lua',
        disable = true,
        requires = {
            'kyazdani42/nvim-web-devicons'
        },
        config = function()
            require('nvim-tree').setup{
                view = {
                    auto_resize = true,
                    side = 'right'
                }
            }
            vim.g.nvim_tree_indent_markers = true
            vim.g.nvim_tree_add_trailing = true
            vim.g.nvim_tree_group_empty = true
        end
    }
    -- }}}
    -- cheathsheet {{{
    use {
        'sudormrfbin/cheatsheet.nvim',
        requires = {
            'nvim-lua/popup.nvim',
            'nvim-lua/plenary.nvim',
            'nvim-telescope/telescope.nvim'
        },
        -- config = function()
        --     require("cheatsheet").setup {
        --         telescope_mappings
        --     }
        -- end
    }
    -- }}}
    -- themes {{{
    use 'rktjmp/lush.nvim'
    use {
        "rktjmp/shipwright.nvim",
        requires = { 'rktjmp/lush.nvim' }
    }
    use {
        -- 'james-delorenzo/bluloco.nvim',
        '~/workspaces/bluloco.nvim',
        requires = {'rktjmp/lush.nvim'},
        config = function ()
            vim.cmd('colorscheme bluloco_custom')
        end
    }
    -- }}}
    -- feline {{{
    use {
        'feline-nvim/feline.nvim',
        requires = {
            {
                '~/workspaces/bluloco.nvim'
            },
            {
                'SmiteshP/nvim-gps',
                requires = {'nvim-treesitter/nvim-treesitter'},
                config = function()
                    require('nvim-gps').setup()
                end
            }
        }
    }

    -- }}}
    -- tree-sitter {{{
    use {
        'nvim-treesitter/nvim-treesitter',
        requires = {
            'p00f/nvim-ts-rainbow',
            'nvim-treesitter/nvim-treesitter-refactor',
            'nvim-treesitter/playground'
        },
        run = ':TSUpdate',
        config = function()
            vim.wo.foldmethod = "expr"
            vim.o.foldexpr = "nvim_treesitter#foldexpr()"
            require('nvim-treesitter.configs').setup {
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
                    enable = true
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
        end
    }
    -- }}}
    -- telescope configs {{{
    use {
        'nvim-telescope/telescope.nvim',
        requires = {
            {'nvim-lua/plenary.nvim'}
        },
        config = function()
            require('telescope').setup {
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
        end
    }

    -- }}}
    -- LSP Stuffs {{{
    -- Lsp Config & installer {{{
    use {
        'williamboman/nvim-lsp-installer',
        requires = {
            "neovim/nvim-lspconfig"
        }
    }
    -- }}}
    -- LSP Saga {{{
    use {
        'tami5/lspsaga.nvim',
        requires = {'neovim/nvim-lspconfig'},
        config = function()
            local saga = require('lspsaga')
            saga.init_lsp_saga()
        end
    }
    -- }}}
    -- cmp {{{
    use {
        'hrsh7th/nvim-cmp',
        requires = {
            'neovim/nvim-lspconfig',
            'hrsh7th/cmp-nvim-lua',
            'hrsh7th/cmp-nvim-lsp',
            'hrsh7th/cmp-buffer',
            'hrsh7th/cmp-path',
            'hrsh7th/cmp-cmdline',
            'onsails/lspkind-nvim',
            'L3MON4D3/LuaSnip',
            'saadparwaiz1/cmp_luasnip',
            -- extra stuff i'm trying
            'lukas-reineke/cmp-rg',
        },
        config = function()
            -- Setup nvim-cmp.
            local cmp = require'cmp'
            local lspkind = require 'lspkind'
            cmp.setup({
                formatting = {
                    format = lspkind.cmp_format({
                        mode = 'symbol_text',
                        with_text = true,
                        menu = ({
                            buffer = "[Buf]",
                            nvim_lsp = "[lsp]",
                            luasnip = "[snip]",
                            nvim_lua = "[lua]",
                            rg = "[RG]",
                            path = "[Path]"

                        })
                    })
                },
                snippet = {
                    expand = function(args)
                        require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
                    end,
                },
                mapping = {
                  ['<C-b>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
                  ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
                  ['<C-j>'] = cmp.mapping(cmp.mapping.select_next_item(), { 'i', 'c' }),
                  ['<C-k>'] = cmp.mapping(cmp.mapping.select_prev_item(), { 'i', 'c' }),
                  -- FIXME: why don't this work?
                  -- ['<C-l>'] = cmp.mapping(function(fallback)
                  --   if cmp.visible() == true then
                  --     return cmp.complete_common_string()
                  --   else
                  --     fallback()
                  --   end
                  -- end, { 'i', 'c' }),
                  ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
                  -- ['<C-y>'] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
                  ['<C-e>'] = cmp.mapping({
                    i = cmp.mapping.abort(),
                    c = cmp.mapping.close(),
                  }),
                  ['<C-y>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
                },
                sources = cmp.config.sources({
                  { name = 'nvim_lsp' },
                  { name = 'luasnip' },
                  { name = 'nvim_lua' },
                }, {
                    { name = 'path', max_item_count = 5 },
                    { name = 'buffer', max_item_count = 5 },
                    { name = 'rg', max_item_count = 5 },
                }),
                experimental = {
                    native_menu = false,
                    ghost_text = true
                }
            })

            -- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
            -- cmp.setup.cmdline('/', {
            --     sources = {
            --         { name = 'buffer' }
            --     }
            -- })

            -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
            -- cmp.setup.cmdline(':', {
            --     sources = cmp.config.sources({
            --         { name = 'path' } },
            --     {
            --         { name = 'cmdline' }
            --     })
            -- })

            -- Setup lspconfig.
            -- local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
            -- Replace <YOUR_LSP_SERVER> with each lsp server you've enabled.
            -- require('lspconfig')['<YOUR_LSP_SERVER>'].setup {
            --     capabilities = capabilities
            -- }
        end
    }
    -- }}}
    -- }}}
end)

-- vim: foldmethod=marker foldlevel=0
