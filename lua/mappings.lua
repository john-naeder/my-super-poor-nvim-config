require("nvchad.mappings")

-- add yours here

local map = vim.keymap.set

map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")
map("i", "jk", "<ESC>")
map({ "n", "x", "o" }, "<leader>fj", function()
  require("hop").hint_words()
end, { desc = "Jumping with hop keyword" })

-- Crates mappings
map("n", "<leader>rcu", function()
  require("crates").upgrade_all_crates()
end, { desc = "Update crates" })

-- line move

map("n", "<A-j>", [[<cmd> m .+1<cr>==]], { desc = "Move line up" })
map("n", "<A-k>", [[<cmd> m .-2<cr>==]], { desc = "Move line down" })
map("v", "<A-j>", [[<cmd> m '<-2<cr>gv]], { desc = "Move lines up" })
map("v", "<A-j>", [[<cmd> m '>+1<cr>gv]], { desc = "Move lines up" })
-- map("n", "<A-j>", ":silent m .+1<CR>==", { desc = "Move line up" })
-- map("n", "<A-k>", ":silent m .-2<CR>==", { desc = "Move line down" })
-- map("v", "<A-j>", ":silent m '>+1<CR>gv=gv", { desc = "Move lines up" })
-- map("v", "<A-k>", ":silent m '<-2<CR>gv=gv", { desc = "Move lines down" })

-- Resize window
map("n", "=", [[<cmd>vertical resize +5<cr>]])
map("n", "-", [[<cmd>vertical resize -5<cr>]])
map("n", "+", [[<cmd>horizontal resize +2<cr>]])
map("n", "_", [[<cmd>horizontal resize -2<cr>]])

-- Dap
local dap = require("dap")
map("n", "<F5>", dap.continue, { desc = "Start/Continue Debugging" })
map("n", "<F10>", dap.step_over, { desc = "Step Over" })
map("n", "<F11>", dap.step_into, { desc = "Step Into" })
map("n", "<F12>", dap.step_out, { desc = "Step Out" })
map("n", "<leader>db", dap.toggle_breakpoint, { desc = "Toggle Breakpoint" })
map("n", "<leader>dB", function()
  dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
end, { desc = "Set Conditional Breakpoint" })
map(
  "n",
  "<leader>dc",
  dap.clear_breakpoints,
  { desc = "Clear All Breakpoints" }
)
map("n", "<leader>dr", dap.repl.open, { desc = "Open REPL" })
map("n", "<leader>dl", dap.run_last, { desc = "Run Last Debug Session" })
map("n", "<leader>dh", function()
  require("dap.ui.widgets").hover() end, { desc = "DAP Hover" })
map("n", "<leader>dw", function()
  local widgets = require("dap.ui.widgets")
  widgets.centered_float(widgets.scopes)
end, { desc = "Watch Variables" })
map("n", "<leader>dv", function()
  local var_name = vim.fn.input("Variable to watch: ")
  require("dap").set_watch(var_name)
end, { desc = "Watch a Variable" })
map("n", "<leader>dq", function()
  if dap.session() then
    dap.terminate()
  end
  require("dapui").close()
end, { desc = "Quit All DAP UI" })
