return {
    'nvim-telescope/telescope.nvim',
    dependencies = {
        'nvim-lua/plenary.nvim',
        'nvim-telescope/telescope-ui-select.nvim',
    },
    config = function()
        local actions = require('telescope.actions')
        require('telescope').setup({
            defaults = {
                mappings = {
                    i = {
                        ['<C-j>'] = actions.move_selection_next,
                        ['<C-k>'] = actions.move_selection_previous,
                        ['<C-h>'] = actions.preview_scrolling_up,
                        ['<C-l>'] = actions.preview_scrolling_down,
                    },
                    n = {
                        ['<C-j>'] = actions.move_selection_next,
                        ['<C-k>'] = actions.move_selection_previous,
                        ['<C-h>'] = actions.preview_scrolling_up,
                        ['<C-l>'] = actions.preview_scrolling_down,
                    },
                },
            },
            extensions = {
                ['ui-select'] = {
                    require('telescope.themes').get_dropdown({}),
                },
            },
        })
        require('telescope').load_extension('ui-select')
    end,
}
