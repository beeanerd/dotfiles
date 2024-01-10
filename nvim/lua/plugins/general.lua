return {
    -- Detect tabstop and shiftwidth automatically
    'tpope/vim-sleuth',
    { 'folke/which-key.nvim',  opts = {} },
    {
        -- Set lualine as statusline
        'nvim-lualine/lualine.nvim',
        dependencies = {
            "nvim-tree/nvim-web-devicons",
            "meuter/lualine-so-fancy.nvim",
        },
        config = function()
            local function diff_source()
                local gitsigns = vim.b.gitsigns_status_dict
                if gitsigns then
                    return {
                        added = gitsigns.added,
                        modified = gitsigns.changed,
                        removed = gitsigns.removed
                    }
                end
            end

            local custom_catppuccin = require('lualine.themes.catppuccin')

            custom_catppuccin.inactive.c.bg = '#1e1e2e'
            custom_catppuccin.normal.c.bg = '#1e1e2e'

            require('lualine').setup {
                options = {
                    icons_enabled = true,
                    theme = custom_catppuccin,
                    component_separators = { left = '', right = '' }, -- Box-like separators for inner sections
                    section_separators = { left = '', right = '' },
                },
                sections = {
                    lualine_a = { 'mode' }, -- Displays Neovim's mode
                    lualine_b = { 'fancy_lsp_servers' }, -- Current file name
                    lualine_c = { { 'b:gitsigns_head', icon = '' }, { 'diff', source = diff_source }, }, -- , 'diff' }, -- Shows git branch and diff
                    lualine_x = { 'diagnostics' }, -- Diagnostics (e.g., LSP)
                    lualine_y = { 'progress' }, -- Progress through the current file
                    lualine_z = { 'filename' }
                },
                inactive_sections = {
                },
                tabline = {},
                extensions = { 'quickfix', 'fugitive' }
            }
        end,
    },
    -- "gc" to comment visual regions/lines
    { 'numToStr/Comment.nvim', opts = {} },

}
