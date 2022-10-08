vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerCompile
  augroup end
]])

local ensure_packer = function()
    local fn = vim.fn
    local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
    if fn.empty(fn.glob(install_path)) > 0 then
        fn.system({ "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path })
        vim.cmd([[packadd packer.nvim]])
        return true
    end
    return false
end

local packer_bootstrap = ensure_packer()

return require("packer").startup(function(use)
    use("wbthomason/packer.nvim")
    -- Nord colorscheme
    use("arcticicestudio/nord-vim")
    -- LSP
    use({ "williamboman/mason.nvim", "neovim/nvim-lspconfig", "williamboman/mason-lspconfig.nvim" })
    -- debug
    use({ "nvim-lua/plenary.nvim", "mfussenegger/nvim-dap" })
    -- completion
    use({
        "hrsh7th/nvim-cmp",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-cmdline",
        "saadparwaiz1/cmp_luasnip",
    })
    -- rust
    use({"simrat39/rust-tools.nvim", 'rust-lang/rust.vim'})
    -- snippet
    use({ "L3MON4D3/LuaSnip", tag = "v<CurrentMajor>.*" })
    -- Automatically set up your configuration after cloning packer.nvim
    -- Put this at the end after all plugins
    if packer_bootstrap then
        require("packer").sync()
    end
end)
