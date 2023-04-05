return {
    "folke/neodev.nvim",
    { 'williamboman/mason.nvim',
        dependencies = {
            'williamboman/mason-lspconfig.nvim',
            'neovim/nvim-lspconfig'
        }
    },
    { 'SmiteshP/nvim-navic',
        dependencies = {
            "neovim/nvim-lspconfig"
        }
    },
    { 'kkharji/lspsaga.nvim',
        dependencies = { 'neovim/nvim-lspconfig' },
        config = function()
            local saga = require('lspsaga')
            saga.init_lsp_saga()
        end
    },
    -- cmp {{{
    { 'hrsh7th/nvim-cmp',
        dependencies = {
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
            local cmp = require 'cmp'
            local lspkind = require 'lspkind'
            cmp.setup({
                formatting = {
                    format = lspkind.cmp_format({
                        mode = 'symbol_text',
                        with_text = true,
                        menu = ({
                            nvim_lsp = "[lsp]",
                            buffer = "[Buf]",
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
                    { name = 'path',   max_item_count = 5 },
                    { name = 'buffer', max_item_count = 3 },
                    { name = 'rg',     max_item_count = 3 },
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
}