nvim.create_autocmd("FileType", {
    pattern = "RunCode",
    callback = function()
        vim.g.nmap({ "<cr>", "q" }, function()
            u.fun.close(vim.fn.bufnr())
        end, { buffer = 0 })
    end
})
