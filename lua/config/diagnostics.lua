vim.keymap.set('n', '<leader>k', function()
  vim.diagnostic.config({ virtual_lines = { current_line = true }, virtual_text = false })

  vim.api.nvim_create_autocmd('CursorMoved', {
    group = vim.api.nvim_create_augroup('line-diagnostics', { clear = true }),
    callback = function()
      vim.diagnostic.config({ virtual_lines = false, virtual_text = true })
      return true
    end,
  })
end)

---@param jumpCount number
local function jumpWithVirtLineDiags(jumpCount)
	pcall(vim.api.nvim_del_augroup_by_name, "jumpWithVirtLineDiags") -- prevent autocmd for repeated jumps

	vim.diagnostic.jump { count = jumpCount }

	local initialVirtTextConf = vim.diagnostic.config().virtual_text
	vim.diagnostic.config {
		virtual_text = false,
		virtual_lines = { current_line = true },
	}

	vim.defer_fn(function() -- deferred to not trigger by jump itself
		vim.api.nvim_create_autocmd("CursorMoved", {
			desc = "User(once): Reset diagnostics virtual lines",
			once = true,
			group = vim.api.nvim_create_augroup("jumpWithVirtLineDiags", {}),
			callback = function()
				vim.diagnostic.config { virtual_lines = false, virtual_text = initialVirtTextConf }
			end,
		})
	end, 1)
end

vim.keymap.set("n", "ge", function() jumpWithVirtLineDiags(1) end, { desc = "󰒕 Next diagnostic" })
vim.keymap.set("n", "gE", function() jumpWithVirtLineDiags(-1) end, { desc = "󰒕 Prev diagnostic" })
