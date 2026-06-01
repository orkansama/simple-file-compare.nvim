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
				local currentFile = vim.fn.bufname("%")
				vim.cmd("terminal git difftool " .. choice .. " -- " .. currentFile .. "")
			end
		end
	end)
end

return M
