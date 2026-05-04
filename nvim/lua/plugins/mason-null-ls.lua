return {
	"jay-babu/mason-null-ls.nvim",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = { "mason-org/mason.nvim", "nvimtools/none-ls.nvim" },
	config = function()
		require("mason-null-ls").setup({
			ensure_installed = { "stylua", "prettierd", "black", "clang_format", "flake8", "eslint_d", "xmlformat" },
			automatic_installation = true,
		})
	end,
}
