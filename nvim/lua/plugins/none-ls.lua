return {
	"nvimtools/none-ls.nvim",
  priority = 100,
	dependencies = {
		"nvimtools/none-ls-extras.nvim",
	},
	config = function()
		local null_ls = require("null-ls")
		vim.keymap.set("n", "<leader><leader>f", vim.lsp.buf.format, {})
	end,
}
