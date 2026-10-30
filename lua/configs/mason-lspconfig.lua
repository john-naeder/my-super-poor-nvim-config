-- List of LSP servers to install
local servers = {
  "lua_ls",
  "clangd",
  "pyright",
  "efm",
  "rust_analyzer",
  -- "csharp_ls",
  "ts_ls",
  -- DevOps
  "yamlls",
  "helm_ls",
  "jsonls",
  "dockerls",
  "docker_compose_language_service",
  "terraformls",
  "ansiblels",
  "bashls",
  "html",
  "cssls",
  "tailwindcss",
}

-- List of servers to ignore during install
local ignore_install = {}

-- Helper function to find if value is in table.
local function table_contains(table, value)
  for _, v in ipairs(table) do
    if v == value then
      return true
    end
  end
  return false
end

-- Build a list of lsp servers to install minus the ignored list.
local all_servers = {}
for _, s in ipairs(servers) do
  if not table_contains(ignore_install, s) then
    table.insert(all_servers, s)
  end
end

require("mason-lspconfig").setup({
  ensure_installed = all_servers,
  automatic_installation = false,
})
