---@type ChadrcConfig
local M = {}

M.ui = {
  theme = "onedark",
  lsp = { signature = false },
  transparency = true,

  hl_override = {
    Comment = { italic = true },
    ["@comment"] = { italic = true },
  },
}

return M
