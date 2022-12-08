vim.api.nvim_create_autocmd("FileType", {
    pattern = "RunCode",
    callback = function()

        vim.keymap.set("n", "<cr>", function()
            local from = vim.api.nvim_buf_get_var(0, "From")

            vim.api.nvim_command("q")

            vim.api.nvim_set_current_win(
                vim.fn.bufwinid(from)
            )
        end, { buffer = 0 })
    end
})
