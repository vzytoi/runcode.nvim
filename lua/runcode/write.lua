local M = {}

M.clear = function(nr)
    nvim.buf_set_lines(nr, 0, -1, true, {})
end

M.lines = function(nr, data, l, hl)

    data = (type(data) == "table" and data or { data })

    vim.api.nvim_buf_set_lines(nr, l, l, true, data)

    if hl then
        vim.api.nvim_buf_add_highlight(nr, -1, hl, l, 0, -1)
    end
end


M.endl = function(l, bufnr)
    vim.api.nvim_buf_set_lines(bufnr, l, l, true, { "" })
end


M.infos = function(timer, method, bufnr)
    local origin = vim.api.nvim_get_current_buf()

    if bufnr == origin then
        origin = vim.api.nvim_buf_get_var(bufnr, "From")
    end

    M.lines(
        bufnr,
        string.format(
            "In: %s %s | Lines: %s | Method: %s",
            timer.time, timer.unit,
            vim.api.nvim_buf_line_count(origin),
            method
        ),
        0,
        "RunCodeInfo"
    )
end

M.output_is = function(error, bufnr)

    local filename = vim.fn.fnamemodify(vim.fn.bufname(
        vim.api.nvim_buf_get_var(bufnr, "From")
    ), ':t')

    M.lines(
        bufnr,
        "=> Output of: " .. filename,
        2,
        "RunCode" .. (error and "Error" or "Ok")
    )

end

M.table = function(tbl, bufnr)
    for _, data in ipairs(tbl) do
        if not vim.tbl_isempty(data) then
            M.lines(bufnr, data, -1)
        end
    end
end

return M
