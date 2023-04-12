local heirline = require("heirline")
local conditions = require('heirline.conditions')
local utils = require('heirline.utils')
local lush = require('lush')
local buf = vim.b
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

local function get_empty_sep(hl)
    return {
        provider = ' ',
        hl = hl
    }
end

local function get_left_sep(sep, hl)
    return {
        provider = sep or separators.block,
        hl = hl
    }
end

local function get_right_sep(sep, hl)
    return {
        provider = sep or separators.block,
        hl = hl
    }
end

local function get_vi_color()
    return mode_colors[vim.fn.mode(1):sub(1, 1)]
end

local function get_vi_blocks(seps, middle_provider, final_color)
    return {
        -- file name with vi color
        get_left_sep(seps[1] or nil, function() return { fg = get_vi_color() } end),
        { provider = middle_provider, hl = function() return { bg = get_vi_color() } end },
        get_right_sep(seps[2] or nil, function() return { fg = get_vi_color(), bg = final_color } end),
        update = { "ModeChanged" }
    }
end

local function get_diagnostics_count(severity)
    local count = vim.tbl_count(vim.diagnostic.get(0, severity and { severity = severity }))
    return count ~= 0 and tostring(count) or ''
end

local navic = {
    get_empty_sep('bg'),
    {
        condition = function() return require("nvim-navic").is_available() end,
        provider = function()
            return require("nvim-navic").get_location()
        end,
        update = 'CursorMoved'
    }
}


local align = { provider = "%=", hl = { bg = 'bg' } }

local git = {
    condition = conditions.is_git_repo,
    init = function(self)
        self.status_dict = buf.gitsigns_status_dict
        self.has_changes = self.status_dict.added ~= 0 or self.status_dict.removed ~= 0 or self.status_dict.changed ~= 0
    end,
    update = { "ModeChanged" },
    hl = function() return { fg = 'yellow' } end,
    {
        -- git branch name
        provider = function(self)
            return " " .. self.status_dict.head
        end,
        hl = { bold = true }
    },
    -- You could handle delimiters, icons and counts similar to Diagnostics
    {
        condition = function(self)
            return self.has_changes
        end,
        provider = "("
    },
    {
        provider = function(self)
            local count = self.status_dict.added or 0
            return count > 0 and ("+" .. count)
        end,
        hl = { fg = "green" },
    },
    {
        provider = function(self)
            local count = self.status_dict.removed or 0
            return count > 0 and ("-" .. count)
        end,
        hl = { fg = "red" },
    },
    {
        provider = function(self)
            local count = self.status_dict.changed or 0
            return count > 0 and ("~" .. count)
        end,
        hl = { fg = "orange" },
    },
    {
        condition = function(self)
            return self.has_changes
        end,
        provider = ")",
    },
}

local Diagnostics = {
    condition = conditions.has_diagnostics,
    -- static = {
    --     error_icon = vim.fn.sign_getdefined("DiagnosticSignError")[1].text,
    --     warn_icon = vim.fn.sign_getdefined("DiagnosticSignWarn")[1].text,
    --     info_icon = vim.fn.sign_getdefined("DiagnosticSignInfo")[1].text,
    --     hint_icon = vim.fn.sign_getdefined("DiagnosticSignHint")[1].text,
    -- },
    init = function(self)
        self.errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
        self.warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
        self.hints = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })
        self.info = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })
    end,
    update = { "DiagnosticChanged", "BufEnter" },
    {
        provider = "![",
    },
    {
        provider = function(self)
            -- 0 is just another output, we can decide to print it or not!
            return self.errors > 0 and (self.errors .. " ")
        end,
        hl = { fg = "red" },
    },
    {
        provider = function(self)
            return self.warnings > 0 and (self.warnings .. " ")
        end,
        hl = { fg = "yellow" },
    },
    {
        provider = function(self)
            return self.info > 0 and (self.info .. " ")
        end,
        hl = { fg = "skyblue" },
    },
    {
        provider = function(self)
            return self.hints > 0 and (self.hints)
        end,
        hl = { fg = "cyan" },
    },
    {
        provider = "]",
    },
}
local diags = {
    condition = conditions.is_git_repo,
    init = function(self)
        self.status_dict = buf.gitsigns_status_dict
        self.has_changes = self.status_dict.added ~= 0 or self.status_dict.removed ~= 0 or self.status_dict.changed ~= 0
    end,
    update = { "ModeChanged" },
    hl = function() return { fg = 'yellow' } end,
    {
        hl = { fg = 'cyan' },
        {
            provider = function() return get_diagnostics_count(vim.diagnostic.severity.HINT) end,
            -- hl = { bg = 'cyan', fg = 'black' }
        },
        { provider = "," }
    },
    {
        hl = { fg = 'skyblue' },
        {
            provider = function() return get_diagnostics_count(vim.diagnostic.severity.INFO) end,
        },
        { provider = "," }
    },
    {
        hl = { fg = 'yellow' },
        {
            provider = function() return get_diagnostics_count(vim.diagnostic.severity.WARN) end,
        },
        { provider = "," }
    },
    {
        hl = { fg = 'red' },
        {
            provider = function() return get_diagnostics_count(vim.diagnostic.severity.ERROR) end,
        },
    },
}

local left_section = {
    get_vi_blocks({ separators.block, separators.right_rounded }, "%t", 'oceanblue'),
    {
        { provider = " %l:%c ", hl = { bg = 'oceanblue' } },
        get_right_sep(separators.right_filled, { fg = 'oceanblue' })
    },
    Diagnostics
}

local center_section = {
    { provider = separators.vertical_bar_thin },
    navic,
    align
}

local right_section = {
    { provider = " %S " },
    git,
    {
        hl = { fg = 'skyblue' },
        get_left_sep(separators.vertical_bar_thin),
        { provider = "%Y" },
        get_right_sep(separators.vertical_bar_thin)
    },
    { provider = "%l/%L:%c" },
    {
        get_left_sep(nil, { fg = 'bg' }),
        { provider = "%p%%" }
    }
}

local base_line = {
    hl = { fg = 'fg', bg = 'bg' },
    left_section,
    center_section,
    right_section
}

local tester = {
    { provider = "0x%B " },
    { provider = "hex-byte: %O " },
}

heirline.setup({
    statusline = base_line,
    opts = {
        colors = colors
    }
})
