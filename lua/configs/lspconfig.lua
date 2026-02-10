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

-- Configure ts_ls (TypeScript Language Server)
vim.lsp.config('ts_ls', {
  on_attach = nvlsp.on_attach,
  on_init = nvlsp.on_init,
  capabilities = nvlsp.capabilities,
})

-- Configure yamlls (YAML Language Server)
vim.lsp.config('yamlls', {
  on_attach = nvlsp.on_attach,
  on_init = nvlsp.on_init,
  capabilities = nvlsp.capabilities,
  settings = {
    yaml = {
      schemas = {
        ["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*",
        ["https://raw.githubusercontent.com/ansible/ansible-lint/main/src/ansiblelint/schemas/ansible.json#/$defs/playbook"] = "**/playbooks/*.{yml,yaml}",
        ["https://json.schemastore.org/docker-compose.json"] = "**/docker-compose*.{yml,yaml}",
        ["https://json.schemastore.org/kustomization.json"] = "kustomization.{yml,yaml}",
        ["https://json.schemastore.org/chart.json"] = "Chart.{yml,yaml}",
        kubernetes = "/*.k8s.{yml,yaml}",
      },
      validate = true,
      completion = true,
      hover = true,
    },
  },
})

-- Configure jsonls (JSON Language Server)
vim.lsp.config('jsonls', {
  on_attach = nvlsp.on_attach,
  on_init = nvlsp.on_init,
  capabilities = nvlsp.capabilities,
  settings = {
    json = {
      schemas = require("schemastore").json.schemas(),
      validate = { enable = true },
    },
  },
})

-- Configure dockerls (Docker Language Server)
vim.lsp.config('dockerls', {
  on_attach = nvlsp.on_attach,
  on_init = nvlsp.on_init,
  capabilities = nvlsp.capabilities,
})

-- Configure docker_compose_language_service
vim.lsp.config('docker_compose_language_service', {
  on_attach = nvlsp.on_attach,
  on_init = nvlsp.on_init,
  capabilities = nvlsp.capabilities,
})

-- Configure terraformls (Terraform Language Server)
vim.lsp.config('terraformls', {
  on_attach = nvlsp.on_attach,
  on_init = nvlsp.on_init,
  capabilities = nvlsp.capabilities,
})

-- Configure ansiblels (Ansible Language Server)
vim.lsp.config('ansiblels', {
  on_attach = nvlsp.on_attach,
  on_init = nvlsp.on_init,
  capabilities = nvlsp.capabilities,
})

-- Configure bashls (Bash Language Server)
vim.lsp.config('bashls', {
  on_attach = nvlsp.on_attach,
  on_init = nvlsp.on_init,
  capabilities = nvlsp.capabilities,
})

-- Configure html
vim.lsp.config('html', {
  on_attach = nvlsp.on_attach,
  on_init = nvlsp.on_init,
  capabilities = nvlsp.capabilities,
})

-- Configure cssls
vim.lsp.config('cssls', {
  on_attach = nvlsp.on_attach,
  on_init = nvlsp.on_init,
  capabilities = nvlsp.capabilities,
})

-- Configure tailwindcss
vim.lsp.config('tailwindcss', {
  on_attach = nvlsp.on_attach,
  on_init = nvlsp.on_init,
  capabilities = nvlsp.capabilities,
})

-- Enable all configured language servers
vim.lsp.enable('pyright')
vim.lsp.enable('csharp_ls')
vim.lsp.enable('clangd')
vim.lsp.enable('efm')
vim.lsp.enable('lua_ls')
vim.lsp.enable('ts_ls')
vim.lsp.enable('yamlls')
vim.lsp.enable('jsonls')
vim.lsp.enable('dockerls')
vim.lsp.enable('docker_compose_language_service')
vim.lsp.enable('terraformls')
vim.lsp.enable('ansiblels')
vim.lsp.enable('bashls')
vim.lsp.enable('html')
vim.lsp.enable('cssls')
vim.lsp.enable('tailwindcss')
