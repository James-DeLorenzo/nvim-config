require("mason").setup()
local mason_lsp = require("mason-lspconfig")
local neodev = require("neodev")
local lspconfig = require("lspconfig")
local navic = require("nvim-navic")
local capabilities = require('cmp_nvim_lsp').default_capabilities()

neodev.setup()
mason_lsp.setup()
mason_lsp.setup_handlers {
    function(server_name)
        lspconfig[server_name].setup {
            capabilities = capabilities,
            on_attach = function(client, bufnr)
                if client.server_capabilities.documentSymbolProvider then
                    navic.attach(client, bufnr)
                end
            end
        }
    end,
    ["sumneko_lua"] = function()
        lspconfig.sumneko_lua.setup {
            settings = {
                Lua = {
                    workspace = {
                        checkThirdParty = false
                    },
                    completion = {
                        callSnippet = "Replace"
                    },
                    diagnostics = {
                        globals = { 'vim' }
                    }
                }
            },
            on_attach = function(client, bufnr)
                navic.attach(client, bufnr)
            end
        }
    end,
    ["pyright"] = function()
        lspconfig.pyright.setup {
            settings = {
                python = {
                    venvPath = "/Users/jamesdelorenzo/.virtualenvs",
                    reportUnnecessaryTypeIgnoreComment = true
                }
            },
            on_attach = function(client, bufnr)
                navic.attach(client, bufnr)
            end

        }
    end,
}

vim.cmd([[
    augroup Format
        autocmd!
        autocmd BufWritePre * lua vim.lsp.buf.format()
    augroup end
]])
