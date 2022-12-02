local M = {}

M.ocaml = function()

    local names = {
        "dune-workspace", "dune-project"
    }

    local find = false

    for _, v in ipairs(names) do
        if #vim.fs.find(v, { upward = true }) > 0 then
            find = true
        end
    end

    if not find then
        return
    end

    local grep = vim.split(
        vim.fn.system("grep public_name **/dune")
        , " ")

    local i = -1

    for k, v in ipairs(grep) do
        if string.find(v, 'public_name') then
            i = k + 1
        end
    end

    local name = grep[i]:gsub('%)', '')

    return name
end

M.get = function()
    local filetype = vim.bo.filetype

    if M[filetype] then
        return M[filetype]()
    end

    return nil
end

return M
