local heirline = require("heirline")
local conditions = require('heirline.conditions')
local utils = require('heirline.utils')
local lush = require('lush')
local buf = vim.b
local hsl = lush.hsl

-- defaults {{{
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
    wine_red = tostring(hsl("#9c1e37")),
    red = tostring(hsl("#ff0000")),
    off_red = tostring(hsl("#f81141")),
    rose = tostring(hsl("#fc4a6d")),
    brown = tostring(hsl("#745b53")),
    clay_orange = tostring(hsl("#fd7e57")),
    peach = tostring(hsl("#ff936a")),
    dandelion = tostring(hsl("#ffcc00")),
    dark_dandelion = tostring(hsl("#ffa023")),
    sun = tostring(hsl("#f9c859")),
    yellow = tostring(hsl("#ffff00")),
    dark_green = tostring(hsl("#237236")),
    green = tostring(hsl("#3fc56b")),
    lime_green = tostring(hsl("#92f535")),
    baby_blue = tostring(hsl("#8bcdef")),
    light_blue = tostring(hsl("#10b1fe")),
    off_blue = tostring(hsl("#285bff")),
    blue = tostring(hsl("#0000ff")),
    light_purple = tostring(hsl("#9f7efe")),
    magenta = tostring(hsl("#ff00ff")),
    dark_grey = tostring(hsl("#636d83")),
    grey = tostring(hsl("#abb2bf")),
    light_grey = tostring(hsl("#cdd3e0")),
    white = tostring(hsl("#f9f9f9")),
    pure_white = tostring(hsl("#ffffff")),
    blue_grey = tostring(hsl("#22252a")),
    shadow_blue = tostring(hsl("#282c34")),
    black = tostring(hsl("#000000")),
    -- }}}
    -- vibrants {{{
    braker_blue = tostring(hsl("#28e3eb")),
    burnt_orange = tostring(hsl("#ffa023")),
    pink = tostring(hsl("#ff78ff")),
    poison_green = tostring(hsl("#00ff95"))
    -- }}}
}


local colors = {
    bg = color_codes.blue_grey,
    black = color_codes.black,
    skyblue = color_codes.light_blue,
    cyan = color_codes.braker_blue,
    fg = color_codes.light_grey,
    green = color_codes.dark_green,
    oceanblue = color_codes.off_blue,
    magenta = color_codes.magenta,
    orange = color_codes.dark_dandelion,
    red = color_codes.off_red,
    violet = color_codes.light_purple,
    white = color_codes.pure_white,
    yellow = color_codes.sun,
}

local mode_colors = {
    ["\22"] = "red",
    ["\19"] = "red",
    ["!"] = "red",
    n = "dark_green",
    i = "red",
    v = "light_blue",
    V = "light_blue",
    s = "orange",
    S = "orange",
    r = "violet",
    R = "violet",
    c = "dark_green",
    t = "dark_green",
}
-- }}}

-- sep_fns {{{
local function get_empty_sep(hl)
    return { provider = ' ', hl = hl }
end

local function get_left_sep(sep, hl)
    return { provider = sep or separators.block, hl = hl }
end

local function get_right_sep(sep, hl)
    return { provider = sep or separators.block, hl = hl }
end

local function get_vi_color()
    return mode_colors[vim.fn.mode(1):sub(1, 1)]
end

local function get_vi_blocks(seps, middle_provider, final_color)
    return {
        -- file name with vi color
        get_left_sep(seps and seps[1] or nil, function()
            return { fg = get_vi_color()
            }
        end),
        { provider = middle_provider, hl = function() return { bg = get_vi_color() } end
        },
        get_right_sep(seps and seps[2] or nil, function()
            return { fg = get_vi_color(), bg = final_color
            }
        end),
        update = { "ModeChanged" }
    }
end

-- }}}

