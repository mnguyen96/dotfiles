return {
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin",
    },
  },
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
