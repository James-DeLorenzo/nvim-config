
-- Substitute preset_name with the name of the preset you want to modify.
-- eg: "default" or "noicon"
-- local custom_preset = require('feline.presets')['noicon']
local gps = require('nvim-gps')
-- local colors = require('bluloco.colors')
local git = require('feline.providers.git')
local custom_theme = require('bluloco.feline')
local vi_hl_name = require('feline.providers.vi_mode').get_mode_highlight_name
local vi_color = require('feline.providers.vi_mode').get_mode_color

local function get_empty_sep(bg)
    return {
        str = ' ',
        hl = {
            bg = bg
        }
    }
end

local function get_left_sep(fg, bg, sep, always)
    return {
        str = sep or '',
        hl = {
            fg = fg,
            bg = bg
        },
        always_visible = always or false
    }
end

local function get_right_sep(fg, bg, sep, always)
    return {
        str = sep or '',
        hl = {
            fg = fg,
            bg = bg
        },
        always_visible = always or false
    }
end

local function vi_divider()
    return {
        provider = function () return "" end,
        hl = function () return { fg = vi_color(), name = vi_hl_name() } end
    }
end

local components = {
    active = {
        {
            {
                provider = 'file_info',
                opts = {
                    type = 'unique-short'
                },
                hl = function()
                    return {
                        name = vi_hl_name(),
                        bg = vi_color()
                    }
                end,
                left_sep = function()
                    return get_left_sep( vi_color(), nil, 'block')
                end,
                right_sep = function()
                    return get_right_sep(vi_color(), 'oceanblue')
                end,
                priority = 3
            },
            {
                provider = 'position',
                opts = { padding = true },
                left_sep = get_empty_sep('oceanblue'),
                right_sep = get_right_sep('oceanblue','skyblue'),
                hl = {bg = 'oceanblue'},
                priority = 5
            },
            {
                provider = 'diagnostic_info',
                icon = '',
                -- hl = { bg = 'skyblue', fg = 'black' },
                right_sep = get_right_sep('skyblue', 'cyan', 'right_rounded', true),
                truncate_hide = true,
                priority = 2
            },
            {
                provider = 'diagnostic_hints',
                icon = '',
                hl = { bg = 'cyan', fg = 'black' },
                right_sep = get_right_sep('cyan', 'yellow', 'right_rounded', true),
                truncate_hide = true,
                priority = 2
            },
            {
                provider = 'diagnostic_warnings',
                hl = { bg = 'yellow', fg = 'black' },
                right_sep = get_right_sep('yellow', 'red', 'right_rounded', true),
                truncate_hide = true,
                priority = 2
            },
            {
                provider = 'diagnostic_errors',
                icon = '',
                hl = { bg = 'red', fg = 'black' },
                right_sep = get_right_sep("red",nil, 'right_rounded', true),
                truncate_hide = true,
                priority = 2
            },
            vi_divider(),
            {
                provider = function()
                    return gps.get_location()
                end,
                enabled = function()
                    return gps.is_available()
                end,
                left_sep = get_empty_sep(nil),
                truncate_hide = true,
                priority = -1
            },
            vi_divider(),
        },
        {
            {
                provider='git_diff_added',
                icon = '',
                enabled = git.git_info_exists(),
                hl = { fg = 'bg', bg = 'green' },
                left_sep = function() return get_left_sep('green', 'bg','left_filled', true) end,
                right_sep = function() return get_left_sep('red', 'green','left_filled', true) end,
                truncate_hide = true,
                priority = -2
            },
            {
                provider='git_diff_removed',
                icon = '',
                enabled = git.git_info_exists(),
                hl = { fg = 'bg', bg = 'red' },
                right_sep = function() return get_left_sep('orange', 'red','left_filled', true) end,
                truncate_hide = true,
                priority = -2
            },
            {
                provider='git_diff_changed',
                icon = '',
                enabled = git.git_info_exists(),
                hl = { fg = 'bg', bg = 'orange' },
                right_sep = function() return get_left_sep(vi_color(),'orange','left_filled', true) end,
                truncate_hide = true,
                priority = -2
            },
            {
                provider='git_branch',
                enabled = git.git_info_exists(),
                hl = function()
                    return {
                        bg = vi_color(),
                        fg = 'bg'
                    }
                end,
                left_sep = function() return get_empty_sep(vi_color()) end,
                right_sep = function() return get_left_sep('skyblue',vi_color(),'left_filled', true) end,
                truncate_hide = true,
                priority = -2
            },
            {
                provider='file_type',
                hl = { fg = 'black', bg = 'skyblue' },
                left_sep = get_empty_sep('skyblue'),
                right_sep = get_empty_sep('skyblue'),
                priority = -1
            },
            {
                provider = 'line_percentage',
                hl = { fg = 'skyblue', bg = 'oceanblue' },
                left_sep = get_left_sep('oceanblue','skyblue','left_filled'),
                right_sep = get_empty_sep('oceanblue')
            },
            {
                provider = 'scroll_bar',
                hl = {
                        fg = 'skyblue',
                        bg = 'oceanblue'
                },
            }
        }
    },
    inactive = {
        {
            {
                provider = 'file_info',
                opts = {
                    type = 'unique-short'
                },
                hl = {
                    fg = 'white',
                    bg = 'oceanblue'
                },
                left_sep = 'block',
                right_sep = 'right_rounded',
                priority = 3
            }
        },
        {
            {
                provider = 'file_type',
                hl = {
                    bg = 'skyblue',
                    fg = 'black'
                },
                right_sep = 'block',
                left_sep = 'slant_left'
            },
            {
                provider = 'line_percentage',
                hl = { fg = 'skyblue', bg = 'oceanblue' },
                left_sep = get_left_sep('oceanblue','skyblue','left_filled'),
                right_sep = get_empty_sep('oceanblue')
            },
            {
                provider = 'scroll_bar',
                hl = {
                        fg = 'skyblue',
                        bg = 'oceanblue'
                },
            }
        }
    }
}

require('feline').setup {
    components = components,
    theme = custom_theme
}