-- components {{{

-- navic {{{
local navic = {
    condition = function()
        local cwd = vim.fn.getcwd(0)
        return require("nvim-navic").is_available() and conditions.width_percent_below(#cwd, 0.25)
    end,
    hl = { fg = 'bg', bg = 'skyblue' },
    update = { 'CursorMoved', 'BufReadPost' },
    {
        condition = function() return require("nvim-navic").get_location() ~= '' end,
        update = 'ModeChanged',
        provider = separators.slant_right_2,
        hl = function() return { fg = 'wine_red' } end
    },
    {
        provider = function()
            return require("nvim-navic").get_location()
        end,
    }
}
-- }}}

-- help name {{{
local HelpFileName = {
    condition = function()
        return vim.bo.filetype == "help"
    end,
    provider = function()
        local filename = vim.api.nvim_buf_get_name(0)
        return vim.fn.fnamemodify(filename, ":t")
    end,
    hl = { fg = colors.blue },
}
-- }}}

-- search {{{
local SearchCount = {
    condition = function()
        return vim.v.hlsearch ~= 0 and vim.o.cmdheight == 0
    end,
    init = function(self)
        local ok, search = pcall(vim.fn.searchcount)
        if ok and search.total then
            self.search = search
        end
    end,
    hl = { fg = 'burnt_orange' },
    provider = function(self)
        local search = self.search
        return string.format("[%d/%d]", search.current, math.min(search.total, search.maxcount))
    end,
}
-- }}}

-- macro {{{
local MacroRec = {
    condition = function()
        return vim.fn.reg_recording() ~= "" and vim.o.cmdheight == 0
    end,
    provider = " ",
    hl = { fg = "orange", bold = true },
    utils.surround({ "[", "]" }, nil, {
        provider = function()
            return vim.fn.reg_recording()
        end,
        hl = { fg = "green", bold = true },
    }),
    update = { "RecordingEnter", "RecordingLeave", }
}
-- }}}

-- workdir {{{
local WorkDir = {
    static = {
        base_color = "off_blue"
    },
    {
        provider = function()
            local icon = (vim.fn.haslocaldir(0) == 1 and "l" or "g") .. " " .. " "
            local cwd = vim.fn.getcwd(0)
            cwd = vim.fn.fnamemodify(cwd, ":~")
            cwd = vim.fn.pathshorten(cwd)
            local trail = cwd:sub(-1) == '/' and '' or "/"
            return icon .. cwd .. trail
        end,
        hl = function(self) return { bg = self.base_color, bold = true } end,
    },
    get_right_sep(separators.slant_right_2, function(self) return { fg = self.base_color, bg = 'wine_red' } end)
}
-- }}}

-- filename {{{
local filename = {
    {
        -- provider = vim.fn.pathshorten("%f"),
        provider = function()
            local cwd = vim.fn.getcwd(0)
            cwd = vim.fn.fnamemodify(cwd, ":~:.")
            local filepath = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":~:.")
            filepath = vim.fn.substitute(filepath, cwd, '', '')
            filepath = vim.fn.substitute(filepath, "~", '', '')
            if not conditions.width_percent_below(#cwd, 0.25) then
                filepath = vim.fn.pathshorten(filepath)
            end
            return filepath
        end,
        hl = { bg = "wine_red" },
    },
}
-- }}}

-- lsp {{{
local LSPActive = {
    on_click  = {
        callback = function()
            vim.defer_fn(function()
                vim.cmd("LspInfo")
            end, 100)
        end,
        name = "heirline_LSP",
    },
    condition = conditions.lsp_attached,
    update    = { 'LspAttach', 'LspDetach' },
    provider  = function()
        local names = {}
        for i, server in pairs(vim.lsp.get_active_clients({ bufnr = 0 })) do
            table.insert(names, server.name)
        end
        return " [" .. table.concat(names, ",") .. "]"
    end,
    hl        = { fg = "dark_green", bold = true },
}
-- }}}

-- git {{{
local git = {
    condition = conditions.is_git_repo,
    -- update = { "BufEnter", "ModeChanged" },
    hl = function() return { fg = 'sun' } end,
    init = function(self)
        self.status_dict = buf.gitsigns_status_dict
        self.has_changes = self.status_dict.added ~= 0 or self.status_dict.removed ~= 0 or self.status_dict.changed ~= 0
    end,
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
        provider = "["
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
        provider = "]",
    },
}
-- }}}

-- diag {{{
local Diagnostics = {
    on_click = {
        callback = function()
            require("trouble").toggle({ mode = "document_diagnostics" })
            -- or
            -- vim.diagnostic.setqflist()
        end,
        name = "heirline_diagnostics",
    },
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
    hl = { fg = 'poison_green' },
    { provider = "![" },
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
-- }}}

-- filetype {{{
local filetype = {
    condition = function() return vim.bo.filetype ~= '' end,
    hl = { fg = 'skyblue' },
    -- hl = function() return { fg = utils.get_highlight("Type").fg, bold = true } end,
    get_left_sep(separators.vertical_bar_thin),
    { provider = "%Y" },
    get_right_sep(separators.vertical_bar_thin)
}
-- }}}

local align = { provider = "%=" }
-- }}}

-- Sections {{{

-- left {{{
local left_section = {
    update = { "ModeChanged" },
    {
        { provider = " %03l:%03c ",            hl = function() return { bg = get_vi_color() } end },
        { provider = separators.slant_right_2, hl = function() return { fg = get_vi_color(), bg = 'off_blue' } end },
    },
    WorkDir,
    filename,
    -- align
}
-- }}}

-- center {{{
local center_section = {
    navic,
    align,
    { provider = " %S " },
}
-- }}}

--right {{{
local right_section = {
    HelpFileName,
    SearchCount,
    MacroRec,
    git,
    Diagnostics,
    LSPActive,
    filetype,
    { provider = "%-p%%" },
}
--}}}
-- }}}

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
        colors = color_codes
    }
})

-- vim: foldmethod=marker foldlevel=0
