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
			local capabilities = require('blink.cmp').get_lsp_capabilities()
			require 'lspconfig'.lua_ls.setup { capabilities = capabilities }

			local lspconfig = require('lspconfig')
			lspconfig.sourcekit.setup {
				capabilities = {
					workspace = {
						didChangeWatchedFiles = {
							dynamicRegistration = true,
						},
					},
				},
			}

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

					if vim.bo.filetype == "lua" then
						-- Format the current buffer on save
						vim.api.nvim_create_autocmd('BufWritePre', {
							buffer = args.buf,
							callback = function()
								vim.lsp.buf.format({ bufnr = args.buf, id = c.id })
							end,
						})
					end

					vim.keymap.set('n', 'K', vim.lsp.buf.hover, { noremap = true, silent = true })
					vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { noremap = true, silent = true })
				end,
			})
		end,
	}
}
