local lsp_installer = require("nvim-lsp-installer")
local cmp_lsp = require('cmp_nvim_lsp')
-- Register a handler that will be called for all installed servers.
-- Alternatively, you may also register handlers on specific server instances instead (see example below).
lsp_installer.on_server_ready(function(server)
    -- Setup lspconfig.
    local capabilities = cmp_lsp.update_capabilities(vim.lsp.protocol.make_client_capabilities())
    local opts = {}

    -- (optional) Customize the options passed to the server
    -- if server.name == "tsserver" then
    --     opts.root_dir = function() ... end
    -- end
    if server.name == "sumneko_lua" then
        opts = {
            settings = {
                Lua = {
                   diagnostics = {
                      globals = {'vim'}
                  }
                }
            }
        }
    end
    if server.name == "pyright" then
        opts = {
            settings = {
                python = {
                    venvPath = "/Users/jamesdelorenzo/.virtualenvs"
                }
            }
        }
    end
    if server.name == "ccls" then
        opts = {
            init_options = {
                cache = {
                    directory = ".ccls-cache";
                }
             }
         }
    end

    -- This setup() function is exactly the same as lspconfig's setup function.
    -- Refer to https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
-- Replace <YOUR_LSP_SERVER> with each lsp server you've enabled.
    opts['capabilities']  = capabilities

    server:setup(opts)
end)
