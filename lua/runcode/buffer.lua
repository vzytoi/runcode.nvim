local M = {}

M.set_buffer_opts = function()

    vim.bo.bufhidden = "delete"
    vim.bo.buftype = "nofile"
    vim.bo.swapfile = false
    vim.bo.buflisted = false
    vim.wo.winfixheight = true
    vim.wo.number = false
    vim.wo.relativenumber = false
    vim.bo.filetype = "RunCode"
    vim.wo.fillchars = 'eob: '
    vim.wo.wrap = true

    vim.cmd [[
        hi RunCodeOk guifg=#83c979
        hi RunCodeError guifg=#FF0000
        hi RunCodeInfo guifg=#4ec4e6
        setlocal winhighlight=Normal:RunCodeNormal,EndOfBuffer:RunCodeNormal
    ]]
end

M.is_open = function(name)
    local bufs = vim.tbl_filter(function(nr)
        return vim.api.nvim_buf_is_loaded(nr)
    end, vim.api.nvim_list_bufs())

    for _, buf in ipairs(bufs) do
        if vim.bo.filetype == name then
            return buf
        end
    end

    return false
end

M.get_direction = function()
    local win = vim.api.nvim_get_current_buf()

    if vim.go.columns == vim.fn.winwidth(win) then
        return "horizontal"
    elseif vim.fn.winheight(win) + vim.go.cmdheight + 2 == vim.go.lines then
        return "vertical"
    end

    return "tab"
end


M.direction = function()
    local win = vim.api.nvim_get_current_win()

    if vim.go.columns == vim.fn.winwidth(win) then
        return "horizontal"
    elseif vim.fn.winheight(win) + vim.go.cmdheight + 2 == vim.go.lines then
        return "vertical"
    end

    return "tab"
end

M.size = function()
    local bufnr = vim.api.nvim_get_current_buf()
    local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)

    if M.direction() == "horizontal" then
        return #lines
    else
        local m

        for _, v in ipairs(lines) do
            if not m or m < #v then
                m = #v
            end
        end

        return m
    end
end

M.resize = function(dir)

    if vim.bo.filetype ~= "RunCode" then
        return
    end

    local win = vim.api.nvim_get_current_win()
    local size = M.size()

    vim.api[
        "nvim_win_set_" ..
            (dir == "vertical" and "width" or "height")
        ](win, size + 5)

end

M.create_link = function(nra, nrb)
    vim.api.nvim_buf_set_var(nra, "To", nrb)
    vim.api.nvim_buf_set_var(nrb, "From", nra)
end

M.prepare = function(dir)
    local nra = vim.api.nvim_get_current_buf()

    local commands = {
        horizontal = "bo new",
        vertical = "vnew",
        tab = "tabnew"
    }

    vim.api.nvim_command(commands[dir])
    local nrb = vim.api.nvim_get_current_buf()

    M.set_buffer_opts()
    M.create_link(nra, nrb)
end

return M
