return {
<<<<<<< Updated upstream
  -- "akinsho/toggleterm.nvim",
  -- config = function()
  --   require("toggleterm").setup({
  --     size = 20,
  --     open_mapping = [[<c-\>]],
  --     hide_numbers = true,
  --     shade_filetypes = {},
  --     shade_terminals = true,
  --     shading_factor = 2,
  --     start_in_insert = true,
  --     insert_mappings = true,
  --     terminal_mappings = true,
  --     persist_size = true,
  --     direction = "horizontal",
  --     close_on_exit = true,
  --     shell = vim.o.shell,
  --     float_opts = {
  --       border = "curved",
  --       winblend = 0,
  --       highlights = {
  --         border = "Normal",
  --         background = "Normal",
  --       },
  --     },
  --   })
  --   -- Custom function to toggle terminal in vertical split
  --   function _G.toggle_vertical_term()
  --     require("toggleterm").toggle(1, nil, nil, "vertical")
  --   end
  --
  --   -- Set the key mapping to call the custom function
  --   vim.api.nvim_set_keymap("n", "<c->", ":lua toggle_vertical_term()<CR>", { noremap = true, silent = true })
  -- end,
=======
  "akinsho/toggleterm.nvim",
  config = function()
    require("toggleterm").setup({
      size = 20,
      open_mapping = [[<c-\>]],
      hide_numbers = true,
      shade_filetypes = {},
      shade_terminals = true,
      shading_factor = 2,
      start_in_insert = true,
      insert_mappings = true,
      terminal_mappings = true,
      persist_size = true,
      direction = "horizontal",
      close_on_exit = true,
      shell = vim.o.shell,
      float_opts = {
        border = "curved",
        winblend = 0,
        highlights = {
          border = "Normal",
          background = "Normal",
        },
      },
    })
  end,
>>>>>>> Stashed changes
}
