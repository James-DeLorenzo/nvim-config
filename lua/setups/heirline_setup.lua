local heirline = require("heirline")
local conditions = require('heirline.conditions')
local utils = require('heirline.utils')
local lush = require('lush')
local hsl = lush.hsl

local separators = {
    vertical_bar = '┃',
    vertical_bar_thin = '│',
    left = '',
    right = '',
    block = '█',
    left_filled = '',
    right_filled = '',
    slant_left = '',
    slant_left_thin = '',
    slant_right = '',
    slant_right_thin = '',
    slant_left_2 = '',
    slant_left_2_thin = '',
    slant_right_2 = '',
    slant_right_2_thin = '',
    left_rounded = '',
    left_rounded_thin = '',
    right_rounded = '',
    right_rounded_thin = '',
    circle = '●',
}

local navic = {
    condition = function() return require("nvim-navic").is_available() end,
    provider = function()
        return require("nvim-navic").get_location({ highlight = true })
    end,
    update = 'CursorMoved'
}

local function get_empty_sep(bg)
    return {
        provider = ' ',
        hl = {
            bg = bg
        }
    }
end

local function get_left_sep(sep, hl)
    return {
        provider = sep or separators.left_rounded,
        hl = hl,
        -- always_visible = always or false
    }
end

local function get_right_sep(sep, hl)
    return {
        provider = sep or separators.right_rounded,
        hl = hl,
        -- always_visible = always or false
    }
end

local color_codes = {
    -- colors {{{
    wine_red = hsl("#9c1e37"),
    red = hsl("#ff0000"),
    off_red = hsl("#f81141"),
    rose = hsl("#fc4a6d"),
    brown = hsl("#745b53"),
    clay_orange = hsl("#fd7e57"),
    peach = hsl("#ff936a"),
    dandelion = hsl("#ffcc00"),
    dark_dandelion = hsl("#ffa023"),
    sun = hsl("#f9c859"),
    yellow = hsl("#ffff00"),
    dark_green = hsl("#237236"),
    green = hsl("#3fc56b"),
    lime_green = hsl("#92f535"),
    baby_blue = hsl("#8bcdef"),
    light_blue = hsl("#10b1fe"),
    off_blue = hsl("#285bff"),
    blue = hsl("#0000ff"),
    light_purple = hsl("#9f7efe"),
    magenta = hsl("#ff00ff"),
    dark_grey = hsl("#636d83"),
    grey = hsl("#abb2bf"),
    light_grey = hsl("#cdd3e0"),
    white = hsl("#f9f9f9"),
    pure_white = hsl("#ffffff"),
    blue_grey = hsl("#22252a"),
    shadow_blue = hsl("#282c34"),
    black = hsl("#000000"),
    -- }}}
    -- vibrants {{{
    braker_blue = hsl("#28e3eb"),
    burnt_orange = hsl("#ffa023"),
    pink = hsl("#ff78ff"),
    poison_green = hsl("#00ff95")
    -- }}}
}


local colors = {
    bg = tostring(color_codes.blue_grey),
    black = tostring(color_codes.black),
    skyblue = tostring(color_codes.light_blue),
    cyan = tostring(color_codes.braker_blue),
    fg = tostring(color_codes.light_grey),
    green = tostring(color_codes.dark_green),
    oceanblue = tostring(color_codes.off_blue),
    magenta = tostring(color_codes.magenta),
    orange = tostring(color_codes.dark_dandelion),
    red = tostring(color_codes.off_red),
    violet = tostring(color_codes.light_purple),
    white = tostring(color_codes.pure_white),
    yellow = tostring(color_codes.sun),
}

local mode_colors = {
    ["\22"] = "red",
    ["\19"] = "red",
    ["!"] = "red",
    n = "green",
    i = "red",
    v = "skyblue",
    V = "skyblue",
    s = "orange",
    S = "orange",
    r = "violet",
    R = "violet",
    c = "green",
    t = "green",
}

local function get_vi_blocks(seps, middle_provider)
    return {
        -- file name with vi color
        get_left_sep(seps[1] or nil, function(self) return { fg = self.get_color() } end),
        { provider = middle_provider, hl = function(self) return { bg = self.get_color() } end },
        get_right_sep(seps[2] or nil, function(self) return { fg = self.get_color(), bg = 'oceanblue' } end),
        static = {
            get_color = function(self) return mode_colors[vim.fn.mode(1):sub(1, 1)] end,
        },
        update = { "ModeChanged" }
    }
end

local function get_diagnostics_count(severity)
    local count = vim.tbl_count(vim.diagnostic.get(0, severity and { severity = severity }))
    return count ~= 0 and tostring(count) or ''
end

local align = { provider = "%=", hl = { bg = 'bg' } }

local left_section = {
    get_vi_blocks({ separators.block, separators.right_rounded }, "%f"),
    {
        { provider = "%l:%c", hl = { bg = 'oceanblue' } },
        get_right_sep(nil, { fg = 'oceanblue', bg = 'cyan' })
    },
    {
        {
            get_left_sep(separators.block, { fg = 'cyan' }),
            {
                provider = function() return get_diagnostics_count(vim.diagnostic.severity.HINT) end,
                hl = { bg = 'cyan', fg = 'black' }
            },
            get_right_sep(nil, { bg = 'skyblue', fg = 'cyan' }),
        },
        {
            {
                provider = function() return get_diagnostics_count(vim.diagnostic.severity.INFO) end,
                hl = { bg = 'skyblue', fg = 'black' }
            },
            get_right_sep(nil, { bg = 'yellow', fg = 'skyblue' }),
        },
        {
            {
                provider = function() return get_diagnostics_count(vim.diagnostic.severity.WARN) end,
                hl = { bg = 'yellow', fg = 'black' }
            },
            get_right_sep(nil, { bg = 'red', fg = 'yellow' }),
        },
        {
            {
                provider = function() return get_diagnostics_count(vim.diagnostic.severity.ERROR) end,
                hl = { bg = 'red', fg = 'black' }
            },
            get_right_sep(nil, { bg = 'bg', fg = 'red' }),
        },
    }
}

local center_section = {
    navic,
    align
}

local right_section = {

}

local base_line = {
    left_section,
    center_section,
    right_section
}

heirline.setup({
    statusline = base_line,
    opts = {
        colors = colors
    }
})
