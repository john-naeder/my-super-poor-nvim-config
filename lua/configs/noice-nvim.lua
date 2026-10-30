-- Neovim 0.11+ emits `:!cmd` output with its own message kinds
-- (shell_out = stdout, shell_err = stderr, shell_ret = "shell returned N").
-- Noice's default history/last filters only keep kind "", so these were dropped.
local shell_kinds = { "shell_out", "shell_err", "shell_ret" }

local history_filter = {
  any = {
    { event = "notify" },
    { error = true },
    { warning = true },
    { event = "msg_show", kind = { "" } },
    { event = "msg_show", kind = shell_kinds },
    { event = "lsp", kind = "message" },
  },
}

local options = {
  lsp = {
      -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
      override = {
        ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
        ["vim.lsp.util.stylize_markdown"] = true,
        ["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
      },
    },
  commands = {
    history = { filter = history_filter },
    last = { filter = history_filter },
  },
  routes = {
    -- stdout of `:!cmd` -> output split (noice has no default route for it, so it was hidden)
    {
      filter = { event = "msg_show", kind = "shell_out" },
      view = "split",
      opts = { enter = true, format = { "{message}" } }, -- raw output, focused (close with q)
    },
    -- non-zero exit code of `:!cmd` -> error notification
    {
      filter = { event = "msg_show", kind = "shell_ret" },
      view = "notify",
      opts = { level = "error", title = "Shell command failed" },
    },
    -- stderr of `:!cmd` -> warning notification (kept apart from stdout)
    {
      filter = { event = "msg_show", kind = "shell_err" },
      view = "notify",
      opts = { level = "warn", title = "Shell stderr" },
    },
  },
    -- you can enable a preset for easier configuration
    presets = {
      bottom_search = true, -- use a classic bottom cmdline for search
      command_palette = true, -- position the cmdline and popupmenu together
      long_message_to_split = true, -- long messages will be sent to a split
      inc_rename = false, -- enables an input dialog for inc-rename.nvim
      lsp_doc_border = false, -- add a border to hover docs and signature help
  }
}
return options
