return {
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			{
				"folke/lazydev.nvim",
				ft = "lua", -- only load on lua files
				opts = {
					library = {
						-- See the configuration section for more details
						-- Load luvit types when the `vim.uv` word is found
						{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
					},
				},
			}
		},
		config = function()
			vim.lsp.config("lua_ls", {
				capabilities = vim.tbl_deep_extend("force", vim.lsp.protocol.make_client_capabilities(), {
					textDocument = {
						completion = {
							completionItem = {
								snippetSupport = true,
							},
						},
					},
				}),
			})
			vim.lsp.enable({ "lua_ls" })

			vim.lsp.config("sourcekit", {
				capabilities = vim.tbl_deep_extend("force", vim.lsp.protocol.make_client_capabilities(), {
					textDocument = {
						completion = {
							completionItem = {
								snippetSupport = true,
							},
						},
					},
				}),
			})
			vim.lsp.enable({ "sourcekit" })
			-- temporarily disabled until bug is fixed
			-- https://github.com/swiftlang/sourcekit-lsp/issues/2021
			-- vim.lsp.inlay_hint.enable(false)

			vim.diagnostic.config({
				virtual_text = true,
				signs = true,
				update_in_insert = false,
				underline = true,
				severity_sort = false,
				float = true,
			})

			vim.api.nvim_create_autocmd('LspAttach', {
				callback = function(args)
					local c = vim.lsp.get_client_by_id(args.data.client_id)
					if not c then return end

					-- Enable native LSP completion (0.12 feature)
					if c:supports_method('textDocument/completion') then
						vim.lsp.completion.enable(true, c.id, args.buf, {
							autotrigger = true,
						})
					end

					if vim.bo.filetype == "lua" or vim.bo.filetype == "swift" then
						vim.api.nvim_create_autocmd('BufWritePre', {
							buffer = args.buf,
							callback = function()
								vim.lsp.buf.format({ bufnr = args.buf, id = c.id })
							end,
						})
					end

					local keymaps = {
						{ key = 'K', fn = vim.lsp.buf.hover },
						{ key = 'gd', fn = vim.lsp.buf.definition },
						{ key = 'gr', fn = vim.lsp.buf.references },
						{ key = 'gI', fn = vim.lsp.buf.implementation },
						{ key = 'gD', fn = vim.lsp.buf.type_definition },
						{ key = '<leader>cr', fn = vim.lsp.buf.rename },
						{ key = '<leader>ca', fn = vim.lsp.buf.code_action },
					}

					for _, km in ipairs(keymaps) do
						vim.keymap.set('n', km.key, km.fn, { noremap = true, silent = true, buffer = args.buf })
					end
				end,
			})
		end,
	}
}
