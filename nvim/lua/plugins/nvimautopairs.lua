return {
	"windwp/nvim-autopairs",
	event = "InsertEnter",
	dependencies = { "hrsh7th/nvim-cmp" },
	config = function()
		local autopairs = require("nvim-autopairs")
		local Rule = require("nvim-autopairs.rule")
		local cond = require("nvim-autopairs.conds")

		autopairs.setup({
			check_ts = true,
			ts_config = {
				lua = { "string", "source" },
				javascript = { "string", "template_string" },
				typescript = { "string", "template_string" },
				javascriptreact = { "string", "template_string" },
				typescriptreact = { "string", "template_string" },
				python = { "string" },
				c = { "string" },
				cpp = { "string" },
				html = { "text" },
			},
		})

		local cmp_autopairs = require("nvim-autopairs.completion.cmp")
		local cmp = require("cmp")
		cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())

		vim.api.nvim_create_autocmd("FileType", {
			pattern = { "markdown", "text", "gitcommit" },
			callback = function()
				vim.b.autopairs_enabled = false
			end,
		})
	end,
}
