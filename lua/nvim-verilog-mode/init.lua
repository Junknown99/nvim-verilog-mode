local M = {}

  M.setup = function()
    local verilog_config = {
        ["verilog-auto-arg-format"]        = "'single",
        ["verilog-auto-arg-sort"]          = "nil",
        ["verilog-auto-indent-on-newline"] = "nil",
        ["verilog-auto-inst-param-value"]  = "t",
    }

    local function run_verilog_emacs()
        if vim.fn.executable('emacs') == 0 then
            vim.notify("Error: 'emacs' not found in PATH.", vim.log.levels.ERROR)
            return
        end

        vim.cmd('write')

        local file_path = vim.fn.expand('%:p')
        local lisp_code = "(progn"

        for var, val in pairs(verilog_config) do
            lisp_code = lisp_code .. string.format(" (setq %s %s)", var, val)
        end
        lisp_code = lisp_code .. ")"

        local cmd = string.format(
            'emacs --batch --no-site-file --eval "%s" "%s" -f verilog-batch-auto',
            lisp_code:gsub('"', '\\"'),
            file_path
        )

        vim.notify("Running Verilog-Mode...", vim.log.levels.INFO)
        local output = vim.fn.system(cmd)

        if vim.v.shell_error ~= 0 then
            vim.notify("Verilog-Mode Error:\n" .. output, vim.log.levels.ERROR)
        else
            vim.cmd('edit!')
            vim.notify("Verilog Auto Updated.", vim.log.levels.INFO)
        end
    end

    vim.api.nvim_create_user_command('VerilogAuto', run_verilog_emacs, {})

    vim.api.nvim_create_autocmd("FileType", {
        pattern = {"verilog", "systemverilog"},
        callback = function()
            vim.keymap.set('n', '<A-e>', run_verilog_emacs, { buffer = true, desc = "Run Emacs Verilog-Mode" })
        end,
    })
  end

return M
