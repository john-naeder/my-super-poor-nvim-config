local nvlsp = require("nvchad.configs.lspconfig")

vim.diagnostic.config({ virtual_text = false })
vim.o.updatetime = 300
vim.cmd(
  [[autocmd CursorHold,CursorHoldI * lua vim.diagnostic.open_float(nil, {focus=false})]]
)

-- Configure pyright with default settings
vim.lsp.config('pyright', {
  on_attach = nvlsp.on_attach,
  on_init = nvlsp.on_init,
  capabilities = nvlsp.capabilities,
})

-- Configure csharp_ls with default settings
vim.lsp.config('csharp_ls', {
  on_attach = nvlsp.on_attach,
  on_init = nvlsp.on_init,
  capabilities = nvlsp.capabilities,
})

-- Configure clangd with custom settings
vim.lsp.config('clangd', {
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

-- Configure efm
vim.lsp.config('efm', {
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

-- Configure lua_ls with enhanced workspace settings
vim.lsp.config('lua_ls', {
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

-- Enable all configured language servers
vim.lsp.enable('pyright')
vim.lsp.enable('csharp_ls')
vim.lsp.enable('clangd')
vim.lsp.enable('efm')
vim.lsp.enable('lua_ls')
