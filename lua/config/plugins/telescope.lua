return {
	{
		'nvim-telescope/telescope.nvim',
		tag = 'v0.2.1',
		dependencies = {
			'nvim-lua/plenary.nvim',
			{ 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' }
		},
		config = function()
			require('telescope').setup {
				pickers = {
					find_files = {
						theme = "ivy",
						hidden = true,
					}
				},
				extensions = {
					fzf = {}
				},
				file_ignore_patterns = {
					".build"
				},
				defaults = {
					layout_config = { 
						preview_width = 0.6,
						width = 0.9
					}
				}
			}

			require('telescope').load_extension('fzf')

			vim.keymap.set("n", "<space>fh", require('telescope.builtin').help_tags)
			vim.keymap.set("n", "<space>ff", require('telescope.builtin').find_files)
			vim.keymap.set("n", "<space>fs", require('telescope.builtin').live_grep)
			vim.keymap.set("n", "<space>en", function()
				require('telescope.builtin').find_files {
					cwd = vim.fn.stdpath("config")
				}
			end)
		end
	}
}
