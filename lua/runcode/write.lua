local M = {}


M.clear = function(nr)
    nvim.buf_set_lines(nr, 0, -1, true, {})
end

M.lines = function(nr, data, l, hl)

    data = (type(data) == "table" and data or { data })

    nvim.buf_set_lines(nr, l, l, true, data)

    if hl then
        nvim.buf_add_highlight(nr, -1, hl, l, 0, -1)
    end
end


M.endl = function(l)
    nvim.buf_set_lines(vim.api.nvim_get_current_buf(), l, l, true, { "" })
end


M.infos = function(timer)
    local bufnr = vim.api.nvim_get_current_buf()
    local origin_bufnr = vim.api.nvim_buf_get_var(bufnr, "From")

    M.lines(
        bufnr,
        string.format(
            "In: %s %s | Lines: %s",
            timer.time, timer.unit,
            nvim.buf_line_count(origin_bufnr)
        ),
        0,
        "RunCodeInfo"
    )
end

M.output_is = function(error)
    local bufnr = vim.api.nvim_get_current_buf()

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

M.table = function(tbl)
    local bufnr = vim.api.nvim_get_current_buf()

    for _, data in ipairs(tbl) do
        if not vim.tbl_isempty(data) then
            M.lines(bufnr, data, -1)
        end
    end
end

return M
