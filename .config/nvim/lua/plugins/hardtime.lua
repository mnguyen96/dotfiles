-- return {
--   "m4xshen/hardtime.nvim",
--   dependencies = { "MunifTanjim/nui.nvim", "nvim-lua/plenary.nvim" },
--   opts = {
--     enabled = false,
--   },
--   command = "Hardtime",
--   event = "BufEnter",
--   keys = {
--     { "n", "j", "<cmd>Hardtime<CR>", desc = "Hardtime" },
--     { "n", "k", "<cmd>Hardtime<CR>", desc = "Hardtime" },
--     -- { "j", 'v:count || mode(1)[0:1] == "no" ? "j" : "gj"' },
--     -- { "k", 'v:count || mode(1)[0:1] == "no" ? "k" : "gk"' },
--     { "n", "gj", "<cmd>Hardtime<CR>", desc = "Hardtime" },
--     { "n", "gk", "<cmd>Hardtime<CR>", desc = "Hardtime" },
--     { "n", "n", false },
--   },
-- }
return {
  "m4xshen/hardtime.nvim",
  lazy = false,
  dependencies = { "MunifTanjim/nui.nvim" },
  opts = {},
}
