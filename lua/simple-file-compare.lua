local M = {}

local config = {
	telescope = true,
	vimUiSelect = false,
}

M.setup = function(user_config)
	user_config = user_config or {}

	config = vim.tbl_deep_extend("force", config, user_config) -- merge both to be config, but with the right values
	if config.telescope == true and config.vimUiSelect == true then
		return vim.notify("simple-file-compare: Cant set telescope and vimUiSelect to true!", 4)
	end

	vim.api.nvim_create_user_command("Test", function()
		Compare()
	end, {})
end

function Compare()
	local outputTable = vim.fn.systemlist("git branch")

	if config.telescope == true then
		local pickers = require("telescope.pickers")
		local finders = require("telescope.finders")

		pickers
			.new({}, {
				finder = finders.new_table({
					results = outputTable,
				}),
			})
			:find()
	end

	if config.vimUiSelect == true then
		vim.ui.select(outputTable, {
			prompt = "Select an Element",
		}, function(choice)
			if choice then
				ChoiceLogic(choice)
			end
		end)
	end
end

function ReturnToBuffer(bufferPathToReturn)
	vim.api.nvim_create_user_command("Test2", function()
		vim.cmd("only")
		for _, buf in ipairs(vim.api.nvim_list_bufs()) do
			if buf ~= bufferPathToReturn then
				vim.api.nvim_buf_delete(buf, { force = true })
			end
		end
		vim.api.nvim_set_current_buf(bufferPathToReturn)
	end, {})
end

function ChoiceLogic(choice)
	local selectedActiveBranch = vim.startswith(choice, "*")
	if selectedActiveBranch then
		return vim.notify("Cant compare with active branch!", 4)
	else
		local currentFile = vim.fn.bufname("%")
		local otherContent = vim.fn.systemlist("git show " .. choice .. ":" .. currentFile)
		local bufferPathToReturn = vim.api.nvim_get_current_buf()

		vim.cmd("vsp | enew")
		local newBuf = vim.api.nvim_get_current_buf()
		vim.api.nvim_buf_set_lines(newBuf, 0, -1, false, otherContent)

		vim.cmd("diffthis")
		vim.cmd("wincmd p")
		vim.cmd("diffthis")

		ReturnToBuffer(bufferPathToReturn)
	end
end

return M
