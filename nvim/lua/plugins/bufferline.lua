return {
	{
		"akinsho/bufferline.nvim",
		version = "*",
		dependencies = {
			"nvim-tree/nvim-web-devicons",
			"catppuccin/nvim",
		},
		opts = {
			highlights = nil,

			options = {
				show_buffer_icons = true,
				show_buffer_close_icons = true,
				show_close_icon = false,
				separator_style = "slant",
				numbers = function(opts)
					return tostring(opts.ordinal)
				end,

				diagnostics = "nvim_lsp",

				diagnostics_indicator = function(count, level, diagnostics_dict, context)
					if not diagnostics_dict then
						return ""
					end
					local s = ""
					if diagnostics_dict.error and diagnostics_dict.error > 0 then
						s = s .. diagnostics_dict.error .. " "
					end
					if diagnostics_dict.warning and diagnostics_dict.warning > 0 then
						s = s .. diagnostics_dict.warning .. " "
					end
					if diagnostics_dict.info and diagnostics_dict.info > 0 then
						s = s .. diagnostics_dict.info .. ""
					end
					return s ~= "" and (" " .. s) or ""
				end,
			},
		},

		config = function(_, opts)
			vim.opt.termguicolors = true

			local ok_b, cp = pcall(require, "catppuccin.groups.integrations.bufferline")
			if ok_b and type(cp.get) == "function" then
				opts.highlights = cp.get({
					styles = { "italic", "bold" },
					custom = {
						all = { fill = { bg = "#000000" } },
						mocha = { background = { fg = "#E8E2D6" } },
						latte = { background = { fg = "#000000" } },
					},
				})
			else
			end

			local function lsp_server_names_for_buf(bufnr)
				if not bufnr or bufnr == 0 then
					bufnr = vim.api.nvim_get_current_buf()
				end
				local ok, clients = pcall(vim.lsp.get_clients, { buf = bufnr })
				if not ok or not clients or vim.tbl_isempty(clients) then
					return ""
				end
				local names = {}
				for _, c in ipairs(clients) do
					if c and c.name then
						table.insert(names, c.name)
					end
				end
				local seen = {}
				local res = {}
				for _, n in ipairs(names) do
					if not seen[n] then
						table.insert(res, n)
						seen[n] = true
					end
				end
				return table.concat(res, ", ")
			end

			opts.options.diagnostics_indicator = function(count, level, diagnostics_dict, context)
				local bufnr = (context and context.buf) or (context and context.buffer) or nil
				if not diagnostics_dict then
					diagnostics_dict = {}
				end
				local parts = {}
				if diagnostics_dict.error and diagnostics_dict.error > 0 then
					table.insert(parts, diagnostics_dict.error .. "")
				end
				if diagnostics_dict.warning and diagnostics_dict.warning > 0 then
					table.insert(parts, diagnostics_dict.warning .. "")
				end
				if diagnostics_dict.info and diagnostics_dict.info > 0 then
					table.insert(parts, diagnostics_dict.info .. "")
				end

				local srv = lsp_server_names_for_buf(bufnr)
				if srv ~= "" then
					table.insert(parts, "(" .. srv .. ")")
				end

				if #parts == 0 then
					return ""
				end
				return " " .. table.concat(parts, " ")
			end

			require("bufferline").setup(opts)

			local map = vim.keymap.set
			map("n", "<leader>bn", "<cmd>enew<CR>", { desc = "New empty buffer" })
			map("n", "<TAB>", "<cmd>bn<CR>", { desc = "Next buffer" })
			map("n", "<S-TAB>", "<cmd>bp<CR>", { desc = "Previous buffer" })
			map("n", "<leader>bd", "<cmd>bd!<CR>", { desc = "Close buffer" })
		end,
	},
}
