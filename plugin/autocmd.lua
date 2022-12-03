nvim.create_autocmd("FileType", {
    pattern = "RunCode",
    callback = function()
        vim.g.nmap({ "<cr>", "q" }, function()
            vim.api.nvim_command("q")
        end, { buffer = 0 })
    end
})
