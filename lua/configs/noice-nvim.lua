local options = {
  lsp = {
    signature = {
      enabled = false,
    },
    override = {
      ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
      ["vim.lsp.util.stylize_markdown"] = true,
      ["cmp.entry.get_documentation"] = true,
      ["vim.lsp.start_client"] = false,
    },
  },
  presets = {
    bottom_search = true,
    command_palette = true,
    long_message_to_split = true,
    inc_rename = false,
    lsp_doc_border = false,
  },
  messages = {
    enabled = true,
    view = "notify",
    filter = {
      {
        filter = { event = "msg_show" },
        hide = {
          pattern = ".*<C-.*>",
        },
      },
    },
  },
  views = {
    mini = {
      win_options = {
        winblend = 0,
      },
    },
  },
}

return options
