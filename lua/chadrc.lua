---@type ChadrcConfig
local M = {}

M.base46 = {
	theme = "palenight",
  lsp = { signature = false },
  transparency = true,

  hl_override = {
    Comment = { italic = true },
    ["@comment"] = { italic = true },
  },
}

return M
