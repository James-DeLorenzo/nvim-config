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
        get_left_sep(seps and seps[1] or nil, function() return { fg = get_vi_color() } end),
        { provider = middle_provider, hl = function() return { bg = get_vi_color() } end },
        get_right_sep(seps and seps[2] or nil, function() return { fg = get_vi_color(), bg = final_color } end),
        update = { "ModeChanged" }
    }
end

local function get_diagnostics_count(severity)
    local count = vim.tbl_count(vim.diagnostic.get(0, severity and { severity = severity }))
    return count ~= 0 and tostring(count) or ''
end

local navic = {
    condition = function() return require("nvim-navic").is_available() end,
    hl = { bg = 'skyblue', bold = true },
    update = { 'CursorMoved', 'BufReadPost' },
    get_empty_sep(nil),
    {
        provider = function()
            return require("nvim-navic").get_location()
        end,
    }
}

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
    provider = function(self)
        local search = self.search
        return string.format("[%d/%d]", search.current, math.min(search.total, search.maxcount))
    end,
}

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
    update = {
        "RecordingEnter",
        "RecordingLeave",
        -- redraw the statusline on recording events
        -- Note: this is only required for Neovim < 0.9.0. Newer versions of
        -- Neovim ensure `statusline` is redrawn on those events.
        callback = vim.schedule_wrap(function()
            vim.cmd("redrawstatus")
        end),
    }
}

local WorkDir = {
    static = {
        base_color = "oceanblue"
    },
    {
        provider = function()
            local icon = (vim.fn.haslocaldir(0) == 1 and "l" or "g") .. " " .. " "
            local cwd = vim.fn.getcwd(0)
            cwd = vim.fn.fnamemodify(cwd, ":~")
            if not conditions.width_percent_below(#cwd, 0.25) then
                cwd = vim.fn.pathshorten(cwd)
            end
            local trail = cwd:sub(-1) == '/' and '' or "/"
            return icon .. cwd .. trail
        end,
        hl = function(self) return { bg = self.base_color, bold = true } end,
    },
    get_right_sep(separators.right_filled, function(self) return { fg = self.base_color, bg = get_vi_color() } end)
}

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
    hl        = { fg = "green", bold = true },
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

local left_section = {
    {
        update = { "ModeChanged" },
        { provider = " %03l:%03c ", hl = function() return { bg = get_vi_color() } end },
    },
    WorkDir,
    get_vi_blocks({ nil, separators.right_filled }, "%f", "skyblue"),
    -- align
}

local center_section = {
    navic,
    align,
    { provider = " %S " },
}

local right_section = {
    HelpFileName,
    SearchCount,
    MacroRec,
    git,
    Diagnostics,
    LSPActive,
    {
        update = { "BufEnter" },
        hl = { fg = 'skyblue' },
        -- hl = function() return { fg = utils.get_highlight("Type").fg, bold = true } end,
        get_left_sep(separators.vertical_bar_thin),
        { provider = "%Y" },
        get_right_sep(separators.vertical_bar_thin)
    },
    -- { provider = "%l/%L:%c" },
    {
        { provider = "%-p%%" },
        get_left_sep(nil, { fg = 'bg' }),
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
