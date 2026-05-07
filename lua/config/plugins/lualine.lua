return {
	{
		'nvim-lualine/lualine.nvim',
		dependencies = { 'nvim-tree/nvim-web-devicons' },
		opts = {
			sections = {
				lualine_x = { 'encoding', 'fileformat', 'filetype' },
				lualine_y = { 'location' },
				lualine_z = {
					{
						'lsp_status',
						symbols = {
							spinner = { '⠋', '⠙', '⠹', '⠸', '⠼', '⠴', '⠦', '⠧', '⠇', '⠏' },
							done = '✓',
							separator = ', ',
						},
					}
				},
			},
		},
	}
}
