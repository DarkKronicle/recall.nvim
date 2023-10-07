local M = {}

local locations = require('recall.locations')
local core = require('recall')



M.cursor_hold_callback = function(ev)
    local ft = vim.bo[ev.buf].filetype
    if vim.tbl_contains(core.config.ignore_filetypes, ft) then
        return
    end
    locations.mark_current_location()
end


return M
