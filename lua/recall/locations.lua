local M = {}
local core = require('recall')


local remembered = {}
local last_index = 1


M.validate_location = function (loc)
    local remove_deleted_windows = core.config.remove_deleted_windows
    local remove_deleted_buffers = core.config.remove_deleted_buffers

    local wins = vim.api.nvim_list_wins()
    local bufs = vim.api.nvim_list_bufs()

    local found_win = false
    local found_buf = false


    for _, win in ipairs(wins) do
        if win == loc.win then
            found_win = true
            break
        end
    end
    if not found_win then
        if remove_deleted_windows then
            return nil
        end
        -- TODO: Optimize. Shouldn't be *that* bad since rarely someone will jump through 50+ edits ago.
        local last_win = nil
        for _, l_loc in ipairs(remembered) do
            for _, l_win in ipairs(wins) do
                if l_win == l_loc.win then
                    last_win = l_win
                    break
                end
            end
        end
        if last_win ~= nil then
            last_win = wins[1]
        end
        loc.win = last_win
    end

    for _, buf in ipairs(bufs) do
        if buf == loc.buf then
            found_buf = true
            break
        end
    end
    if not found_buf then
        return nil
    end

    return loc
end


M.jump_to_remembered = function (loc)
    -- Should already be validated
    vim.api.nvim_set_current_win(loc.win)
    vim.api.nvim_set_current_buf(loc.buf)
    if core.config.jump_to_col then
        vim.api.nvim_win_set_cursor(loc.win, {loc.row, loc.col})
    else
        local line = vim.api.nvim_buf_get_lines(loc.buf, loc.row - 1, loc.row, false)[1]
        local start_col = line:match("^%s*"):len()
        vim.api.nvim_win_set_cursor(loc.win, {loc.row, start_col})
    end

end


M.jump_relative = function (direction)
    if #remembered == 0 then
        return
    end
    local current_win = vim.api.nvim_get_current_win()
    local current_buf = vim.api.nvim_get_current_buf()
    local current_row, _ = unpack(vim.api.nvim_win_get_cursor(0))
    local to_delete = {}
    local index = last_index
    for i = 1, #remembered do
        index = (index + direction)
        if index <= 0 then
            index = #remembered
        elseif index > #remembered then
            index = 1
        end
        local val = remembered[index]
        if val.win ~= current_win or val.buf ~= current_buf or math.abs(val.row - current_row) > core.config.surrounding_lines then
            local validated = M.validate_location(val)
            if validated == nil then
                table.insert(to_delete, -1, index)
            else
                M.jump_to_remembered(val)
                last_index =index 
                break
            end
        end
    end
    for _, delete_index in ipairs(to_delete) do
        table.remove(remembered, delete_index)
    end
end


M.mark_location = function (win, buf, row, col)
    local loc = {
        win = win,
        buf = buf,
        row = row,
        col = col,
    }
    table.insert(remembered, 1, loc)
    local max = core.config.max_stored
    if max ~= nil and max > 0 then
        for i = #remembered + 1, max do
            table.remove(remembered, i)
        end
    end
    last_index = 1
end


M.mark_current_location = function ()
    local row, col = unpack(vim.api.nvim_win_get_cursor(0))
    local win = vim.api.nvim_get_current_win()
    local buf = vim.api.nvim_get_current_buf()

    for _, location in ipairs(remembered) do
        if #remembered > 0 and location.win == win and location.buf == buf and math.abs(location.row - row) <= core.config.surrounding_lines then
            -- We're too close to a mark, so just skip it, but might as well update it so it's less jarring
            if core.config.update_surrounding then
                location.row = row
                location.col = col
            end
            return
        end
    end
    M.mark_location(
        win,
        buf,
        row,
        col
    )
end

M.reset_index = function ()
    last_index = 1
end


M.jump_backwards = function ()
    M.jump_relative(1)
end


M.jump_forwards = function ()
    M.jump_relative(-1)
end


return M
