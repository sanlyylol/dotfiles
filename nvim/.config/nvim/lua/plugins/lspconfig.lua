-- lua/plugins/lsp.lua
return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      -- Mason core
      {
        "mason-org/mason.nvim",
        opts = {
          ui = { icons = { installed = "✓", pending = "➜", uninstalled = "✗" } },
        },
      },
      -- Mason-LSPConfig bridge
      {
        "mason-org/mason-lspconfig.nvim",
        opts = {
          ensure_installed = { "lua_ls" },
          automatic_enable = true,
        },
        dependencies = { "mason-org/mason.nvim", "neovim/nvim-lspconfig" },
      },
      -- neodev auto-configuration for lua_ls
      { "folke/neodev.nvim", opts = {} },
      -- cmp-Nvim-LSP for signature/completion cap injection
      "hrsh7th/cmp-nvim-lsp",
    },

    config = function()
      -- Setup Mason (ensure it runs early to adjust PATH)
      require("mason").setup()

      -- Enable cmp capabilities
      local capabilities =
        require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())

      -- Let neodev do its overrides for lua_ls (runtime path, library, globals, etc.)
      require("neodev").setup()

      -- Tell Mason-LSPConfig to install and auto‑enable servers
      require("mason-lspconfig").setup()

      -- Configure all servers generically (use wildcard for clustering if desired)
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

      -- Specific lua_ls configuration (merges defaults from neodev)
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

      -- Auto‑pair integration with cmp
      require("cmp").event:on("confirm_done",
        require("nvim-autopairs.completion.cmp").on_confirm_done())
    end,
  },
}
