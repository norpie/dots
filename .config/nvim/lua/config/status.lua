local M = {}

function M.setup()
    local lualine = {
        options = {
            icons_enabled = true,
            theme = 'auto', -- based on current vim colorscheme
            -- not a big fan of fancy triangle separators
            component_separators = { left = '', right = '' },
            section_separators = { left = '', right = '' },
            disabled_filetypes = {},
            always_divide_middle = true,
        },
        sections = {
            -- left
            lualine_a = { 'mode' },
            lualine_b = { 'branch', 'diff', 'diagnostics' },
            lualine_c = { 'filename' },
            -- right
            lualine_x = { '' },
            lualine_y = { 'filetype' },
            lualine_z = { 'hostname' }
        },
        inactive_sections = {
            lualine_a = { 'filename' },
            lualine_b = {},
            lualine_c = {},
            lualine_x = { 'location' },
            lualine_y = {},
            lualine_z = {}
        },
        tabline = {},
        extensions = {}
    }
    local incline = {
        render = function(props)
            local bufname = vim.api.nvim_buf_get_name(props.buf)
            local res = bufname ~= '' and vim.fn.fnamemodify(bufname, ':t') or '[No Name]'
            if vim.api.nvim_buf_get_option(props.buf, 'modified') then
                res = res .. ' [+]'
            end

            local has_devicons, devicons = pcall(require, 'nvim-web-devicons')
            if has_devicons then
                local icon = devicons.get_icon_by_filetype(vim.bo[props.buf].filetype)
                if icon then
                    res = icon .. ' ' .. res
                end
            end

            return res
        end,
        hide = {
            cursorline = false,
            focused_win = false,
            only_win = true
        },
        window = {
            margin = {
                vertical = 0,
                horizontal = 1,
            },
            winhighlight = {
                active = { Normal = 'CursorLine' },
                inactive = { Normal = 'CursorLine' },
            },
            padding = 2,
        },
    }
    require('lualine').setup(lualine)
    --require('bufferline').setup()
    require('incline').setup(incline)
end

return M
