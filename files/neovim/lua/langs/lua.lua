local config = require("utils.setup_lsp")

config:add_treesitter("lua")

config:add_lsp_list("sumneko_lua")
require("lspconfig").sumneko_lua.setup({
    settings = {
        Lua = {
            runtime = {
                -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
                version = "LuaJIT",
            },
            diagnostics = {
                -- Get the language server to recognize the `vim` global
                globals = { "vim" },
            },
            workspace = {
                -- Make the server aware of Neovim runtime files
                library = vim.api.nvim_get_runtime_file("", true),
            },
            -- Do not send telemetry data containing a randomized but unique identifier
            telemetry = {
                enable = false,
            },
        },
    },
})

config:add_lsp_list("stylua")
config:add_null_ls_sources(
    require("null-ls").builtins.formatting.stylua.with({
        extra_args = { "--indent-type=Spaces" },
    })
)