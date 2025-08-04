vim.g.mapleader = " "
vim.g.maplocalleader = "\\"
vim.opt.clipboard = "unnamedplus"
vim.opt.mouse = "a"

-- Better editing experience
vim.opt.signcolumn = "yes"
vim.opt.cursorline = true
vim.opt.wrap = false
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8
vim.opt.splitbelow = true
vim.opt.splitright = true

-- Tab settings
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.smartindent = true

-- Search settings
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = false

-- Enable 24-bit colors
vim.opt.termguicolors = true
-- Add this to your init.lua after setting options
vim.opt.number = true
vim.opt.relativenumber = false  -- Disable relative numbers

-- Load plugins
require("config.lazy")

-- Set colorscheme after plugins
vim.cmd.colorscheme("catppuccin")

-- Key mappings
-- vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>", { desc = "File Explorer" })
vim.keymap.set("n", "<leader>m", require("snacks.dashboard").open, { desc = "Open Menu" })
vim.keymap.set("n", "<leader>ff", require("telescope.builtin").find_files, { desc = "Find Files" })
vim.keymap.set("n", "<leader>fg", require("telescope.builtin").live_grep, { desc = "Live Grep" })
vim.keymap.set("n", "<leader>fw", function()
  require("telescope.builtin").grep_string({
    search = vim.fn.expand("<cword>"),
    only_sort_text = true,
    search_dirs = {vim.fn.expand("%:p")}
  })
end, { desc = "Find current word in file" })

-- Search for any text in current file
vim.keymap.set("n", "<leader>fs", function()
  require("telescope.builtin").current_buffer_fuzzy_find()
end, { desc = "Fuzzy search in file" })

vim.opt.showmode = false  -- Hide -- INSERT -- since we have statusline
vim.opt.cmdheight = 1
vim.opt.pumheight = 10    -- Limit popup menu height
vim.opt.winblend = 10     -- Slight transparency for floating windows

-- Better visual cues
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
vim.api.nvim_set_hl(0, "FloatBorder", { fg = "#569CD6", bg = "none" })
vim.api.nvim_create_autocmd("BufRead", {
  pattern = "*",
  callback = function()
    -- Remove DOS line endings
    vim.cmd([[%s/\r\+$//e]])
    
    -- Detect file format and convert if needed
    if vim.bo.fileformat == "dos" then
      vim.bo.fileformat = "unix"
    end
  end,
})
vim.opt.fileformats = "unix,dos"
vim.diagnostic.config({
  signs = false,
  underline = false,
})
