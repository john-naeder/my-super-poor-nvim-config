local options = {
  ensure_installed = {
    "bash",
    "c",
    "cpp",
    "cmake",
    "csharp",
    "objc",
    "make",
    "fish",
    "lua",
    "luadoc",
    "markdown",
    "python",
    "toml",
    "vim",
    "vimdoc",
    "markdown",
    "markdown_inline",
    "yaml",
    "toml",
    "rust",
    "proto",
    -- Web Development
    "javascript",
    "typescript",
    "tsx",
    "json",
    "jsonc",
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
  },

  highlight = {
    enable = true,
    use_languagetree = true,
  },

  indent = { enable = true },
}

local ok, configs = pcall(require, "nvim-treesitter.configs")
if not ok then
  vim.notify(
    "nvim-treesitter is not available. Run :Lazy sync to install/update it.",
    vim.log.levels.ERROR
  )
  return
end

configs.setup(options)
