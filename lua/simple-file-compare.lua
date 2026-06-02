local M = {}

local modes = {
	vimUiSelect = "vimUiSelect",
	snacks = "snacks",
	miniPick = "miniPick",
}

local config = {
	mode = modes.snacks,
}

M.setup = function(user_config)
	user_config = user_config or {}
	config = vim.tbl_deep_extend("force", config, user_config) -- merge both to be config, but with the correct values

	if not modes[config.mode] then
		error("Invalid mode")
	end

	vim.api.nvim_create_user_command("FileCompareOpen", function()
		Compare()
	end, {})
end

function Compare()
	local outputTable = vim.fn.systemlist("git branch")

	if config.mode == modes.snacks then
		local snacks = require("snacks")

		snacks.picker.select(outputTable, {
			prompt = "Select Branch",
		}, function(choice)
			ChoiceLogic(choice)
		end)
	end

	if config.mode == modes.vimUiSelect then
		vim.ui.select(outputTable, {
			prompt = "Select Branch",
		}, function(choice)
			if choice then
				ChoiceLogic(choice)
			end
		end)
	end

	if config.mode == modes.miniPick then
		local miniPick = require("mini.pick")
		miniPick.setup()
		local choice = miniPick.start({
			source = {
				name = "Select Branch",
				items = outputTable,
			},
		})
		ChoiceLogic(choice)
	end
end

function ReturnToBuffer(bufferPathToReturn)
	vim.api.nvim_create_user_command("FileCompareClose", function()
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
		local currentFile = vim.fs.normalize(vim.fn.bufname("%"))
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
