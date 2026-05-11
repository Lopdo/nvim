-- Native 0.12 completion settings
vim.opt.completeopt = { "menuone", "noinsert", "popup" }
vim.keymap.set('i', '<C-Space>', vim.lsp.completion.get, { desc = "Trigger LSP completion" })

vim.opt.exrc = true

-- Enable experimental ui2 (0.12 feature)
require('vim._core.ui2').enable()

require("config.lazy")
require("config.diagnostics")

vim.keymap.set("n", "<space><space>x", "<cmd>source %<CR>")
vim.keymap.set("n", "<space>x", ":.lua<CR>")
vim.keymap.set("v", "<space>x", ":lua<CR>")

require('lualine').setup({})

local function double_escape()
	local is_term = vim.bo.buftype == 'terminal'
	local term_job = vim.b.terminal_job_id

	if is_term and term_job then
		vim.cmd('bd!')
		return
	end

	for _, win in ipairs(vim.fn.getwininfo()) do
		if win.quickfix == 1 then
			vim.cmd('cclose')
			return
		end
	end
end

vim.keymap.set({ 'n', 't' }, '<leader><esc>', double_escape)
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.clipboard = "unnamedplus"

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.hl.on_yank()
	end,
})

