require("nvim-lsp-installer").setup {
    log_level = vim.log.levels.DEBUG
}
local lspconfig = require("lspconfig")
lspconfig.sumneko_lua.setup {
    settings = {
        Lua = {
           diagnostics = {
              globals = {'vim'}
          }
        }
    }
}
lspconfig.pyright.setup {
    settings = {
        python = {
            venvPath = "/Users/jamesdelorenzo/.virtualenvs"
        }
    }
}
lspconfig.ccls.setup {
    init_options = {
        cache = {
            directory = ".ccls-cache";
        }
    }
}
lspconfig.terraformls.setup {}
lspconfig.tflint.setup {}
lspconfig.jsonls.setup {}
lspconfig.dockerls.setup {}
lspconfig.yamlls.setup {}
lspconfig.clangd.setup {}

