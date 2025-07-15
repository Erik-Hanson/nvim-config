return {
  {
    "akinsho/bufferline.nvim",
    event = "VeryLazy", -- or "BufEnter" 
    dependencies = "nvim-tree/nvim-web-devicons",
    config = function()
      require("bufferline").setup({
        -- Your bufferline configuration here
      })
    end,
  },
}
