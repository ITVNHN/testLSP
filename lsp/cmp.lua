return {
	"hrsh7th/nvim-cmp",
	event = "InsertEnter",
	dependencies = {
		"hrsh7th/cmp-buffer", -- source for text in buffer
		"hrsh7th/cmp-path", -- source for file system paths
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/cmp-cmdline",
		"saadparwaiz1/cmp_luasnip", -- for autocompletion
		"neovim/nvim-lspconfig",
		{
			"L3MON4D3/LuaSnip",
			-- follow latest release.
			version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release) install jsregexp (optional!).
			build = "make install_jsregexp",
		},
		"rafamadriz/friendly-snippets", -- useful snippets
		"onsails/lspkind.nvim", -- vs-code like pictograms
	},
	config = function()
		local cmp = require("cmp")
		local cmp_select = { behavior = cmp.SelectBehavior.Select }

		local luasnip = require("luasnip")
		local lspkind = require("lspkind")
		local t = function(str)
			return vim.api.nvim_replace_termcodes(str, true, true, true)
		end
		-- copilot
		-- local has_words_before = function()
		-- 	if vim.bo[0].buftype == "prompt" then
		-- 		return false
		-- 	end
		-- 	local line, col = unpack(vim.api.nvim_win_get_cursor(0))
		-- 	return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
		-- end

		-- loads vscode style snippets from installed plugins (e.g. friendly-snippets)
		require("luasnip.loaders.from_vscode").lazy_load()

		cmp.setup({
			-- cmp.mapping.confirm({ select = true }),
			preselect = cmp.PreselectMode.Item,
			-- preselect = cmp.PreselectMode.None,
			completion = {
				-- autocomplete = {
				-- 	types.cmp.TriggerEvent.TextChanged,
				-- },
				completeopt = "menu,menuone,preview,noinsert",
				-- keyword_pattern = [[\%(-\?\d\+\%(\.\d\+\)\?\|\h\w*\%(-\w*\)*\)]],
				-- keyword_length = 1,
			},
			snippet = { -- configure how nvim-cmp interacts with snippet engine
				expand = function(args)
					-- vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
					luasnip.lsp_expand(args.body) -- For `luasnip` users.
					-- require("snippy").expand_snippet(args.body) -- For `snippy` users.
					-- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
				end,
			},
			window = {
				-- completion = cmp.config.window.bordered(),
				-- documentation = cmp.config.window.bordered(),
			},
			mapping = cmp.mapping.preset.insert({

				["<C-k>"] = cmp.mapping.select_prev_item(cmp_select), -- previous suggestion
				["<C-h>"] = cmp.mapping.select_next_item(cmp_select), -- next suggestion
				["<M-j>"] = cmp.mapping.select_next_item(), -- next suggestion
				-- ["<leader>b"] = cmp.mapping.select_next_item(), -- next suggestion
				-- ["<leader>a"] = function()
				-- func()
				-- cmp.mapping.select_next_item()
				-- 	cmp.mapping.confirm({ select = false })
				-- end,

				-- ["<leader>a"] = {cmp.mapping.select_next_item() , cmp.mapping.confirm()} -- next suggestion
				["<C-b>"] = cmp.mapping.scroll_docs(-4),
				["<C-f>"] = cmp.mapping.scroll_docs(4),
				["<C-Space>"] = cmp.mapping.complete(), -- show completion suggestions
				["<C-e>"] = cmp.mapping.abort(), -- close completion window
				-- documentation says this is important. I don't know why.
				["<CR>"] = cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false }),
				[";"] = cmp.mapping.confirm({ select = false }),
				["<Tab>"] = cmp.mapping(function(fallback)
					if vim.fn["UltiSnips#CanJumpForwards"]() == 1 then
						vim.fn.feedkeys(t("<esc>:call UltiSnips#JumpForwards()<CR>"))
					elseif vim.fn.pumvisible() == 1 then
						vim.fn.feedkeys(t("<C-n>"), "n")
					else
						vim.fn.feedkeys(t("<tab>"), "n")
					end
				end, { "i", "s" }),
				-- copilot
				-- ["<Tab>"] = cmp.mapping(function(fallback) if cmp.visible() and has_words_before() then cmp.select_next_item({ behavior = cmp.SelectBehavior.Select }) else fallback() end end, { "i", "s" }),
				["<S-Tab>"] = cmp.mapping(function(fallback)
					if cmp.visible() then
						cmp.select_prev_item()
					elseif luasnip.locally_jumpable(-1) then
						luasnip.jump(-1)
					else
						fallback()
					end
				end, { "i", "s" }),
			}),
			-- sources for autocompletion
			sources = cmp.config.sources({
				{ name = "nvim_lsp" },
				{ name = "luasnip" }, -- snippets
				{ name = "buffer" }, -- text within current buffer
				{ name = "path" }, -- file system paths
				-- { name = "vsnip" }, -- For vsnip users.
				{ name = "snippy" }, -- For snippy users.
				{ name = "ultisnips" }, -- For ultisnips users.
			}, {
				{ name = "buffer" },
			}),

			-- `/` cmdline setup.
			cmp.setup.cmdline("/", {
				mapping = cmp.mapping.preset.cmdline(),
				sources = {
					{ name = "buffer" },
				},
			}),

			-- `:` cmdline setup.
			cmp.setup.cmdline(":", {
				mapping = cmp.mapping.preset.cmdline(),
				sources = cmp.config.sources({
					{ name = "path" },
				}, {
					{ name = "cmdline" },
				}),
			}),

			-- configure lspkind for vs-code like pictograms in completion menu
			formatting = {
				format = lspkind.cmp_format({
					maxwidth = 80,
					ellipsis_char = "...",
				}),
			},
		})
		-- vim.keymap.set("i", "<leader>d", function()
		-- 	-- func()
		-- 	cmp.mapping.confirm({ select = false })
		-- end, { desc = "Extract Constant" })
		-- vim.keymap.set("i", "<leader><leader>", " ")
		-- vim.keymap.set("i", ";f", function()
		-- 	-- func()
		-- 	cmp.mapping.select_next_item()
		-- 	-- cmp.mapping.confirm({ select = false })
		-- end, { desc = "Extract Constant" })
		-- vim.keymap.set("i", "<leader>c", function()
		-- 	-- func()
		-- 	cmp.mapping.select_next_item()
		-- 	cmp.mapping.confirm({ select = false })
		-- end, { desc = "Extract Constant" })
		-- vim.keymap.set(
		-- 	"i",
		-- 	"<leader>a",
		-- 	"<Cmd>cmp.mapping.select_next_item()<CR> <BAR> <Cmd>cmp.mapping.confirm({ select = false })<CR>",
		-- 	{ desc = "cmp" }
		-- )
	end,
}
