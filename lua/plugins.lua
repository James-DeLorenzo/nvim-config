return require('packer').startup(function(use)
    -- basic vim plugins {{{
    use 'tpope/vim-sensible'
    use 'tpope/vim-commentary'
    use 'matze/vim-move'
    -- }}}
    use 'wbthomason/packer.nvim'
    use 'kyazdani42/nvim-web-devicons'
    use 'ggandor/lightspeed.nvim'
    use 'mhinz/vim-signify'
    use 'famiu/bufdelete.nvim'
    use {
        'ms-jpq/chadtree',
        config = function()
            local chadtree_settings = {
                ["view"]= {
                    ["open_direction"]= "right",
                    ["width"] = 35
                }
            }
            vim.api.nvim_set_var("chadtree_settings", chadtree_settings)
        end
    }
    -- sidebar {{{
    -- use {
    --     'sidebar-nvim/sidebar.nvim',
    --     config = function()
    --         require('sidebar-nvim').setup {
    --             open = true,
    --             hide_statusline = true,
    --             side = 'right',
    --             initial_width = 35,
    --             disable_closing_prompt = true,
    --             sections = {
    --                 "buffers",
    --                 "git",
    --                 "todos",
    --                 "symbols",
    --                 "diagnostics"
    --             },
    --             files = {
    --                 show_hidden = true
    --             }
    --         }
    --     end
    -- }
    -- }}}
    -- barbar {{{
    use {
        'romgrk/barbar.nvim',
        requires = {'kyazdani42/nvim-web-devicons'}
    }
    -- }}}
    -- nvim-tree {{{
    -- use {
    --     'kyazdani42/nvim-tree.lua',
    --     requires = {
    --         'kyazdani42/nvim-web-devicons'
    --     },
    --     config = function() require('nvim-tree').setup{
    --         view = {
    --             auto_resize = true,
    --             side = 'right'
    --         }
    --     } end
    -- }
    -- }}}
    -- cheathsheet {{{
    use {
        'sudormrfbin/cheatsheet.nvim',
        requires = {
            'nvim-lua/popup.nvim',
            'nvim-lua/plenary.nvim',
            'nvim-telescope/telescope.nvim'
        }
    }
    -- }}}
    -- themes {{{
    -- use 'tjdevries/colorbuddy.nvim'
    use 'rktjmp/lush.nvim'
    use {
        "rktjmp/shipwright.nvim",
        requires = { 'rktjmp/lush.nvim' }
    }
    -- use 'altercation/vim-colors-solarized'
    use 'dracula/vim'
    -- }}}
    -- feline {{{
    use {
        'feline-nvim/feline.nvim',
        requires = {
            {
                'SmiteshP/nvim-gps',
                requires = {'nvim-treesitter/nvim-treesitter'},
                config = function()
                    require('nvim-gps').setup()
                end
            }
        },
        config = function()
            -- Substitute preset_name with the name of the preset you want to modify.
            -- eg: "default" or "noicon"
            local components = require('feline.presets')['noicon']
            local gps = require('nvim-gps')
            table.insert(components.active[1], {
                provider = function()
                    return gps.get_location()
                end,
                enabled = function()
                    return gps.is_available()
                end
            })
            require('feline').setup {
                preset = 'noicon'
            }
        end
    }

    -- }}}
    -- tree-sitter {{{
    use {
        'nvim-treesitter/nvim-treesitter',
        run = ':TSUpdate',
        config = function()
            require('nvim-treesitter.configs').setup {
                highlight = {
                    enable = true,
                    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
                    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
                    -- Using this option may slow down your editor, and you may see some duplicate highlights.
                    -- Instead of true it can also be a list of languages
                    additional_vim_regex_highlighting = false,
                },
                rainbow = {
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
        }
    }

    -- }}}
    -- LSP {{{
    use {
        'williamboman/nvim-lsp-installer',
        config = function()
           local lsp_installer = require("nvim-lsp-installer")

            -- Register a handler that will be called for all installed servers.
            -- Alternatively, you may also register handlers on specific server instances instead (see example below).
            lsp_installer.on_server_ready(function(server)
                local opts = {}

                -- (optional) Customize the options passed to the server
                -- if server.name == "tsserver" then
                --     opts.root_dir = function() ... end
                -- end

                -- This setup() function is exactly the same as lspconfig's setup function.
                -- Refer to https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
                server:setup(opts)
            end)
        end
    }
    use {
        'neovim/nvim-lspconfig',
        config = function()
            local lspconfig = require("lspconfig")
            -- for arch ccls is managed with yay
            lspconfig.ccls.setup {
                init_options = {
                     cache = {
                      directory = ".ccls-cache";
                     }
                 }
            }
        end
    }
    use {
        'glepnir/lspsaga.nvim',
        requires = {'neovim/nvim-lspconfig'},
        config = function()
            local saga = require('lspsaga')
            saga.init_lsp_saga()
        end
    }
    -- cmp {{{
    -- use {
    --     'hrsh7th/nvim-cmp',
    --     requires = {
    --         'neovim/nvim-lspconfig',
    --         'hrsh7th/cmp-nvim-lsp',
    --         'hrsh7th/cmp-buffer',
    --         'hrsh7th/cmp-path',
    --         'hrsh7th/cmp-cmdline'
    --     },
    --     config = {
    --         -- Setup nvim-cmp.
    --         local cmp = require'cmp'

    --         cmp.setup({
    --         snippet = {
    --             -- REQUIRED - you must specify a snippet engine
    --            -- expand = function(args)
    --                 vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
    --                 -- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
    --                 -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
    --                 -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
    --           - end,
    --         },
    --         mapping = {
    --           ['<C-b>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
    --           ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
    --           ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
    --           ['<C-y>'] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
    --           ['<C-e>'] = cmp.mapping({
    --             i = cmp.mapping.abort(),
    --             c = cmp.mapping.close(),
    --           }),
    --           ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    --         },
    --         sources = cmp.config.sources({
    --           { name = 'nvim_lsp' },
    --           { name = 'vsnip' }, -- For vsnip users.
    --           -- { name = 'luasnip' }, -- For luasnip users.
    --           -- { name = 'ultisnips' }, -- For ultisnips users.
    --           -- { name = 'snippy' }, -- For snippy users.
    --         }, {
    --           { name = 'buffer' },
    --         })
    --         })

    --         -- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
    --         cmp.setup.cmdline('/', {
    --         sources = {
    --           { name = 'buffer' }
    --         }
    --         })

    --         -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
    --         cmp.setup.cmdline(':', {
    --         sources = cmp.config.sources({
    --           { name = 'path' }
    --         }, {
    --           { name = 'cmdline' }
    --         })
    --         })

    --         -- Setup lspconfig.
    --         local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
    --         -- Replace <YOUR_LSP_SERVER> with each lsp server you've enabled.
    --         require('lspconfig')['<YOUR_LSP_SERVER>'].setup {
    --         capabilities = capabilities
    --   }
    --     }

    -- }}}
    -- }}}
end)
