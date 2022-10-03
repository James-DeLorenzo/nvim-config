require("nvim-lsp-installer").setup {
    log_level = vim.log.levels.DEBUG
}
local lspconfig = require("lspconfig")
local navic = require("nvim-navic")
lspconfig.sumneko_lua.setup {
    settings = {
        Lua = {
            diagnostics = {
                globals = { 'vim' }
            }
        }
    },
    on_attach = function(client, bufnr)
        navic.attach(client, bufnr)
    end
}
lspconfig.pyright.setup {
    settings = {
        python = {
            venvPath = "/Users/jamesdelorenzo/.virtualenvs"
        }
    },
    on_attach = function(client, bufnr)
        navic.attach(client, bufnr)
    end
}
lspconfig.ccls.setup {
    init_options = {
        cache = {
            directory = ".ccls-cache";
        }
    },
    on_attach = function(client, bufnr)
        navic.attach(client, bufnr)
    end
}
lspconfig.terraformls.setup {
    on_attach = function(client, bufnr)
        navic.attach(client, bufnr)
    end
}
lspconfig.tflint.setup {
    -- on_attach = function(client, bufnr)
    --     navic.attach(client, bufnr)
    -- end
}
lspconfig.jsonls.setup {
    on_attach = function(client, bufnr)
        navic.attach(client, bufnr)
    end
}
lspconfig.dockerls.setup {
    on_attach = function(client, bufnr)
        navic.attach(client, bufnr)
    end
}
lspconfig.yamlls.setup {
    on_attach = function(client, bufnr)
        navic.attach(client, bufnr)
    end
}
lspconfig.clangd.setup {
    on_attach = function(client, bufnr)
        navic.attach(client, bufnr)
    end
}


vim.cmd([[
    augroup Format
        autocmd!
        autocmd BufWritePre * lua vim.lsp.buf.format()
    augroup end
]])
