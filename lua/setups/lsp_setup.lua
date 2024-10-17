local mok, mason = pcall(require, 'mason')
if not mok then
    print("Mason was not loaded, skipping lsp setup...")
    return
else
    mason.setup()
end
-- neodev
local devok, neodev = pcall(require, 'neodev')
if not devok then
    print("Neodev was not loaded, skipping...")
else
    neodev.setup()
end
-- lsp-config
local lspok, lspconfig = pcall(require, 'lspconfig')
if not lspok then
    print("lspconfig was not loaded, skipping lsp setup...")
    return
end
-- naivc
local nok, navic = pcall(require, 'nvim-navic')
if not nok then
    print("navic was not loaded, skipping lsp setup...")
    return
end

local capabilities = require('cmp_nvim_lsp').default_capabilities()

local mlspok, mason_lsp = pcall(require, "mason-lspconfig")
if not mlspok then
    print("Mason_lsp was not loaded, skipping lsp setup...")
    print(mlspok)
    return
end
local function set_keys(bufnr)
    local opts = { buffer = bufnr, remap = false }

    vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
    vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
    vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
    vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
    vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
    vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)
    vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
    vim.keymap.set({ 'n', 'i' }, '<C-S-SPACE>', vim.lsp.buf.signature_help, opts)
    vim.keymap.set("n", "[d", function()
        local t = require("trouble")
        t.open()
        t.next({ skip_groups = true, jump = true })
        vim.cmd("normal! zz")
    end, opts)
    vim.keymap.set("n", "]d", function()
        local t = require("trouble")
        t.open()
        t.previous({ skip_groups = true, jump = true })
        vim.cmd("normal! zz")
    end, opts)
end
mason_lsp.setup()
mason_lsp.setup_handlers {
    function(server_name)
        lspconfig[server_name].setup {
            capabilities = capabilities,
            on_attach = function(client, bufnr)
                set_keys(bufnr)
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
                set_keys(bufnr)
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
                    editor = {
                        defaultformatter = "autopep8",
                    },
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
                set_keys(bufnr)
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
                set_keys(bufnr)
                -- make sure to only do this for servers that you intend, in this example "eslint"
                client.server_capabilities.document_formatting = true
                if client.server_capabilities.documentSymbolProvider then
                    navic.attach(client, bufnr)
                end
            end
        }
    end,
    ["yamlls"] = function()
        lspconfig.yamlls.setup {
            capabilities = capabilities,
            settings = {
                yaml = {
                    schemaStore = {
                        enable = true,
                        url = "https://www.schemastore.org/api/json/catalog.json",
                    },
                },
                redhat = {
                    telemetry = {
                        enabled = false,
                    },
                },
            },
            on_attach = function(client, bufnr)
                set_keys(bufnr)
                if client.server_capabilities.documentSymbolProvider then
                    navic.attach(client, bufnr)
                end
            end
        }
    end,
}
-- Utilities for creating configurations
local fuok, util = pcall(require, 'formatter.util')
if not fuok then
    print("formatter was not loaded, skipping lsp setup...")
    return
else
end

local fok, formatter = pcall(require, 'formatter')
if not fok then
    print("formatter was not loaded, skipping lsp setup...")
    return
else
end
-- Provides the Format, FormatWrite, FormatLock, and FormatWriteLock commands
formatter.setup {
    -- Enable or disable logging
    logging = true,
    -- Set the log level
    log_level = vim.log.levels.INFO,
    -- All formatter configurations are opt-in
    filetype = {
        python = {
            require("formatter.filetypes.python").black()
        },
        ["*"] = {
            -- "formatter.filetypes.any" defines default configurations for any
            -- filetype
            -- require("formatter.filetypes.any").remove_trailing_whitespace,
            function()
                -- Ignore already configured types.
                local defined_types = require("formatter.config").values.filetype
                if defined_types[vim.bo.filetype] ~= nil then
                    return nil
                end
                vim.lsp.buf.format()
            end,
        }
    }
}

vim.cmd([[
    augroup Format
        autocmd!
        autocmd BufWritePre * FormatWriteLock
    augroup end
]])
