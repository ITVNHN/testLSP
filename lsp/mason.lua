return {
	{
		"williamboman/mason.nvim",
		-- priority = 10000,
		-- event = { "BufReadPre", "BufReadPost", "BufWritePost", "BufNewFile" },
		dependencies = {
			"williamboman/mason-lspconfig.nvim",
			"WhoIsSethDaniel/mason-tool-installer.nvim",
		},
		keys = { { "<leader>lm", "<cmd>Mason<cr>", desc = "Mason" } },
		cmd = "Mason",
		build = ":MasonUpdate",
		opts = {
			ui = {
				icons = {
					package_installed = "✓",
					package_pending = "➜",
					package_uninstalled = "✗",
				},
			},
		},
		config = function()
			local mason_tool_installer = require("mason-tool-installer")

			mason_tool_installer.setup({
				ensure_installed = {
					"prettier", -- prettier formatter
					"stylua", -- lua formatter
				},
			})
		end,
	},
	{
		-- configure servers downloaded with mason (usually by using nvim-lspconfig, see my config if you want an example)
		"williamboman/mason-lspconfig.nvim",
		config = function()
			local capabilities = require("cmp_nvim_lsp").default_capabilities()
			require("mason-lspconfig").setup({
				handlers = {
					setupLSP,
				},
				automatic_installation = true,
			})

			local function setupLSP(lsp_server)
				require("lspconfig")[lsp_server].setup({
					capabilities = capabilities,
				})
			end

			vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {})

			-- -- Fixing a bug that trigger vim.lsp.buf.hover multiple times when using it when running multiple lsp in a single buffer
			-- vim.lsp.handlers["textDocument/hover"] = function(_, result, ctx, config)
			-- 	config = config or {}
			-- 	config.focus_id = ctx.method
			-- 	config.border = require("utils").border
			-- 	if not (result and result.contents) then
			-- 		return
			-- 	end
			-- 	local markdown_lines = vim.lsp.util.convert_input_to_markdown_lines(result.contents)
			-- 	markdown_lines = vim.lsp.util.trim_empty_lines(markdown_lines)
			-- 	if vim.tbl_isempty(markdown_lines) then
			-- 		return
			-- 	end
			-- 	return vim.lsp.util.open_floating_preview(markdown_lines, "markdown", config)
			-- end

			vim.diagnostic.config({
				virtual_text = {
					prefix = " ",
					source = "always",
				},
				signs = true,
				underline = false,
				update_in_insert = false,
				severity_sort = true,
			})

			-- Setup diagnostic highlight and icon
			vim.fn.sign_define({
				{
					name = "DiagnosticSignError",
					text = " ",
					texthl = "DiagnosticSignError",
					linehl = "ErrorLine",
					numhl = "DiagnosticSignError",
				},
				{
					name = "DiagnosticSignWarn",
					text = " ",
					texthl = "DiagnosticSignWarn",
					linehl = "WarningLine",
					numhl = "DiagnosticSignWarn",
				},
				{
					name = "DiagnosticSignInfo",
					text = " ",
					texthl = "DiagnosticSignInfo",
					linehl = "InfoLine",
					numhl = "DiagnosticSignInfo",
				},
				{
					name = "DiagnosticSignHint",
					text = " ",
					texthl = "DiagnosticSignHint",
					linehl = "HintLine",
					numhl = "DiagnosticSignHint",
				},
			})
		end,
	},
}
