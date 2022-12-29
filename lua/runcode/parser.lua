local M = {}

local project = require('runcode.project')

-- si un projet est détecté alors project_name
-- représentera le nom du projet courrant car il est
-- nécéssaire pour certains language de connaître le nom
-- du projet pour pouvoir l'éxecuter (ocaml par example).

M.parse = function(cmd, bufnr)
    bufnr = bufnr or vim.api.nvim_get_current_buf()

    local dump_path = vim.fn.stdpath('data') .. "/runcode/"
    local _ = pcall(vim.fn.mkdir, dump_path)

    -- print(vim.api.nvim_buf_get_name(bufnr))
    -- print('parse sur ' .. bufnr)

    local parsing_table = {
        ["@"] = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(bufnr), ":t:r"),
        ["%"] = vim.api.nvim_buf_get_name(bufnr),
        ["#"] = dump_path,
        ["^"] = project.get(),
    }

    for sub, rep in pairs(parsing_table) do
        cmd = string.gsub(cmd, "%" .. sub, rep)
    end

    return cmd
end

M.get = function(commands, method, bufnr)
    bufnr = bufnr or vim.api.nvim_get_current_buf()

    local ft = vim.fn.getbufvar(bufnr, '&filetype')

    -- si j'essaye d'executer un output runcode,
    -- je réexectue le fichier source à la place
    if ft == "RunCode" then
        return M.get(commands, method, vim.api.nvim_buf_get_var(bufnr, "From"))
    end

    local used
    local cmd

    local has = function(tbl, el)
        return vim.tbl_contains(
            vim.tbl_keys(tbl), el
        )
    end

    -- ordre de priorité:
    -- (*) Méthode impose par l'utilisateur
    -- (*) Detection de projet
    -- (*) Interpretation (pas besoins de dump folder)
    -- (*) Compilation

    if method then
        cmd = commands[method][ft]
        used = method
    elseif project.get() and commands.Project[ft] then
        cmd = commands.Project[ft]
        used = "Project"
    elseif has(commands.Interpret, ft) then
        cmd = commands.Interpret[ft]
        used = "Interpret"
    elseif has(commands.Compile, ft) then
        cmd = commands.Compile[ft]
        used = "Compile"
    end

    -- si aucune commande n'est trouvée,
    -- alors on ne fait rien
    -- TODO: notification
    if not cmd then
        vim.api.nvim_echo({ { "Unsopported filetype/method", "ErrorMsg" } }, true, {})
        return nil
    end


    return M.parse(cmd, bufnr), used
end

return M
