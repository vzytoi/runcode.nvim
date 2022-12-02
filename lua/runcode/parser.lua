local M = {}

M.parse = function(cmd)

    local dump_path = vim.fn.stdpath('data') .. "/runcode/"
    local _ = pcall(vim.fn.mkdir, dump_path)

    local parsing_table = {
        ["%"] = vim.fn.expand('%:p'),
        ["#"] = dump_path,
        ["@"] = vim.fn.expand('%:t:r'),
    }

    for sub, rep in pairs(parsing_table) do
        cmd = string.gsub(cmd, "%" .. sub, rep)
    end

    return cmd
end

M.get = function(config, method)
    local ft = vim.bo.filetype
    local cmd

    local has = function(tbl, el)
        return vim.tbl_contains(
            vim.tbl_keys(tbl), el
        )
    end

    if method then
        cmd = config[method][ft]
    else
        if has(config.interpret, ft) then
            cmd = config.interpret[ft]
        elseif has(config.compile, ft) then
            cmd = config.compile[ft]
        end
    end

    if not cmd then
        return
    end

    return M.parse(cmd)
end

return M
