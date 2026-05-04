return {
	"zeioth/none-ls-autoload.nvim",
	event = "BufEnter",
	dependencies = {
		"mason-org/mason.nvim",
		"zeioth/none-ls-external-sources.nvim",
	},
	opts = {
		external_sources = {
			-- DIAGNOSTICS (Linters)
			"none-ls-external-sources.diagnostics.cpplint", -- C/C++ linter
			"none-ls-external-sources.diagnostics.eslint_d", -- JS/TS
			"none-ls-external-sources.diagnostics.flake8", -- Python
			"none-ls-external-sources.diagnostics.luacheck", -- Lua

			-- FORMATTING
			"none-ls-external-sources.formatting.jq", -- JSON
			"none-ls-external-sources.formatting.latexindent", -- XML/LaTeX

			-- CODE ACTIONS
			"none-ls-external-sources.code_actions.shellcheck", -- Shell scripts
		},
	},
}
