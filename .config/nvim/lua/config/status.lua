local M = {}

function M.setup()
    local lualine = {
        options = {
            icons_enabled = true,
            theme = 'catppuccin',
            component_separators = { left = '', right = '' },
            section_separators = { left = '', right = '' },
            disabled_filetypes = {
                statusline = {},
                winbar = {},
            },
            ignore_focus = {},
            always_divide_middle = true,
            globalstatus = true,
            refresh = {
                statusline = 1000,
                tabline = 1000,
                winbar = 1000,
            }
        },
        sections = {
            lualine_a = { 'mode' },
            lualine_b = { 'diagnostics' },
            lualine_x = { 'filename' },
            --lualine_x = {'encoding', 'fileformat', 'filetype'},
            lualine_c = { 'buffers' },
            lualine_y = {}, --'progress'--},
            lualine_z = {} --'location'}
        },
        inactive_sections = {
            lualine_a = {},
            lualine_b = {},
            lualine_c = { 'filename' },
            lualine_x = { 'location' },
            lualine_y = {},
            lualine_z = {}
        }
    }
    local incline = {
        render = function (props)
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
        window = {
            placement = {
                vertical = 'top',
                horizontal = 'right',
            },
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
