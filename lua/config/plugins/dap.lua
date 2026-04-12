return {
	{
		"mfussenegger/nvim-dap",
		url = "https://github.com/mfussenegger/nvim-dap",
		dependencies = {
			{
				"rcarriga/nvim-dap-ui",
				url = "https://github.com/rcarriga/nvim-dap-ui",
				dependencies = {
					"nvim-neotest/nvim-nio",
				},
			},
		},
		config = function()
			local dap = require("dap")
			local dapui = require("dapui")

			require("dapui").setup()

			local toolchain_path = os.getenv("HOME") .. "/.local/share/swiftly/toolchains"
			local toolchains = vim.fn.globpath(toolchain_path, "*", 0, 1)
			table.sort(toolchains, function(a, b) return a > b end)
			local lldb_dap = (toolchains[1] or "") .. "/usr/bin/lldb-dap"

			dap.adapters.lldb = {
				type = "executable",
				command = lldb_dap,
				env = { LD_LIBRARY_PATH = "/lib64" },
			}

			local function get_swift_config()
				local workspace = vim.fn.getcwd()
				local package_file = workspace .. "/Package.swift"
				local program_name = ""

				if vim.fn.filereadable(package_file) == 0 then
					return
				end

				local package_content = vim.fn.readfile(package_file)
				if package_content then
					local pkg_table = table.concat(package_content, "\n")
					local name_match = pkg_table:match('name%s*:%s*"([^"]+)"')
					if name_match then
						program_name = name_match
					end
				end

				local program = program_name ~= "" 
					and string.format("%s/.build/debug/%s", workspace, program_name) 
					or nil
				local configs = {
					{
						name = "Debug " .. program_name,
						type = "lldb",
						request = "launch",
						program = program,
						cwd = workspace,
					},
				}

				dap.configurations.swift = configs
			end

			get_swift_config()

			vim.api.nvim_create_autocmd("FileType", {
				pattern = "swift",
				callback = get_swift_config,
			})

			dap.listeners.after.event_initialized["dapui_config"] = function()
				dapui.open({ reset = true })
			end

			dap.listeners.before.event_terminated["dapui_config"] = function()
				dapui.close()
			end

			dap.listeners.before.event_exited["dapui_config"] = function()
				dapui.close()
			end

			vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, { desc = "Toggle breakpoint" })
			vim.keymap.set("n", "<leader>dc", function()
				local configs = dap.configurations.swift
				if configs and #configs > 0 then
					dap.run(configs[1])
				else
					dap.continue()
				end
			end, { desc = "Continue/Start" })
			vim.keymap.set("n", "<leader>ds", dap.step_over, { desc = "Step over" })
			vim.keymap.set("n", "<leader>di", dap.step_into, { desc = "Step into" })
			vim.keymap.set("n", "<leader>do", dap.step_out, { desc = "Step out" })
			vim.keymap.set("n", "<leader>dr", dap.restart, { desc = "Restart" })
			vim.keymap.set("n", "<leader>de", dap.terminate, { desc = "Terminate" })

			vim.keymap.set("n", "<leader>dv", dapui.toggle, { desc = "Toggle DAP UI" })
		end,
	},
}
