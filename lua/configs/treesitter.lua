local options = {
  ensure_installed = {
    "bash",
    "c",
    "make",
    "cmake",
    "cpp",
    "objc",
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
  },

  highlight = {
    enable = true,
    use_languagetree = true,
  },

  indent = { enable = true },
}

require("nvim-treesitter.configs").setup(options)
