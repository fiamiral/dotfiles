vim.opt.termguicolors = true

return {
    {
        "gbprod/nord.nvim",
        config = function()
            require("nord").setup({
                transparent = true,
            })

            vim.cmd.colorscheme("nord")
            local c = require("nord.colors").palette

            -- nvim-ts-rainbow
            require("nord.utils").load({
                TSRainbowRed = { fg = c.aurora.red },
                TSRainbowYellow = { fg = c.aurora.yellow },
                TSRainbowBlue = { fg = c.frost.artic_ocean },
                TSRainbowOrange = { fg = c.aurora.orange },
                TSRainbowGreen = { fg = c.aurora.green },
                TSRainbowViolet = { fg = c.aurora.purple },
                TSRainbowCyan = { fg = c.frost.ice },
            }, {})
        end,
    },
}
