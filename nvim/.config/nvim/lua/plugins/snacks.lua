return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  ---@type snacks.Config
  opts = {
    -- enable all snacks (including image)
    bigfile       = { enabled = true },
    explorer      = { enabled = true },
    indent        = { enabled = true },
    input         = { enabled = true },
    picker        = { enabled = true },
    notifier      = { enabled = true },
    quickfile     = { enabled = true },
    scope         = { enabled = true },
    scroll        = { enabled = true },
    statuscolumn  = { enabled = true },
    words         = { enabled = true },
    image         = {
      enabled = true,
      inline = false,
      float = true,
    },
    dashboard = {
      enabled = true,
      config = function(opts, defaults)
        opts.preset = opts.preset or {}

        -- Copy default buttons
        local keys = vim.deepcopy(defaults.preset.keys or {})

        -- Insert your "NoitaCode" entry just before "quit" (typically last entry)
        table.insert(keys, #keys, {
          desc  = "NoitaCode folder",
          icon  = "★",  -- Unicode black star
          key   = "D",
          action = function()
            -- Open Snacks.explorer rooted at your data directory
            Snacks.explorer({ cwd = vim.fn.expand "~/NoitaCode/data" })
          end,
        })
 
        opts.preset.keys = keys

        -- Do *not* modify opts.preset.header; leaving it nil uses the default banner
      end,
    },
  },
}
--[[
  opts = {
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
    bigfile = { enabled = true },
    dashboard = { enabled = true },
    explorer = { enabled = true },
    indent = { enabled = true },
    input = { enabled = true },
    picker = { enabled = true },
    notifier = { enabled = true },
    quickfile = { enabled = true },
    scope = { enabled = true },
    scroll = { enabled = true },
    statuscolumn = { enabled = true },
    words = { enabled = true },
    image = {
      enabled = true,
      inline = false,
      float = true,
    },
  
  },
}
--]]
