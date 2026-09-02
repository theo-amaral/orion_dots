local api = vim.api
local fn = vim.fn

local group = api.nvim_create_augroup("ArduinoConfig", { clear = true })

local function split(input)
    local t = {}
    for str in string.gmatch(input, "[%w%p]+") do
        table.insert(t, str)
    end
    return t
end

-- Função segura para aguardar o Neovim terminar o ciclo atual e evitar o erro E492
local function safe_lsp_restart()
    vim.schedule(function()
        pcall(function()
            vim.cmd("LspRestart")
        end)
    end)
end

api.nvim_create_autocmd("FileType", {
    pattern = "arduino",
    group = group,
    callback = function(ev)
        local current_file = api.nvim_buf_get_name(ev.buf)
        local project_dir = fn.fnamemodify(current_file, ":h")
        local yaml_path = project_dir .. "/sketch.yaml"

        vim.o.tabstop = 4
        vim.o.expandtab = true
        vim.o.softtabstop = 4
        vim.o.shiftwidth = 4

        if fn.filereadable(yaml_path) == 0 then
            vim.notify("Arduino: Configurando projeto novo...", vim.log.levels.INFO)

            local script_output = vim.system({ "/home/theo/.config/scripts/arduino_board" }, { text = true })
                :wait().stdout
            local divided_output = split(script_output)
            local port, fbqn = divided_output[1], divided_output[2]
            local cmd = string.format("arduino-cli board attach -b %s -p %s '%s'", fbqn, port, project_dir)
            fn.system(cmd)

            vim.notify("Arduino: sketch.yaml criado! Reiniciando LSP...", vim.log.levels.INFO)
            safe_lsp_restart()
        end

        local opts = { buffer = ev.buf, silent = true }

        local function run_arduino(args)
            vim.cmd("write")
            local full_cmd = "arduino-cli " .. args

            if _G.Snacks and _G.Snacks.terminal then
                Snacks.terminal(full_cmd, { cwd = project_dir, interactive = false })
            else
                local safe_cmd = "cd " .. fn.shellescape(project_dir) .. " && " .. full_cmd
                vim.cmd("botright 15split | term " .. safe_cmd)
            end
        end

        vim.keymap.set("n", "<leader>a", "", vim.tbl_extend("force", opts, { desc = "Arduino: Upload" }))
        vim.keymap.set("n", "<leader>ac", function()
            run_arduino("compile .")
        end, vim.tbl_extend("force", opts, { desc = "Arduino: Compilar" }))

        vim.keymap.set("n", "<leader>au", function()
            run_arduino("upload .")
        end, vim.tbl_extend("force", opts, { desc = "Arduino: Upload" }))

        vim.keymap.set("n", "<leader>am", function()
            vim.ui.input({ prompt = "Enter baud rate:", default = "115200" }, function(input)
                Snacks.terminal("arduino-cli monitor --config " .. input, { cwd = project_dir })
            end)
        end, vim.tbl_extend("force", opts, { desc = "Arduino: Monitor" }))

        vim.keymap.set("n", "<leader>aa", function()
            local script_output = vim.system({ "/home/theo/.config/scripts/arduino_board" }, { text = true })
                :wait().stdout
            local divided_output = split(script_output)
            local port, fbqn = divided_output[1], divided_output[2]
            local cmd = string.format("arduino-cli board attach -b %s -p %s '%s'", fbqn, port, project_dir)
            fn.system(cmd)
            vim.notify("Arduino: sketch.yaml criado! Reiniciando LSP...", vim.log.levels.INFO)
            safe_lsp_restart()
        end, vim.tbl_extend("force", opts, { desc = "Arduino: Atualizar scratch.yaml" }))
    end,
})

return {
    "neovim/nvim-lspconfig",
    opts = {
        servers = {
            arduino_language_server = {
                cmd = {
                    "arduino-language-server",
                    "-cli-config",
                    vim.fn.expand("~/.arduino15/arduino-cli.yaml"),
                    "-fqbn",
                    "esp32:esp32:esp32doit-devkit-v1",
                },
            },
        },
    },
}
