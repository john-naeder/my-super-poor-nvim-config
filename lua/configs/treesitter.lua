-- nvim-treesitter `main` branch: it only installs parsers/queries.
-- Highlighting, folding and indent are started per buffer below.
-- Parsers are compiled with `tree-sitter` CLI (Mason package `tree-sitter-cli`).
local ensure_installed = {
  "bash",
  "c",
  "cpp",
  "cmake",
  "c_sharp",
  "objc",
  "make",
  "fish",
  "lua",
  "luadoc",
  "python",
  "toml",
  "vim",
  "vimdoc",
  "markdown",
  "markdown_inline",
  "yaml",
  "rust",
  "proto",
  -- Web Development
  "javascript",
  "typescript",
  "tsx",
  "json",
  "html",
  "css",
  "scss",
  "graphql",
  -- DevOps
  "dockerfile",
  "hcl",
  "terraform",
  "xml",
  "regex",
  "diff",
  "gitignore",
  "git_config",
  "git_rebase",
  "gotmpl",
  "helm",
}

local ok, ts = pcall(require, "nvim-treesitter")
if not ok then
  vim.notify(
    "nvim-treesitter is not available. Run :Lazy sync to install/update it.",
    vim.log.levels.ERROR
  )
  return
end

ts.setup()

-- Install only what is missing (async, no-op when everything is present)
local installed = ts.get_installed()
local missing = vim.tbl_filter(function(lang)
  return not vim.list_contains(installed, lang)
end, ensure_installed)
if #missing > 0 then
  if vim.fn.executable("tree-sitter") == 1 then
    ts.install(missing)
  else
    vim.notify(
      "tree-sitter CLI not found, run :MasonInstall tree-sitter-cli",
      vim.log.levels.WARN
    )
  end
end

local function attach(buf)
  if not pcall(vim.treesitter.start, buf) then
    return
  end
  vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
end

vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("TreesitterStart", { clear = true }),
  callback = function(args)
    attach(args.buf)
  end,
})

-- Buffers opened before this plugin loaded
for _, buf in ipairs(vim.api.nvim_list_bufs()) do
  if vim.api.nvim_buf_is_loaded(buf) and vim.bo[buf].filetype ~= "" then
    attach(buf)
  end
end
