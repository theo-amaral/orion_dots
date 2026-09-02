local group = vim.api.nvim_create_augroup("cppconfig", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
    pattern = "cpp",
    group = group,
    callback = function(ev)
        local opts = { buffer = ev.buf, silent = true }
        local current_file = vim.api.nvim_buf_get_name(ev.buf)
        local project_dir = vim.fn.fnamemodify(current_file, ":h")
        local cmd_str = string.format("clang++ *.cpp -o main")

        vim.o.tabstop = 4
        vim.o.expandtab = true
        vim.o.softtabstop = 4
        vim.o.shiftwidth = 4

        vim.keymap.set("n", "<leader>a", "", vim.tbl_extend("force", opts, { desc = "C++" }))
        vim.keymap.set("n", "<leader>ac", function()
            Snacks.terminal({ "sh", "-c", cmd_str }, { cwd = project_dir })
        end, vim.tbl_extend("force", opts, { desc = "C++: Compilar" }))
        vim.keymap.set("n", "<leader>ar", function()
            Snacks.terminal({ "sh", "-c", cmd_str }, { cwd = project_dir })
            Snacks.terminal({ "sh", "-c", "./main" }, { cwd = project_dir, interactive = true, auto_close = false })
        end, vim.tbl_extend("force", opts, { desc = "C++: Rodar" }))
    end,
})

return {}
