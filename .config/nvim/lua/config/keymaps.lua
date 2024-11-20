-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Bind a key to open Telescope diagnostics picker
vim.api.nvim_set_keymap("n", "<leader>td", "<cmd>Telescope diagnostics<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap(
  "n",
  "<leader>sf",
  "<cmd>Telescope current_buffer_fuzzy_find<CR>",
  { desc = "Grep (Buffer)", noremap = true, silent = true }
)
vim.keymap.set("i", "jj", "<ESC>", { silent = true })
vim.keymap.set("i", "jk", "<ESC>", { silent = true })
vim.keymap.set("i", "kj", "<ESC>", { silent = true })
vim.keymap.set("i", "kk", "<ESC>", { silent = true })
