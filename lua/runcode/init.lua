local M = {}

local parser = require('runcode.parser')
local buffer = require('runcode.buffer')
local write = require('runcode.write')
local timer = require('runcode.timer')
local project = require('runcode.project')
local commands = require('runcode.commands')
local loader = require('runcode.loader')

M.setup = function(cmd)

    cmd = cmd or {}

    local compile = cmd.Compile or {}
    local interpret = cmd.Interpret or {}
    local projects = cmd.Project or {}

    commands.compile = vim.tbl_extend(
        "force", commands.Compile, compile
    )

    commands.interpret = vim.tbl_extend(
        "force", commands.Interpret, interpret
    )

    commands.interpret = vim.tbl_extend(
        "force", commands.Project, projects
    )
end

M.run = function(tbl)

    tbl = tbl or {}

    local dir = tbl.dir or "horizontal"

    local name = project.get()
    local cmd, method = parser.get(commands, tbl.method, name)

    if not cmd then
        return
    end

    vim.api.nvim_command("silent w")
    local win = loader.create("Loading...")

    local output = {}
    local error = false

    timer.start()

    vim.fn.jobstart(cmd, {
        stdout_buffered = true,
        on_stdout = function(_, data)
            if data then
                table.insert(output, data)
            end
        end,
        on_stderr = function(_, data)
            if #vim.fn.join(data) > 0 then
                error = true
            end

            table.insert(output, data)
        end,
        on_exit = function()
            local time = timer.stop()
            local bufnr = buffer.prepare(dir)


            loader.close(win)

            write.infos(time, method, bufnr)
            write.output_is(error, bufnr)

            write.endl(-1, bufnr)

            write.table(output, bufnr)

            buffer.resize(dir, bufnr)

        end
    })


end


return M
