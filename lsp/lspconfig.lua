return {
	{
		"neovim/nvim-lspconfig",
		-- event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			{ "folke/neodev.nvim", opts = {} },
			-- mason
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			"WhoIsSethDaniel/mason-tool-installer.nvim",

			"hrsh7th/cmp-nvim-lsp",
			{ "antosha417/nvim-lsp-file-operations", config = true },
		},
		-- keys = {
		-- 	{ "gR", "<cmd>Telescope lsp_references<CR>", vim.b.optRe("Show LSP referencesc") },
		-- 	{ "gD", vim.lsp.buf.declaration, vim.b.optRe("Go to declaratiesc") },
		-- 	{ "gd", "<cmd>Telescope lsp_definitions<CR>", vim.b.optRe("Show LSP definitioesc") },
		-- 	{ "gi", "<cmd>Telescope lsp_implementations<CR>", vim.b.optRe("Show LSP implementations") },
		-- 	{ "<leader>ca", vim.lsp.buf.code_action, vim.b.optRe("See available code actions") },
		-- 	{ "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", vim.b.optRe("Show buffer diagnostics") },
		-- 	{ "do", vim.diagnostic.open_float, vim.b.optRe("Show line diagnostics") }, -- open new tab
		-- 	{ "d[", vim.diagnostic.goto_prev, vim.b.optRe("Go to previous diagnostic") },
		-- 	{ "d]", vim.diagnostic.goto_next, vim.b.optRe("Go to next diagnostic") },
		-- 	{ "dq", vim.diagnostic.setloclist, vim.b.optRe("Go to next diagnostic") },
		-- 	{ "K", vim.lsp.buf.hover, vim.b.optRe("Show documentation for what is under cursor") },
		-- 	{ "rs", ":LspRestart<CR>", vim.b.optRe("Restart LSP") },
		-- },
		opts = {
			-- options for vim.diagnostic.config()
			diagnostics = {
				underline = true,
				update_in_insert = false,
				virtual_text = {
					spacing = 4,
					source = "if_many",
					prefix = "●",
					-- this will set set the prefix to a function that returns the diagnostics icon based on the severity this only works on a recent 0.10.0 build. Will be set to "●" when not supported prefix = "icons",
				},
				severity_sort = true,
				-- signs = { text = { [vim.diagnostic.severity.ERROR] = require("lazyvim.config").icons.diagnostics.Error, [vim.diagnostic.severity.WARN] = require("lazyvim.config").icons.diagnostics.Warn, [vim.diagnostic.severity.HINT] = require("lazyvim.config").icons.diagnostics.Hint, [vim.diagnostic.severity.INFO] = require("lazyvim.config").icons.diagnostics.Info, }, },
			},
			-- Enable this to enable the builtin LSP inlay hints on Neovim >= 0.10.0
			-- Be aware that you also will need to properly configure your LSP server to
			-- provide the inlay hints.
			inlay_hints = {
				enabled = false,
			},
			-- Enable this to enable the builtin LSP code lenses on Neovim >= 0.10.0
			-- Be aware that you also will need to properly configure your LSP server to
			-- provide the code lenses.
			codelens = {
				enabled = false,
			},
			-- add any global capabilities here
			capabilities = {},
			-- options for vim.lsp.buf.format
			-- `bufnr` and `filter` is handled by the LazyVim formatter,
			-- but can be also overridden when specified
			format = {
				formatting_options = nil,
				timeout_ms = nil,
			},
			-- LSP Server Settings
			--@type lspconfig.options
			servers = {
				lua_ls = {
					-- mason = false, -- set to false if you don't want this server to be installed with mason
					-- Use this to add any additional keymaps
					-- for specific lsp servers
					--@type LazyKeysSpec[]
					-- keys = {},
					settings = {
						Lua = {
							workspace = {
								checkThirdParty = false,
							},
							codeLens = {
								enable = true,
							},
							completion = {
								callSnippet = "Replace",
							},
						},
					},
				},
			},
			-- you can do any additional lsp server setup here return true if you don't want this server to be setup with lspconfig
			--@type table<string, fun(server:string, opts:_.lspconfig.options):boolean?>
			setup = {
				-- example to setup with typescript.nvim
				-- tsserver = function(_, opts)
				--   require("typescript").setup({ server = opts })
				--   return true
				-- end,
				-- Specify * to use this function as a fallback for any server
				-- ["*"] = function(server, opts) end,
			},
		},
		config = function()
			-- import lspconfig plugin
			local lspconfig = require("lspconfig")

			-- import cmp-nvim-lsp plugin
			local cmp_nvim_lsp = require("cmp_nvim_lsp")

			-- enable keybinds only for when lsp server available

			-- local text_on_attach = function(client, bufnr)
			-- 	local function opte(desc)
			-- 		return { desc = "text: " .. desc, noremap = true, nowait = true, buffer = bufnr }
			-- 	end
			-- 	-- vim.wo.wrap = true
			-- end

			local on_attach = function(client, bufnr)
				local function opte(desc)
					return { desc = "my: " .. desc, noremap = true, nowait = true, buffer = bufnr }
				end
				vim.keymap.set("n", "gR", "<cmd>Telescope lsp_references<CR>", vim.b.optRe("Show LSP referencesc"))
				vim.keymap.set("n", "gD", vim.lsp.buf.declaration, vim.b.optRe("Go to declaratiesc"))
				vim.keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", vim.b.optRe("Show LSP definitioesc"))
				vim.keymap.set(
					"n",
					"gi",
					"<cmd>Telescope lsp_implementations<CR>",
					vim.b.optRe("Show LSP implementations")
				)
				vim.keymap.set(
					{ "n", "v" },
					"<leader>ca",
					vim.lsp.buf.code_action,
					vim.b.optRe("See available code actions")
				)
				vim.keymap.set(
					"n",
					"<leader>D",
					"<cmd>Telescope diagnostics bufnr=0<CR>",
					vim.b.optRe("Show buffer diagnostics")
				)
				vim.keymap.set("n", "do", vim.diagnostic.open_float, vim.b.optRe("Show line diagnostics"))
				vim.keymap.set("n", "d[", vim.diagnostic.goto_prev, vim.b.optRe("Go to previous diagnostic"))
				vim.keymap.set("n", "d]", vim.diagnostic.goto_next, vim.b.optRe("Go to next diagnostic"))
				vim.keymap.set("n", "dq", vim.diagnostic.setloclist, vim.b.optRe("Go to next diagnostic"))
				vim.keymap.set("n", "K", vim.lsp.buf.hover, vim.b.optRe("Show documentation for what is under cursor"))
				vim.keymap.set("n", "rs", ":LspRestart<CR>", vim.b.optRe("Restart LSP"))
			end

			-- used to enable autocompletion (assign to every lsp server config)
			local capabilities = cmp_nvim_lsp.default_capabilities()

			-- Change the Diagnostic symbols in the sign column (gutter)
			-- (not in youtube nvim video)
			local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
			for type, icon in pairs(signs) do
				local hl = "DiagnosticSign" .. type
				vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
			end

			-- -- configure text server
			-- lspconfig["textlsp"].setup({
			-- 	capabilities = capabilities,
			-- 	on_attach = text_on_attach(),
			-- })

			-- configure html server
			lspconfig["html"].setup({
				capabilities = capabilities,
				on_attach = on_attach,
			})

			-- configure css server
			lspconfig["cssls"].setup({
				capabilities = capabilities,
				on_attach = on_attach,
			})

			-- -- configure svelte server
			-- lspconfig["svelte"].setup({
			-- 	capabilities = capabilities,
			-- 	on_attach = function(client, bufnr)
			-- 		on_attach(client, bufnr)
			-- 		vim.api.nvim_create_autocmd("BufWritePost", {
			-- 			pattern = { "*.js", "*.ts" },
			-- 			callback = function(ctx)
			-- 				if client.name == "svelte" then
			-- 					client.notify("$/onDidChangeTsOrJsFile", { uri = ctx.file })
			-- 				end
			-- 			end,
			-- 		})
			-- 	end,
			-- })

			-- configure emmet language server
			lspconfig["emmet_ls"].setup({
				capabilities = capabilities,
				on_attach = on_attach,
				filetypes = { "html", "css", "sass", "scss", "less", "svelte" },
			})

			-- configure python server
			lspconfig["pyright"].setup({
				capabilities = capabilities,
				on_attach = on_attach,
			})

			-- configure lua server (with special settings)
			lspconfig["lua_ls"].setup({
				capabilities = capabilities,
				on_attach = on_attach,
				settings = { -- custom settings for lua
					Lua = {
						-- make the language server recognize "vim" global
						diagnostics = {
							globals = { "vim" },
						},
						workspace = {
							-- make language server aware of runtime files
							library = {
								[vim.fn.expand("$VIMRUNTIME/lua")] = true,
								[vim.fn.stdpath("config") .. "/lua"] = true,
							},
						},
					},
				},
			})
			-- require("lspconfig.ui.windows").default_options.border = require("utils").border
			vim.lsp.set_log_level("off")
		end,
	},
	{
		-- adds ui/commands that take advantage of the capabilities of the neovim lsp client like showing information in statusline and nice looking commands for goto definition and stuff
		"nvimdev/lspsaga.nvim",
		event = { "BufEnter", "BufRead" },
		config = function()
			require("lspsaga").setup({
				-- keybinds for navigation in lspsaga window
				scroll_preview = { scroll_down = "<M-f>", scroll_up = "<M-b>" },
				-- use enter to open file with definition preview
				definition = {
					edit = "<CR>",
				},
				ui = {
					colors = {
						normal_bg = "#022746",
					},
				},
				ui = {
					border = require("utils").border,
					code_action = "",
				},
			})
		end,
	},
	-- { "hinell/lsp-timeout.nvim", event = "VeryLazy", init = function() vim.g.lspTimeoutConfig = { stopTimeout = 1000 * 60 * 2, -- ms, timeout before stopping all LSPs startTimeout = 1000 * 10, -- ms, timeout before restart silent = false, -- true to suppress notifications filetypes = { ignore = { -- filetypes to ignore; empty by default lsp-timeout is disabled completely }, -- for these filetypes }, } end, },
	{
		-- displaying reference and definition info upon functions like JB's IDEA.
		"VidocqH/lsp-lens.nvim",
		event = { "BufEnter", "BufRead" },
		config = function()
			local SymbolKind = vim.lsp.protocol.SymbolKind

			require("lsp-lens").setup({
				enable = true,
				include_declaration = false, -- Reference include declaration
				sections = {
					definition = function(count)
						return "Definitions: " .. count
					end,
					references = function(count)
						return "References: " .. count
					end,
					implements = function(count)
						return "Implements: " .. count
					end,
					git_authors = function(latest_author, count)
						return " " .. latest_author .. (count - 1 == 0 and "" or (" + " .. count - 1))
					end,
				},
				ignore_filetype = {
					"prisma",
					-- "neo-tree",
					"dashboard",
					"toggleterm",
				},
				-- Target Symbol Kinds to show lens information
				target_symbol_kinds = { SymbolKind.Function, SymbolKind.Method, SymbolKind.Interface },
				-- Symbol Kinds that may have target symbol kinds as children
				wrapper_symbol_kinds = { SymbolKind.Class, SymbolKind.Struct },
			})
		end,
	},
}
--Server "docker_compose_language_service" is being set up before mason.nvim is set up. :h maso n-lspconfig-quickstart
