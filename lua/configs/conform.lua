local options = {
  formatters_by_ft = {
    lua = { "stylua" },
    c = { "clang-format" },
    cpp = { "clang-format" },
    python = { "isort", "black" },
    rust = { "rustfmt" },
    c_sharp = { "csharpier" }
  },

  formatters = {
    -- C & C++
    ["clang-format"] = {
      prepend_args = {
        "-style={ \
            IndentWidth: 2, \
            TabWidth: 2, \
            UseTab: Never, \
            AccessModifierOffset: 0, \
            IndentAccessModifiers: true, \
            PackConstructorInitializers: Never \
       }",
      },
    },
    -- Lua
    stylua = {
      prepend_args = {
        "--column-width",
        "80",
        "--line-endings",
        "Unix",
        "--indent-type",
        "Spaces",
        "--indent-width",
        "2",
        "--quote-style",
        "AutoPreferDouble",
      },
    },
    -- Python
    black = {
      prepend_args = {
        "--fast",
        "--line-length",
        "80",
      },
    },
    isort = {
      prepend_args = {
        "--profile",
        "black",
      },
    },
  },

  -- format_on_save = {
  --   timeout_ms = 500,
  --   lsp_fallback = true,
  -- },
}
require("conform").setup(options)

vim.api.nvim_create_autocmd("BufWritePre", {
  callback = function()
    require("conform").format({ async = true })
  end,
})
