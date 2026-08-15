return {
	"neovim/nvim-lspconfig",
	dependencies = {
		"mason-org/mason.nvim",
		"mason-org/mason-lspconfig.nvim",
		"folke/neodev.nvim",
		"hrsh7th/cmp-nvim-lsp",
	},
	config = function()
		require("mason").setup()
		require("neodev").setup()
		vim.diagnostic.config({
			virtual_text = {
				prefix = "●",
				spacing = 4,
			},
			signs = true,
			underline = true,
			update_in_insert = false,
			severity_sort = true,
			float = {
				source = "always",
				border = "rounded",
			},
		})

		local capabilities = require("cmp_nvim_lsp").default_capabilities()

		-- Global defaults
		vim.lsp.config("*", {
			capabilities = capabilities,
			on_attach = function(client, bufnr)
				local opts = { buffer = bufnr, silent = true }
				vim.keymap.set("n", "gl", vim.diagnostic.open_float, { desc = "Show diagnostics" })
				vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Previous diagnostic" })
				vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })
				vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
				vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
				vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
			end,
		})

		-- Server-specific configs
		vim.lsp.config("lua_ls", {
			on_init = function(client)
				if client.workspace_folders then
					local path = client.workspace_folders[1].name
					if
						path ~= vim.fn.stdpath("config")
						and (vim.uv.fs_stat(path .. "/.luarc.json") or vim.uv.fs_stat(path .. "/.luarc.jsonc"))
					then
						return
					end
				end

				client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua, {
					runtime = {
						-- Tell the language server which version of Lua you're using (most
						-- likely LuaJIT in the case of Neovim)
						version = "LuaJIT",
						-- Tell the language server how to find Lua modules same way as Neovim
						-- (see `:h lua-module-load`)
						path = {
							"lua/?.lua",
							"lua/?/init.lua",
						},
					},
					-- Make the server aware of Neovim runtime files
					workspace = {
						checkThirdParty = false,
						library = {
							vim.env.VIMRUNTIME,
							-- For LSP Settings Type Annotations: https://github.com/neovim/nvim-lspconfig#lsp-settings-type-annotations
							vim.api.nvim_get_runtime_file("lua/lspconfig", false)[1],
						},
						-- Or pull in all of 'runtimepath'.
						-- NOTE: this is a lot slower and will cause issues when working on
						-- your own configuration.
						-- See https://github.com/neovim/nvim-lspconfig/issues/3189
						-- library = vim.api.nvim_get_runtime_file('', true),
					},
				})
			end,
			settings = {
				Lua = {},
			},
		})

		vim.lsp.config("basedpyright", {
			settings = {
				python = { analysis = { typeCheckingMode = "basic" } },
			},
		})

		vim.lsp.config("clangd", {
			cmd = { "clangd", "--background-index", "--clang-tidy", "--header-insertion=never" },
		})

		-- Enable the servers (this is the important missing part)
		vim.lsp.enable({
			"lua_ls",
			"basedpyright",
			"clangd",
			"ts_ls",
			"html",
			"cssls",
			"jsonls",
			"yamlls",
		})
	end,
}
