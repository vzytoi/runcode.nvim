local M = {}

-- si un projet est détecté alors project_name
-- représentera le nom du projet courrant car il est
-- nécéssaire pour certains language de connaître le nom
-- du projet pour pouvoir l'éxecuter (ocaml par example).

M.parse = function(cmd, project_name)

    local dump_path = vim.fn.stdpath('data') .. "/runcode/"
    local _ = pcall(vim.fn.mkdir, dump_path)

    local parsing_table = {
        ["%"] = vim.fn.expand('%:p'),
        ["#"] = dump_path,
        ["@"] = vim.fn.expand('%:t:r'),
        ["^"] = project_name,
        ["&"] = vim.fn.expand('%:p:h')
    }

    for sub, rep in pairs(parsing_table) do
        cmd = string.gsub(cmd, "%" .. sub, rep)
    end

    return cmd
end

M.get = function(config, method, project_name)
    local ft = vim.bo.filetype
    local cmd

    local has = function(tbl, el)
        return vim.tbl_contains(
            vim.tbl_keys(tbl), el
        )
    end

    -- ordre de priorité:
    -- (*) Méthode imposée par l'utilisateur
    -- (*) Detection de projet
    -- (*) Interpretation (pas besoins de dump folder)
    -- (*) Compilation

    if method then
        cmd = config[method][ft]
    elseif project_name and config.project[ft] then
        cmd = config.project[ft]
    elseif has(config.interpret, ft) then
        cmd = config.interpret[ft]
    elseif has(config.compile, ft) then
        cmd = config.compile[ft]
    end

    -- si aucune commande n'est trouvée,
    -- alors on ne fait rien
    -- TODO: notification

    if not cmd then
        return
    end

    return M.parse(cmd, project_name)
end

return M
