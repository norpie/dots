local M = {}

function M.setup()
    local map = require('util').map
    local hop = require('hop')
    local directions = require('hop.hint').HintDirection
    hop.setup()
    map('n', 'H', ':HopWord<CR>', {silent = true})
    --map('n', 'f', function()
    --    hop.hint_char1({ direction = directions.AFTER_CURSOR, current_line_only = true })
    --end, { noremap = false })
    --map('n', 'F', function()
    --    hop.hint_char1({ direction = directions.BEFORE_CURSOR, current_line_only = true })
    --end, { remap = true })
    --map('n', 't', function()
    --    hop.hint_char1({ direction = directions.AFTER_CURSOR, current_line_only = true, hint_offset = -1 })
    --end, { remap = true })
    --map('n', 'T', function()
    --    hop.hint_char1({ direction = directions.BEFORE_CURSOR, current_line_only = true, hint_offset = 1 })
    --end, { remap = true })
end

return M
