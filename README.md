# recall.nvim

A *neovim* jumplist upgrade to quickly navigate your recent cursor positions.

## What does it do?

> Note: This plugin is currently in beta. It works, but there may be bugs and it doesn't 
> have all the features I want to implement yet.
> Please submit any issues or feature requests to the issue tracker! Pull requests are welcome!

recall.nvim was designed as an alternative to the default jump list within neovim.
This plugin is completely separate from the jump list and is much more customizable.
By default, locations will only be stored when leaving insert mode and if there is
a previous location stored nearby, it will update that one. Recall will also remember
which window an edit was made in, and will attempt to refocus that window if possible.

A customizable amount of locations can be stored. A pointer will then be set to your
current point in that array so you can traverse forward and backwards through your edits.

## Installation

[lazy.nvim](https://github.com/folke/lazy.nvim)
```lua
{
    'DarkKronicle/recall.nvim',
    event = 'VeryLazy',
    keys = {
        -- NOTE: Keys are optional, but none are defined by default
        {
            '<C-i>',
            function ()
                require('recall').jump_backwards()
            end,
            desc = 'Recall backwards through history'
        },
        {
            '<C-o>',
            function ()
                require('recall').jump_forwards()
            end,
            desc = 'Recall forwards through history'
        },
    },
    opts = {
        -- See configuration below
    }
}
```


## Configuration

```lua
default_config = {
    -- the number of locations that are stored, 
    -- can be -1 for infinite
    max_stored = 5, 

    -- the amount of lines of seperation from a 
    -- previous location to create a new one
    surrounding_lines = 15, 

    -- If there is another location nearby (< surround_lines), 
    -- should it's location be updated?
    update_surrounding = true, 

    -- If false, when a window is deleted the plugin will
    -- attempt to map the stored locations to a valid window.
    -- If true, the stored locations will be deleted.
    remove_deleted_windows = true, 

    -- If true, when going into insert mode, the 
    -- current index in the list will be reset.
    -- (i.e. next time you go to next location it will
    -- be back at the most recent)
    reset_index_on_insert = true,

    -- Jump to saved col. If false, it will go to first 
    -- non-whitespace character on the line.
    jump_to_col = false,

    -- Filetypes to ignore
    ignore_filetypes = { 
        'neo-tree', 
        'telescope' 
    },

    -- Different ways of adding locations
    sources = {
        -- Add location on insert leave
        insert = {
            enabled = true,

            -- Time (in ms) that insert mode has to be active, 
            -- so when leaving the current location will be added.
            min_time = -1,
        },
        -- Use CursorHold event to add location
        -- This one probably won't work too well because 
        -- it's hard to set delay. Will probably have to
        -- find a better solution.
        -- See :h CursorHold
        -- The delay for this is `vim.opt.updatetime`
        cursor_hold = {
            enabled = false,
        }
    },
}
```

### Keybindings

To go backwards use the function

```lua
require('recall').jump_backwards()
```

To go forwards use the function


```lua
require('recall').jump_forwards()
```

## TODO

- [ ] Introduce something like the tag stack to keep tracks of what functions were worked on
- [ ] More ways to add a location. Some lua function, maybe integrations through other plugins.
- [ ] Implement a telescope extension.
- [ ] Update location if file is updated (similar to how marks work).
