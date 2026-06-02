print("loaded git-branch-selector.nvim")

local M = {}

M.setup = function()
	SaveAllBranches()
end

function SaveAllBranches()
	local outputTable = vim.fn.systemlist("git branch -r")
	-- for _, singleValue in ipairs(outputString) do
	-- print(singleValue)
	-- end

	vim.ui.select(outputTable, {
		prompt = "Select an Element",
	}, function(choice)
		if choice then
			print("Picked:" .. choice)
		end
	end)
end
return M
