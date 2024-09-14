local M = {}

function M.close_buffer_with_confirmation()
	local unsaved_changes = vim.fn.getbufvar(vim.fn.bufnr(''), '&modified')
	if unsaved_changes == 1 then
		local choice = vim.fn.confirm('There are unsaved changes. Close without saving?', '&Yes\n&No', 1)
		if choice == 2 then
			return
		end
	end
	vim.cmd(':bdelete')
end

return M
