local nvlsp = require("nvchad.configs.lspconfig")

-- Safely get codelldb path
local codelldb_path = nil
local liblldb_path = nil

local ok, mason_registry = pcall(require, "mason-registry")
if ok then
  local has_codelldb, codelldb = pcall(mason_registry.get_package, mason_registry, "codelldb")
  if has_codelldb then
    local install_path = codelldb:get_install_path()
    local extension_path = install_path .. "/extension/"
    codelldb_path = extension_path .. "adapter/codelldb"
    liblldb_path = extension_path .. "lldb/lib/liblldb.so"
  end
end

vim.g.rustaceanvim = {
  server = {
    on_attach = nvlsp.on_attach,
    capabilities = nvlsp.capabilities,
    ["rust-analyzer"] = {
      diagnostics = {
        experimental = true,
      },
    },

    settings = {

      ["rust-analyzer"] = {
        cargo = {
          allFeatures = true,
        },
        checkOnSave = {
          command = "clippy",
        },
        assist = {
          importGranularity = "module",
          importPrefix = "by_self",
        },
        formatting = {
          command = { "rustfmt" },
          max_width = 80,
        },
        inlayHints = {
          bindingModeHints = {
            enable = false,
          },
          chainingHints = {
            enable = true,
          },
          closingBraceHints = {
            enable = true,
            minLines = 25,
          },
          closureReturnTypeHints = {
            enable = "never",
          },
          lifetimeElisionHints = {
            enable = "never",
            useParameterNames = false,
          },
          maxLength = 25,
          parameterHints = {
            enable = true,
          },
          reborrowHints = {
            enable = "never",
          },
          renderColons = true,
          typeHints = {
            enable = true,
            hideClosureInitialization = false,
            hideNamedConstructor = false,
          },
        },
      },
    },
  },
}

-- Set up DAP adapter only if codelldb is available
if codelldb_path and liblldb_path then
  vim.g.rustaceanvim.dap = {
    adapter = require("rustaceanvim.config").get_codelldb_adapter(
      codelldb_path,
      liblldb_path
    ),
  }
end
