require("langs.lua")
require("langs.rust")

local config = require("utils.setup_lsp")

-- mason
require("mason").setup()
require("mason-lspconfig").setup({
    ensure_installed = config.lsp_install,
})

-- treesitter
require("nvim-treesitter.configs").setup({
    ensure_installed = config.treesitter_install,
})

-- fidget
-- null-ls
require("null-ls").setup({
    sources = config.null_ls_sources,
})

require("which-key").register({
    l = {
        name = "lsp",
        v = { "<cmd>Lspsaga code_action<CR>", "code action" },
        r = { "<cmd>Lspsaga rename<CR>", "rename" },
        d = { "<cmd>Lspsaga show_line_diagnostics<CR>", "line diagnostics" },
        f = { "<cmd>lua vim.lsp.buf.format()<CR>", "format" },
    },
}, { prefix = "<leader>" })

-- format on save
vim.api.nvim_create_autocmd("BufWritePre", {
    callback = function()
        vim.lsp.buf.format()
    end,
})
