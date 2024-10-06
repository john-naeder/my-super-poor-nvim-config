local nvlsp = require("nvchad.configs.lspconfig")
local mason_registry = require("mason-registry")
local codelldb = mason_registry.get_package("codelldb")
codelldb:get_install_path()
local extension_path = codelldb:get_install_path() .. "/extension/"
local codelldb_path = extension_path .. "adapter/codelldb"
local liblldb_path = extension_path .. "lldb/lib/liblldb.so"

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
    adapter = require("rustaceanvim.config").get_codelldb_adapter(
      codelldb_path,
      liblldb_path
    ),
  },
}
