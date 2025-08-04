return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      {
        "mason-org/mason.nvim",
        opts = {
          ui = { icons = { installed = "✓", pending = "➜", uninstalled = "✗" } },
        },
      },
      {
        "mason-org/mason-lspconfig.nvim",
        opts = {
          ensure_installed = { "lua_ls" },
          automatic_enable = true,
        },
        dependencies = { "mason-org/mason.nvim", "neovim/nvim-lspconfig" },
      },
      { "folke/neodev.nvim", opts = {} },
      "hrsh7th/cmp-nvim-lsp",
    },

    config = function()
      require("mason").setup()

      local capabilities =
        require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())

      require("neodev").setup()

      require("mason-lspconfig").setup()

      vim.lsp.config("*", {
        capabilities = capabilities,
        on_attach = function(client, bufnr)
          local opts = { buffer = bufnr, silent = true }
          local map = vim.keymap.set
          map("n", "K", vim.lsp.buf.hover, opts)
          map("n", "gd", vim.lsp.buf.definition, opts)
          map("n", "gD", vim.lsp.buf.declaration, opts)
          map("n", "gi", vim.lsp.buf.implementation, opts)
          map("n", "go", vim.lsp.buf.type_definition, opts)
          map("n", "gr", vim.lsp.buf.references, opts)
          map("n", "<F2>", vim.lsp.buf.rename, opts)
          map({ "n", "x" }, "<F4>", vim.lsp.buf.code_action, opts)
          map("n", "gl", vim.diagnostic.open_float, opts)
          map("n", "[d", vim.diagnostic.goto_prev, opts)
          map("n", "]d", vim.diagnostic.goto_next, opts)
        end,
      })

      vim.lsp.config("lua_ls", {
        settings = {
          Lua = {
            runtime = {
              version = "LuaJIT",
              path = vim.split(package.path, ";"),
            },
            diagnostics = {
              globals = { "vim" },
            },
            hint = { enable = true, paramType = true, setType = true },
            completion = { callSnippet = "Replace" },
            semantic = { enable = true },
            type = { weakUnionCheck = true },
          },
        },
      })

      require("cmp").event:on("confirm_done",
        require("nvim-autopairs.completion.cmp").on_confirm_done())
    end,
  },
}
