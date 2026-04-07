return {
	"neovim/nvim-lspconfig",
	dependencies = {
		{ "nvimtools/none-ls.nvim", lazy = false },
		"nvimtools/none-ls-extras.nvim",
		"mason-org/mason.nvim",
		"mason-org/mason-lspconfig.nvim",
		"folke/neodev.nvim",
		"hrsh7th/cmp-nvim-lsp",
		"zeioth/none-ls-external-sources.nvim",
		"zeioth/none-ls-autoload.nvim",
	},

	config = function()
		-- Setup Mason (ensure it runs early to adjust PATH)
		require("mason").setup({
			ensure_installed = {
				-- Formatters
				"stylua", -- Lua
				"clang-format", -- C/C++
				"black", -- Python
				"xmlformatter", -- XML
				"prettierd", -- JS/HTML/CSS/XML
				"latexindent", -- XML

				-- Linters
				"jq", -- JSON
				"cpplint", -- C/C++
				"shellcheck",
				"luacheck", -- Lua
				"flake8", -- Python
				"eslint_d", -- JavaScript

				-- Debuggers
				"codelldb", -- C/C++ debugging
			},
			ui = { icons = { installed = "✓", pending = "➜", uninstalled = "✗" } },
		})

		-- Enable cmp capabilities
		local capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())

		-- Let neodev do its overrides for lua_ls (runtime path, library, globals, etc.)
		require("neodev").setup()

		-- Tell Mason-LSPConfig to install and auto‑enable servers
		require("mason-lspconfig").setup({
			ensure_installed = {
				"lua_ls",
				"clangd",
				"pyright",
				"ts_ls",
				"lemminx",
				"html",
				"cssls",
				"jsonls",
				"yamlls",
			},
			automatic_enable = true,
			dependencies = { "mason-org/mason.nvim", "neovim/nvim-lspconfig" },
		})

		local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

		local ok, null_ls = pcall(require, "null-ls")
		if not ok then
			vim.notify("null-ls (none-ls.nvim) not found - skipping null-ls setup", vim.log.levels.WARN)
			return
		end

		-- Helper: append one or many sources to `sources`
		local function add_sources(dst, s)
			if not s then
				return
			end
			if type(s) == "table" then
				if #s > 0 then
					-- list-like table
					vim.list_extend(dst, s)
				else
					-- single source table
					table.insert(dst, s)
				end
			else
				-- unexpected type (guard)
				vim.notify(("null-ls: unexpected source type %s"):format(type(s)), vim.log.levels.WARN)
			end
		end

		-- Core builtins you want to always include
		local sources = {
			-- formatting / diagnostics / code_actions from core null-ls
			null_ls.builtins.formatting.clang_format,
			null_ls.builtins.formatting.black,
			null_ls.builtins.formatting.prettierd,
			null_ls.builtins.formatting.stylua,
			-- (don't attempt to require builtins that don't exist)
		}

		-- List the external modules (match whatever your external-sources plugin exposes)
		local external_modules = {
			-- diagnostics (linters)
			"none-ls-external-sources.diagnostics.flake8",
			"none-ls-external-sources.diagnostics.eslint_d",
			"none-ls-external-sources.diagnostics.luacheck",
			"none-ls-external-sources.diagnostics.cpplint", -- optional duplicate ok; will be added twice if returned again

			-- formatting
			"none-ls-external-sources.formatting.jq",
			"none-ls-external-sources.formatting.latexindent",

			-- code actions
			"none-ls-external-sources.code_actions.shellcheck",
		}

		-- Try to require each external module and add the returned sources intelligently
		for _, modname in ipairs(external_modules) do
			local ok_mod, mod_or_err = pcall(require, modname)
			if not ok_mod then
				-- module not found / errored
				vim.notify(("Could not require %s: %s"):format(modname, tostring(mod_or_err)), vim.log.levels.DEBUG)
			else
				local mod = mod_or_err
				local added = nil
				if type(mod) == "function" then
					-- some modules export a constructor that expects null-ls or returns a source/list
					local ok_call, res = pcall(mod, null_ls)
					if ok_call then
						add_sources(sources, res)
						added = true
					else
						vim.notify(
							("Error calling constructor from %s: %s"):format(modname, tostring(res)),
							vim.log.levels.WARN
						)
					end
				elseif type(mod) == "table" then
					-- either a single source table or a list of sources
					add_sources(sources, mod)
					added = true
				else
					vim.notify(
						("Module %s returned unsupported type %s"):format(modname, type(mod)),
						vim.log.levels.WARN
					)
				end

				if added then
					vim.notify(("Loaded null-ls external sources from %s"):format(modname), vim.log.levels.DEBUG)
				end
			end
		end

		-- Setup null-ls with the assembled sources
		null_ls.setup({
			-- NOTE: 'dependencies' is not a null-ls setup option; if you use lazy.nvim ensure plugin deps in your plugin spec.
			debug = false,
			sources = sources,
			on_attach = function(client, bufnr)
				if client.supports_method("textDocument/formatting") then
					vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
					vim.api.nvim_create_autocmd("BufWritePre", {
						group = augroup,
						buffer = bufnr,
						callback = function()
							vim.lsp.buf.format({
								bufnr = bufnr,
								filter = function(c)
									return c.name == "null-ls"
								end,
							})
						end,
					})
				end
			end,
		})

		-- Configure all servers generically (use wildcard for clustering if desired)
		vim.lsp.config("*", {
			capabilities = capabilities,
			on_attach = function(client, bufnr)
				local opts_base = { buffer = bufnr, silent = true }
				local map = vim.keymap.set

				map(
					"n",
					"<leader>cf",
					vim.lsp.buf.format,
					vim.tbl_extend("force", opts_base, { desc = "LSP: Format buffer" })
				)
				map(
					"n",
					"K",
					vim.lsp.buf.hover,
					vim.tbl_extend("force", opts_base, { desc = "LSP: Hover (show docs)" })
				)
				map(
					"n",
					"gd",
					vim.lsp.buf.definition,
					vim.tbl_extend("force", opts_base, { desc = "LSP: Go to definition" })
				)
				map(
					"n",
					"gD",
					vim.lsp.buf.declaration,
					vim.tbl_extend("force", opts_base, { desc = "LSP: Go to declaration" })
				)
				map(
					"n",
					"gi",
					vim.lsp.buf.implementation,
					vim.tbl_extend("force", opts_base, { desc = "LSP: Go to implementation" })
				)
				map(
					"n",
					"go",
					vim.lsp.buf.type_definition,
					vim.tbl_extend("force", opts_base, { desc = "LSP: Go to type definition" })
				)
				map(
					"n",
					"gr",
					vim.lsp.buf.references,
					vim.tbl_extend("force", opts_base, { desc = "LSP: Show references" })
				)
				map(
					"n",
					"<F2>",
					vim.lsp.buf.rename,
					vim.tbl_extend("force", opts_base, { desc = "LSP: Rename symbol" })
				)
				map(
					{ "n", "x" },
					"<F4>",
					vim.lsp.buf.code_action,
					vim.tbl_extend("force", opts_base, { desc = "LSP: Code action / quick fix" })
				)
				map(
					"n",
					"gl",
					vim.diagnostic.open_float,
					vim.tbl_extend("force", opts_base, { desc = "Diagnostics: Open float" })
				)
				map(
					"n",
					"[d",
					vim.diagnostic.goto_prev,
					vim.tbl_extend("force", opts_base, { desc = "Diagnostics: Previous" })
				)
				map(
					"n",
					"]d",
					vim.diagnostic.goto_next,
					vim.tbl_extend("force", opts_base, { desc = "Diagnostics: Next" })
				)
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

		vim.lsp.config("clangd", {
			cmd = {
				"clangd",
				"--background-index",
				"--clang-tidy",
				"--header-insertion=never",
			},
			capabilities = capabilities,
		})

		vim.lsp.config("pyright", {
			settings = {
				python = {
					analysis = {
						typeCheckingMode = "basic",
						autoSearchPaths = true,
						useLibraryCodeForTypes = true,
					},
				},
			},
		})

		vim.lsp.config("tsserver", {
			settings = {
				completions = {
					completeFunctionCalls = true,
				},
			},
		})

		--[[
    vim.api.nvim_create_autocmd("BufWritePre", {
      pattern = { "*.lua", "*.py", "*.cpp", "*.c", "*.js", "*.ts", "*.xml" },
      callback = function()
        vim.lsp.buf.format({ async = false })
      end
    })
    --]]

		-- Auto‑pair integration with cmp
		require("cmp").event:on("confirm_done", require("nvim-autopairs.completion.cmp").on_confirm_done())
	end,
}
