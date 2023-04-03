vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt.foldenable = false

return {
    {
        "nvim-treesitter/nvim-treesitter",
        build = function()
            require("nvim-treesitter.install").update({ with_sync = true })
        end,
        config = function()
            require("nvim-treesitter.configs").setup({
                ensure_installed = {
                    "bash",
                    "c",
                    "cmake",
                    "css",
                    "diff",
                    "dockerfile",
                    "dot",
                    "git_rebase",
                    "gitattributes",
                    "gitcommit",
                    "gitignore",
                    "go",
                    "html",
                    "javascript",
                    "jq",
                    "json",
                    "lua",
                    "make",
                    "markdown",
                    "markdown_inline",
                    "mermaid",
                    "python",
                    "regex",
                    "rust",
                    "scss",
                    "toml",
                    "yaml",
                    "yuck",
                },
                highlight = {
                    enable = true,
                },
                indent = {
                    enable = true,
                },
            })
        end,
    },
    {
        "HiPhish/nvim-ts-rainbow2",
        config = function()
            require("nvim-treesitter.configs").setup({
                rainbow = {
                    enable = true,
                    query = "rainbow-parens",
                    strategy = require("ts-rainbow").strategy.global,
                    hlgroups = {
                        --"TSRainbowRed",
                        "TSRainbowYellow",
                        "TSRainbowBlue",
                        --"TSRainbowOrange",
                        "TSRainbowGreen",
                        "TSRainbowViolet",
                        "TSRainbowCyan",
                    },
                },
            })
        end,
    },
    {
        "numToStr/Comment.nvim",
        opts = true,
    },
    {
        "windwp/nvim-autopairs",
        opts = true,
    },
}
