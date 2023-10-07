local M = {}

local locations = require('recall.locations')
local core = require('recall')


local insert_entered = 0

M.insert_leave_callback = function(ev)
    local ft = vim.bo[ev.buf].filetype
    if vim.tbl_contains(core.config.ignore_filetypes, ft) then
        return
    end
    insert_entered = vim.loop.now()
end

M.insert_enter_callback = function(ev)
    local ft = vim.bo[ev.buf].filetype
    if vim.tbl_contains(core.config.ignore_filetypes, ft) then
        return
    end

    if core.config.sources.insert.min_time > 0 and (vim.loop.now() - insert_entered) <= core.config.sources.insert.min_time then
        return
    end

    locations.mark_current_location()
end

return M
