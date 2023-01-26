local M = {}

local function search(files)
    for _, v in ipairs(files) do
        local path = vim.fs.find(v, { upward = true })

        if #path > 0 then
            return path
        end
    end

    return false
end

M.javascript = function()
    local path = search { "package.json" }

    if not path then
        return
    end

    local data = vim.fn.json_decode(vim.fn.readfile(path[1]))

    if data.main then
        return vim.fs.dirname(path[1]) .. "/" .. data.main
    end

end


M.c = function()

    local fn = vim.fn.expand('%:p')
    local dir = vim.fs.dirname(fn)

    local content = vim.fn.readfile(fn)
    local dep = {}
    local i = 1

    while i <= #content and string.sub(content[i], 1, 1) == "#" do
        local m = string.match(content[i], '#include%s*"(.*)"')

        if m ~= nil then
            m = m:gsub("%.h", ".c")

            dep[#dep + 1] = dir .. "/" .. m
        end

        i = i + 1
    end

    if #dep == 0 then
        return
    end

    return table.concat(dep, " ")
end


M.ocaml = function()

    if not search { "dune-workspace", "dune-project" } then
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
