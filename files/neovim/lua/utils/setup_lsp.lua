local M = {
    lsp_install = {},
    treesitter_install = {},
    null_ls_sources = {},

    add_null_ls_sources = function(self, source)
        table.insert(self.null_ls_sources, source)
    end,

    add_lsp_list = function(self, name)
        table.insert(self.lsp_install, name)
    end,

    add_treesitter = function(self, name)
        table.insert(self.treesitter_install, name)
    end,
}

return M
