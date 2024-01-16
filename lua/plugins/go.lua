return {
  "ray-x/go.nvim",
  dependencies = {  -- optional packages
    "ray-x/guihua.lua",
    "neovim/nvim-lspconfig",
    "nvim-treesitter/nvim-treesitter",
    "mfussenegger/nvim-dap",
    "mfussenegger/nvim-dap-ui",
    "theHamsta/nvim-dap-virtual-text",
    "hrsh7th/vim-vsnip",
    "hrsh7th/vim-vsnip-integ",
  },
  config = function()
    require("go").setup()
  end,
  event = {"CmdlineEnter"},
  ft = {"go", 'gomod'},
  build = ':lua require("go.install").update_all_sync()' -- if you need to install/update all binaries
}

