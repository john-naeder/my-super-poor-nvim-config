---@type ChadrcConfig
local M = {}

M.ui = {
    theme = "catppuccin",

    transparency = true,

    hl_override = {
        Comment = { italic = true },
        ["@comment"] = { italic = true },
    },
}

return M
