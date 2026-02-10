local options = {
  ensure_installed = {
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

require("nvim-treesitter.configs").setup(options)
