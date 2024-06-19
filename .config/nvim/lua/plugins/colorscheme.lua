return {
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin",
    },
  },
  -- {
  --   "LazyVim/LazyVim",
  --   opts = {
  --     colorscheme = "nightfox",
  --   },
  -- },
  { "EdenEast/nightfox.nvim" },
  {
    "navarasu/onedark.nvim",
    opts = {
      style = "deep",
    },
    config = function(_, opts)
      vim.opt.background = "dark"
      require("onedark").setup(opts)
    end,
  },
}
