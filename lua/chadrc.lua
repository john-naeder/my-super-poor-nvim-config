---@type ChadrcConfig
local M = {}

M.base46 = {
  theme = "eldritch",
  lsp = { signature = false },
  transparency = true,

  hl_override = {
    Comment = { italic = true },
    ["@comment"] = { italic = true },
  },
}

M.ui = {
  statusline = {
    order = { "mode", "file", "macro", "git", "%=", "lsp_msg", "%=", "diagnostics", "lsp", "cwd", "cursor" },
    modules = {
      macro = function()
        local register = vim.fn.reg_recording()
        if register == "" then
          return ""
        end

        return "%#St_lspError# REC @" .. register .. " %#ST_EmptySpace#"
      end,
    },
  },
}

return M
