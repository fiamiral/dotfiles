-- Lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "--single-branch",
        "https://github.com/folke/lazy.nvim.git",
        lazypath,
    })
end
vim.opt.runtimepath:prepend(lazypath)

-- Plugins
vim.g.mapleader = " "
require("lazy").setup({
    -- colorscheme
    "shaunsingh/nord.nvim",
    -- tree-sitter
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        event = { "BufReadPost" },
        config = function()
            require("nvim-treesitter.configs").setup({
                ensure_installed = {
                    "bash",
                    "diff",
                    "dockerfile",
                    "javascript",
                    "lua",
                    "markdown",
                    "markdown_inline",
                    "regex",
                    "rust",
                    "toml",
                },
                highlight = {
                    enable = true,
                },
            })
        end,
    },
    -- LSP
    {
        "williamboman/mason-lspconfig.nvim",
        dependencies = {
            "williamboman/mason.nvim",
            "neovim/nvim-lspconfig",
            "lvimuser/lsp-inlayhints.nvim",
        },
        config = function()
            require("mason").setup()
            require("lsp-inlayhints").setup({
                inlay_hints = {
                    highlight = "Comment",
                },
            })

            -- install packages
            local install_list = { "stylua", "shellcheck" }
            local mason_registry = require("mason-registry")
            for _, tool in ipairs(install_list) do
                local package = mason_registry.get_package(tool)
                if not package:is_installed() then
                    package:install()
                end
            end

            require("mason-lspconfig").setup({
                ensure_installed = {
                    "bashls", --bash
                    "dockerls", --dockerfile
                    "sumneko_lua", -- lua
                    "rust_analyzer", --rust
                    "taplo", --toml
                },
            })
            require("mason-lspconfig").setup_handlers({
                function(server_name)
                    local options = {
                        on_attach = function(client, bufnr)
                            -- format on save
                            vim.api.nvim_create_autocmd("BufWritePre", {
                                callback = function()
                                    vim.lsp.buf.format()
                                    require("lsp-inlayhints").on_attach(client, bufnr)
                                end,
                            })
                        end,
                        -- completion
                        capabilities = require("cmp_nvim_lsp").default_capabilities(),
                    }
                    if server_name == "sumneko_lua" then
                        options.settings = {
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
                        }
                    end
                    require("lspconfig")[server_name].setup(options)
                end,
            })
        end,
    },
    {
        "j-hui/fidget.nvim",
        config = {
            window = {
                blend = 0,
            },
        },
    },
    {
        "jose-elias-alvarez/null-ls.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
        config = function()
            local null_ls = require("null-ls")
            null_ls.setup({
                sources = {
                    require("null-ls").builtins.code_actions.shellcheck,
                    require("null-ls").builtins.formatting.stylua.with({
                        extra_args = { "--indent-type=Spaces" },
                    }),
                },
            })
        end,
    },
    {
        url = "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
        config = true,
    },

    -- completion
    {
        "hrsh7th/nvim-cmp",
        event = { "InsertEnter", "CmdLineEnter" },
        dependencies = {
            "hrsh7th/cmp-nvim-lsp", -- LSP source
            "hrsh7th/cmp-path", -- path source
            "hrsh7th/cmp-cmdline", -- cmdline(:) source
            "L3MON4D3/LuaSnip", -- Snippet
            "saadparwaiz1/cmp_luasnip", -- Snippet source
        },
        config = function()
            local cmp = require("cmp")

            cmp.setup({
                snippet = {
                    expand = function(args)
                        require("luasnip").lsp_expand(args.body)
                    end,
                },
                mapping = cmp.mapping.preset.insert({
                    ["<C-e>"] = cmp.mapping.abort(),
                    ["<CR>"] = cmp.mapping.confirm({ select = true }),
                }),
                sources = cmp.config.sources({
                    { name = "nvim_lsp" },
                    { name = "luasnip" },
                }, {
                    { name = "buffer" },
                }),
            })

            cmp.setup.cmdline(":", {
                mapping = cmp.mapping.preset.cmdline(),
                sources = cmp.config.sources({
                    { name = "path" },
                }, {
                    { name = "cmdline" },
                }),
            })
        end,
    },

    -- statusline
    {
        "nvim-lualine/lualine.nvim",
        event = { "VeryLazy" },
        config = {
            options = {
                theme = "nord",
                component_separators = { left = "", right = "" },
                section_separators = { left = "", right = "" },
            },
            sections = {
                lualine_a = { "mode" },
                lualine_b = { "branch", "diff", "diagnostics" },
                lualine_c = { "filename" },
                lualine_x = { "encoding", "fileformat", "filetype" },
                lualine_y = { "progress" },
                lualine_z = { "location" },
            },
        },
    },

    -- other
    {
        "windwp/nvim-autopairs",
        config = function()
            require("nvim-autopairs").setup({})
            -- If you want insert `(` after select function or method item
            local cmp_autopairs = require("nvim-autopairs.completion.cmp")
            local cmp = require("cmp")
            cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
        end,
    },
    {
        "folke/which-key.nvim",
        event = { "VeryLazy" },
        config = true,
    },
    {
        "sidebar-nvim/sidebar.nvim",
        config = function()
            require("sidebar-nvim").setup({
                sections = { "git", "diagnostics" },
            })
            require("which-key").register({
                b = { '<cmd>lua require("sidebar-nvim").toggle()<CR>', "toggle sidebar" },
            }, { prefix = "<leader>" })
        end,
    },
})

-- vim options
-- linum
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true
-- tab
vim.opt.shiftwidth = 0
vim.opt.tabstop = 4
vim.opt.expandtab = true
-- indent
vim.opt.smartindent = true

-- keybind
vim.keymap.set("i", "jk", "<ESC>")

-- folding
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt.foldenable = false

-- colorscheme
vim.opt.termguicolors = true
vim.g.nord_disable_background = true
vim.cmd.colorscheme("nord")

-- autosave
vim.api.nvim_create_autocmd("FocusLost", {
    pattern = "*",
    command = "wa",
})
