local M = {
    config = {}
}

M.setup = function (opts)
    require('recall.setup').setup_all(opts)
    M.jump_backwards = require('recall.locations').jump_backwards
    M.jump_forwards = require('recall.locations').jump_forwards
    M.jump_relative = require('recall.locations').jump_relative



    vim.keymap.set('n', '<C-i>', M.jump_backwards)
    vim.keymap.set('n', '<C-o>', M.jump_forwards)


end


return M

