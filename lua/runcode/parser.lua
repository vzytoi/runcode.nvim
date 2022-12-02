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

M.get = function(config)
    local ft = vim.bo.filetype

    return M.parse(config.commands[ft])
end

return M
