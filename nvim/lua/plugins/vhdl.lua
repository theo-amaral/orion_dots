vim.api.nvim_create_autocmd("FileType", {
    pattern = "vhdl",
    callback = function(ev)
        local current_file = vim.api.nvim_buf_get_name(ev.buf)
        local filename = vim.fn.expand("%:t:r")
        local project_dir = vim.fn.fnamemodify(current_file, ":h")

        vim.o.tabstop = 4
        vim.o.expandtab = true
        vim.o.softtabstop = 4
        vim.o.shiftwidth = 4

        local opts = { buffer = ev.buf, silent = true }

        vim.keymap.set("n", "<leader>a", "", vim.tbl_extend("force", opts, { desc = "VHDL" }))
        vim.keymap.set("n", "<leader>ac", function()
            vim.ui.input({ prompt = "Enter top-entity:", default = filename }, function(input)
                Snacks.terminal.open(
                    "ghdl -a *.vhd; ghdl -e " .. input .. "; ghdl -r " .. input .. " --vcd=saida.vcd",
                    { cwd = project_dir, auto_close = false }
                )
            end)
        end, vim.tbl_extend("force", opts, { desc = "VHDL: compile and run" }))
    end,
})
