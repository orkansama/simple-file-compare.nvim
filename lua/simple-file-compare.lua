local M = {}

local defaultConfig = {
	telescope = true,
	vimUiSelect = false,
}

M.setup = function(user_config)
	if user_config.vimUiSelect == true then
		defaultConfig.telescope = false
		user_config.telescope = false
	end
	defaultConfig = vim.tbl_deep_extend("force", defaultConfig, user_config or {})
	vim.api.nvim_create_user_command("Test", function()
		Compare(user_config)
	end, {})
end

function Compare(user_config)
	local outputTable = vim.fn.systemlist("git branch")

	if user_config.telescope == true and user.vimUiSelect == true then
		return vim.notify("Cant set telescope and vimUiSelect to true!", 4)
	end

	if user_config.vimUiSelect == true then
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
