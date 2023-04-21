return {
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
        },
        config = function()
            local capabilities = require("cmp_nvim_lsp").default_capabilities()
            require("mason").setup()
            require("mason-lspconfig").setup({
                ensure_installed = {
                    "bashls",
                    "dockerls",
                    "docker_compose_language_service",
                    "taplo",
                    "lua_ls",
                    "rust_analyzer",
                    "yamlls",
                },
            })

            local on_attach = function(_, _)
                -- format on save
                vim.api.nvim_create_autocmd("BufWritePre", {
                    callback = function()
                        vim.lsp.buf.format()
                    end,
                })
            end

            require("mason-lspconfig").setup_handlers({
                function(server_name)
                    require("lspconfig")[server_name].setup({
                        capabilities = capabilities,
                        on_attach = on_attach,
                    })
                end,
                ["lua_ls"] = function(_)
                    require("lspconfig").lua_ls.setup({
                        capabilities = capabilities,
                        on_attach = on_attach,
                        settings = {
                            Lua = {
                                runtime = {
                                    version = "LuaJIT",
                                },
                                diagnostics = {
                                    globals = { "vim" },
                                },
                                workspace = {
                                    library = vim.api.nvim_get_runtime_file("", true),
                                },
                                telemetry = {
                                    enable = false,
                                },
                            },
                        },
                    })
                end,
                ["yamlls"] = function(_)
                    require("lspconfig").yamlls.setup({
                        capabilities = capabilities,
                        settings = {
                            yaml = {
                                schemas = {
                                    ["https://raw.githubusercontent.com/instrumenta/kubernetes-json-schema/master/v1.18.0-standalone-strict/all.json"] = "/*.k8s.yaml",
                                },
                            },
                        },
                    })
                end,
            })
        end,
    },
    {
        "jose-elias-alvarez/null-ls.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "neovim/nvim-lspconfig",
        },
        config = function()
            -- install packages
            local install_list = { "stylua", "shellcheck" }
            local mason_registry = require("mason-registry")
            for _, tool in ipairs(install_list) do
                local package = mason_registry.get_package(tool)
                if not package:is_installed() then
                    package:install()
                end
            end

            local null_ls = require("null-ls")
            null_ls.setup({
                sources = {
                    null_ls.builtins.code_actions.gitsigns,
                    null_ls.builtins.code_actions.shellcheck,
                    null_ls.builtins.formatting.stylua.with({
                        extra_args = { "--indent-type=Spaces" },
                    }),
                },
            })
        end,
    },
}
