local config = require("utils.setup_lsp")

config:add_treesitter("bash")

config:add_lsp_list("bashls")
require("lspconfig").bashls.setup({})

config:add_lsp_list("shellcheck")
config:add_null_ls_sources(require("null-ls").builtins.code_actions.shellcheck)
