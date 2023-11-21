local ok, mason = pcall(require, 'mason')
if not ok then
    print("Mason had an error, skipping lsp setup...")
    return
end
mason.setup()
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
    ["lua_ls"] = function()
        lspconfig.lua_ls.setup {
            capabilities = capabilities,
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
                if client.server_capabilities.documentSymbolProvider then
                    navic.attach(client, bufnr)
                end
            end
        }
    end,
    ["pyright"] = function()
        lspconfig.pyright.setup {
            capabilities = capabilities,
            settings = {
                python = {
                    venvPath = "/Users/james.delorenzo/.local/share/virtualenvs/",
                    analysis = {
                        diagnosticSeverityOverrides = {
                            reportUnnecessaryTypeIgnoreComment = "error",
                            reportTypedDictNotRequiredAccess = "none",
                        }
                    }
                },
            },
            on_attach = function(client, bufnr)
                if client.server_capabilities.documentSymbolProvider then
                    navic.attach(client, bufnr)
                end
            end
        }
    end,
    ["eslint"] = function()
        lspconfig.eslint.setup {
            capabilities = capabilities,
            root_dir = function()
                return vim.fn.getcwd()
            end,
            on_attach = function(client, bufnr)
                -- make sure to only do this for servers that you intend, in this example "eslint"
                client.server_capabilities.document_formatting = true
                if client.server_capabilities.documentSymbolProvider then
                    navic.attach(client, bufnr)
                end
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
