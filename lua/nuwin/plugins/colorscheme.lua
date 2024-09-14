return {
    {
        "catppuccin/nvim",
        name = "catppuccin",
        priority = 1000, -- make sure to load this before all the other start plugins
        config = function()
            -- Catppuccin custom colors (Optional: these are just example colors)
            local bg = "#1E1E28"
            local bg_dark = "#1A1826"
            local bg_highlight = "#302D41"
            local bg_search = "#F28FAD"
            local bg_visual = "#403D52"
            local fg = "#D9E0EE"
            local fg_dark = "#C3BAC6"
            local fg_gutter = "#6E6C7E"
            local border = "#B4BEFE"

            require("catppuccin").setup({
                flavour = "mocha", -- Set theme flavor to mocha
                on_colors = function(colors)
                    colors.bg = bg
                    colors.bg_dark = bg_dark
                    colors.bg_float = bg_dark
                    colors.bg_highlight = bg_highlight
                    colors.bg_popup = bg_dark
                    colors.bg_search = bg_search
                    colors.bg_sidebar = bg_dark
                    colors.bg_statusline = bg_dark
                    colors.bg_visual = bg_visual
                    colors.border = border
                    colors.fg = fg
                    colors.fg_dark = fg_dark
                    colors.fg_float = fg
                    colors.fg_gutter = fg_gutter
                    colors.fg_sidebar = fg_dark
                end,
            })
            -- load the colorscheme here
            vim.cmd([[colorscheme catppuccin]])
        end,
    },
}
