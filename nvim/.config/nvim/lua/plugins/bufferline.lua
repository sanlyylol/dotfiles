return {
  'akinsho/bufferline.nvim',
  version = "*",
  dependencies = {
    'nvim-tree/nvim-web-devicons',
    'catppuccin/nvim', -- Ensure Catppuccin is loaded first
  },
  config = function()
    
    -- Apply customized bufferline highlights
    require("bufferline").setup({
      highlights = require("catppuccin.groups.integrations.bufferline").get({
        styles = { "italic", "bold" },
        custom = {
          all = {
            fill = { bg = "#000000" }, -- Example customization
          },
          mocha = {
            background = { fg = "#E8E2D6" }, -- Example mocha color
          },
          latte = {
            background = { fg = "#000000" }, -- Example latte color
          },
        },
      }),
      -- ... other bufferline options ...
    })
  end
}
