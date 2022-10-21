local M = {}

function M.settings()
    local rt = require("rust-tools")

    local rust_tools_settings = {
        server = {
            on_attach = function(_, bufnr)
                -- Hover actions
                vim.keymap.set("n", "<Leader>h", rt.hover_actions.hover_actions, { buffer = bufnr })
                -- Code action groups
                vim.keymap.set("n", "<Leader>q", rt.code_action_group.code_action_group, { buffer = bufnr })
            end,
        },
    }
    rt.setup(rust_tools_settings)

    local settings = {}
    return settings
end

function M.filetypes()
    local filetypes = {'rs'}
    return filetypes
end

return M
