local config = {
    max_stored = 5,
    surrounding_lines = 15,
    remove_deleted_windows = true,
    reset_index_on_insert = true,
    jump_to_col = false,
    ignore_filetypes = { 'neo-tree', 'telescope' },
    update_surrounding = true,
    sources = {
        insert = {
            enabled = true,
            min_time = -1,
        },
        cursor_hold = {
            enabled = false,
        }
    },
}

return config
