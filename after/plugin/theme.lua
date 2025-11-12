local tokyotheme = require("tokyonight")
tokyotheme.setup {
	on_highlights = function(hl, colors)
		hl.LineNr = {
			fg = "#dddddd",
		}
		hl.LineNrAbove = {
			fg = '#888888',
		}
		hl.LineNrBelow = {
			fg = '#888888',
		}
	end,
}

vim.cmd[[colorscheme tokyonight-night]]
