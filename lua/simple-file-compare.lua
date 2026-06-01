print("loaded git-branch-selector.nvim")

local M = {}
M.setup = function()
	vim.api.nvim_create_user_command("Test", function()
		Compare()
	end, {})
end

function Compare()
	local outputTable = vim.fn.systemlist("git branch")
	vim.ui.select(outputTable, {
		prompt = "Select an Element",
	}, function(choice)
		if choice then
			local selectedActiveBranch = vim.startswith(choice, "*")
			if selectedActiveBranch then
				return vim.notify("Cant compare with active branch!", 4)
			else
                -- TODO: Place the two buffers in one window so you can ":q" out
				local currentFile = vim.fn.bufname("%")

				local otherContent = vim.fn.systemlist("git show " .. choice .. ":" .. currentFile)

				vim.cmd("vsp | enew")

				local currentBuf = vim.api.nvim_get_current_buf()

				vim.api.nvim_buf_set_lines(currentBuf, 0, -1, false, otherContent)

				vim.cmd("diffthis")
				vim.cmd("wincmd p")
				vim.cmd("diffthis")
			end
		end
	end)
end

return M
