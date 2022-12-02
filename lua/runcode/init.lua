local M = {}

local parser = require('runcode.parser')
local buffer = require('runcode.buffer')
local write = require('runcode.write')
local timer = require('runcode.timer')

M.config = {
    commands = {
        ocaml = "ocaml %",
        typescript = "ts-node %",
        javascript = "node %",
        go = "go run %",
        php = "php %",
        python = "python3 %",
        lua = "lua %",
        c = "gcc % -o #@ && #@",
        rust = "rustc % -o #@ && #@"
    }
}

M.setup = function(cmd)
    M.config.commands = vim.tbl_extend(
        "force", M.config.commands, cmd
    )
end

M.open = function(dir)

    dir = dir or "horizontal"
    timer.start()

    local output = {}
    local error = false

    vim.fn.jobstart(parser.get(M.config), {
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
