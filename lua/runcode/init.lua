local M = {}

local parser = require('runcode.parser')
local buffer = require('runcode.buffer')
local write = require('runcode.write')
local timer = require('runcode.timer')
local project = require('runcode.project')
local commands = require('runcode.commands')

M.setup = function(cmd)

    cmd = cmd or {}

    local compile = cmd.compile or {}
    local interpret = cmd.interpret or {}
    local projects = cmd.project or {}

    commands.compile = vim.tbl_extend(
        "force", commands.compile, compile
    )

    commands.interpret = vim.tbl_extend(
        "force", commands.interpret, interpret
    )

    commands.interpret = vim.tbl_extend(
        "force", commands.project, projects
    )
end

M.run = function(tbl)

    tbl = tbl or {}

    local dir = tbl.dir or "horizontal"

    local name = project.get()
    local cmd = parser.get(commands, tbl.method, name)

    if not cmd then
        return
    end

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

            buffer.prepare(dir)

            write.infos(time)
            write.output_is(error)

            write.endl(-1)

            write.table(output)

            buffer.resize(dir)
        end
    })


end


return M
