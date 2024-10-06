local lint = require("lint")

lint.linters_by_ft = {
  lua = { "luacheck" },
  python = { "flake8" },
  cpp = { "cpplint" },
  c = { "cpplint" },
}

lint.linters.luacheck.args = {
  "--globals",
  "love",
  "vim",
  "--formatter",
  "plain",
  "--codes",
  "--ranges",
  "-",
}

vim.api.nvim_create_autocmd({
  "BufEnter",
  "BufWritePre",
  "InsertLeave",
}, {
  callback = function()
    require("lint").try_lint()
  end,
})
