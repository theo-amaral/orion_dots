local api = vim.api
local fn = vim.fn

api.nvim_create_autocmd("FileType", {
    pattern = "rust",
    callback = function(ev)
        local current_file = api.nvim_buf_get_name(ev.buf)
        local project_dir = fn.fnamemodify(current_file, ":h")

        vim.keymap.set("n", "<leader>a", "", { desc = "Rust" })
        vim.keymap.set("n", "<leader>ac", function()
            Snacks.terminal("cargo run -q", { cwd = project_dir, auto_close = false })
        end, { desc = "Compile and run" })
    end,
})

return {
    {
        "neovim/nvim-lspconfig",
        opts = {
            servers = {
                rust_analyzer = {
                    settings = {
                        ["rust-analyzer"] = {
                            checkOnSave = {
                                command = "clippy",
                                allTargets = true,
                            },
                        },
                    },
                },
            },
        },
    },
}
