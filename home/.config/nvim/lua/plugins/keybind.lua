vim.opt.timeout = true
vim.opt.timeoutlen = 300
vim.g.mapleader = " "

local fzf_lua = require("fzf-lua")

local keymaps = {
    ["<leader>f"] = {
        name = "+Fuzzy",
        f = { fzf_lua.files, "Files" },
    },
    ["<leader>g"] = {
        name = "+Git",
        b = { fzf_lua.git_branches, "Git branches" },
        c = { fzf_lua.git_commits, "Git commits" },
        s = { fzf_lua.git_status, "Git status" },
    },
    ["<leader>l"] = {
        name = "+LSP",
        a = { fzf_lua.lsp_code_actions, "Code action" },
        c = { fzf_lua.lsp_document_diagnostics, "Diagnostics (file)" },
        C = { fzf_lua.lsp_workspace_diagnostics, "Diagnostics (workspace)" },
        d = { fzf_lua.lsp_definitions, "Definition" },
        f = {
            function()
                vim.lsp.buf.format({ async = true })
            end,
            "Format",
        },
        h = { vim.lsp.buf.hover, "Hints" },
        i = { fzf_lua.lsp_implementations, "Implementation" },
        n = { vim.lsp.buf.rename, "Rename" },
        r = { fzf_lua.lsp_references, "References" },
        s = { fzf_lua.lsp_document_symbols, "Symbols (file)" },
        S = { fzf_lua.lsp_workspace_symbols, "Symbols (workspace)" },
    },
}

return {
    {
        "folke/which-key.nvim",
        config = function()
            require("which-key").setup({})

            require("which-key").register(keymaps)
        end,
    },
}
