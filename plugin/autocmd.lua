nvim.create_autocmd("FileType", {
    pattern = "RunCode",
    callback = function()
        vim.keymap.set("n", "<cr>", function()
            vim.api.nvim_command("q")
        end, { buffer = 0 })

    end
})
