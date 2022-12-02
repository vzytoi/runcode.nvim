local M = {}

M.round = function(x, n)
    n = math.pow(10, n or 0)
    x = x * n
    if x >= 0 then x = math.floor(x + 0.5) else x = math.ceil(x - 0.5) end
    return x / n
end


M.start = function()
    M.timer = vim.fn.reltime()
end

M.stop = function()
    local time = vim.fn.reltimefloat(
        vim.fn.reltime(M.timer)
    )

    local sec = time > 1

    return {
        time = sec and M.round(time, 2) or M.round(time * 1000),
        unit = sec and "s" or "ms"
    }
end

return M
