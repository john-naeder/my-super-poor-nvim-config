local nvlsp = require("nvchad.configs.lspconfig")

local lspconfig = require("lspconfig")

lspconfig.servers = {
  "lua_ls",
  "clangd",
  "pyright",
  "efm",
  "rust_analyzer",
}

vim.diagnostic.config({ virtual_text = false })
vim.o.updatetime = 300
vim.cmd([[autocmd CursorHold,CursorHoldI * lua vim.diagnostic.open_float(nil, {focus=false})]])

-- list of servers configured with default config.
local default_servers = {
  "pyright",
}

-- lsps with default config
for _, lsp in ipairs(default_servers) do
  lspconfig[lsp].setup({
    on_attach = nvlsp.on_attach,
    on_init = nvlsp.on_init,
    capabilities = nvlsp.capabilities,
  })
end

lspconfig.clangd.setup({
  on_attach = function(client, bufnr)
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false
    nvlsp.on_attach(client, bufnr)
  end,
  on_init = nvlsp.on_init,
  capabilities = nvlsp.capabilities,
  settings = {
    clangd = {
      InlayHints = {
        Designators = true,
        Enabled = true,
        ParameterNames = true,
        DeducedTypes = true,
      },
      fallbackFlags = { "-std=c++20" },
    },
  },
})

lspconfig.efm.setup({
  init_options = { documentFormatting = true },
  filetypes = { "make" },
  settings = {
    rootMarkers = { ".git/" },
    languages = {
      make = {
        {
          formatCommand = "make --check-syntax",
          formatStdin = true,
        },
      },
    },
  },
})

lspconfig.lua_ls.setup({
  on_attach = nvlsp.on_attach,
  on_init = nvlsp.on_init,
  capabilities = nvlsp.capabilities,

  settings = {
    Lua = {
      diagnostics = {
        enable = true,
      },
      workspace = {
        library = {
          vim.fn.expand("$VIMRUNTIME/lua"),
          vim.fn.expand("$VIMRUNTIME/lua/vim/lsp"),
          vim.fn.stdpath("data") .. "/lazy/ui/nvchad_types",
          vim.fn.stdpath("data") .. "/lazy/lazy.nvim/lua/lazy",
          "${3rd}/love2d/library",
        },
        maxPreload = 100000,
        preloadFileSize = 10000,
      },
      hint = { enable = true },
    },
  },
})
