return {
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin-macchiato",
    },
  },
  { "savq/melange-nvim" },
  { "morhetz/gruvbox" },

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
