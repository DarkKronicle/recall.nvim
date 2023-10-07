local defaults = require('recall.defaults')
local locations = require('recall.locations')
local insert = require('recall.sources.insert')
local cursorhold = require('recall.sources.cursorhold')

local core = require('recall')


local M = {}


M.setup_all = function (user_config)

    core.config = vim.tbl_deep_extend('force', defaults, user_config or {})


    vim.api.nvim_create_autocmd({ 'InsertEnter' }, {
        group = vim.api.nvim_create_augroup('recall_enter_reset', {}),
        callback = function ()
            if core.config.reset_index_on_insert then
                locations.reset_index()
            end
        end,
    })


    vim.api.nvim_create_autocmd({ 'InsertLeavePre' }, {
        group = vim.api.nvim_create_augroup('recall_leave_insert_location', {}),
        callback = insert.insert_leave_callback,
    })

    vim.api.nvim_create_autocmd({ 'InsertEnter' }, {
        group = vim.api.nvim_create_augroup('recall_enter_insert_location', {}),
        callback = insert.insert_enter_callback,
    })

    if core.config.sources.cursor_hold.enabled then
        vim.api.nvim_create_autocmd({ 'CursorHold' }, {
            group = vim.api.nvim_create_augroup('recall_cursor_hold', {}),
            callback = cursorhold.cursor_hold_callback,
        })
    end

end


return M
