return {
  "mason-org/mason-lspconfig.nvim",
  opts = {
    ensure_installed = { ... },
    automatic_enable = true,
  },
  dependencies = {
    { "mason-org/mason.nvim", opts = {} },
    "neovim/nvim-lspconfig",
  },
}
