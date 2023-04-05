return {
    {
        "L3MON4D3/LuaSnip",
    },
    {
        "hrsh7th/nvim-cmp",
        event = { "InsertEnter", "CmdLineEnter" },
        dependencies = {
            "hrsh7th/cmp-buffer",
            "FelipeLema/cmp-async-path",
            "hrsh7th/cmp-cmdline",
            -- for LuaSnip
            "L3MON4D3/LuaSnip",
            "saadparwaiz1/cmp_luasnip",
            -- for lsp
            "hrsh7th/cmp-nvim-lsp",
        },
        config = function()
            local cmp = require("cmp")
            cmp.setup({
                preselect = cmp.PreselectMode.None,
                snippet = {
                    expand = function(args)
                        require("luasnip").lsp_expand(args.body)
                    end,
                },
                mapping = {
                    ["<Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
                        else
                            fallback()
                        end
                    end),
                    ["<CR>"] = cmp.mapping(function(fallback)
                        if cmp.visible() and cmp.get_selected_entry() then
                            cmp.confirm()
                        else
                            fallback()
                        end
                    end),
                    ["<Down>"] = cmp.mapping(function(fallback)
                        if cmp.visible() and cmp.get_selected_entry() then
                            cmp.select_next_item()
                        else
                            fallback()
                        end
                    end),
                    ["<Up>"] = cmp.mapping(function(fallback)
                        if cmp.visible() and cmp.get_selected_entry() then
                            cmp.select_prev_item()
                        else
                            fallback()
                        end
                    end),
                },
                sources = cmp.config.sources({
                    { name = "buffer" },
                    { name = "async_path" },
                    { name = "luasnip" },
                    { name = "nvim_lsp" },
                }, {
                    { name = "buffer" },
                }),
            })
            cmp.setup.cmdline("/", {
                mapping = cmp.mapping.preset.cmdline(),
                sources = { { name = "buffer" } },
            })
            cmp.setup.cmdline(":", {
                mapping = cmp.mapping.preset.cmdline(),
                sources = cmp.config.sources({
                    { name = "path" },
                }, {
                    {
                        name = "cmdline",
                        option = {
                            ignore_cmds = { "Man", "!" },
                        },
                    },
                }),
            })
        end,
    },
}
