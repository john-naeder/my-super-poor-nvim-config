require("nvchad.options")

local o = vim.o

if require("env").system_name == "Windows_NT" then
  o.shell = "powershell.exe"
  o.shellcmdflag = "-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command"
  o.shellquote = ""
  o.shellxquote = ""
else
  o.shell = "/usr/bin/fish"
end

-- Indenting
o.shiftwidth = 2
o.tabstop = 2
o.softtabstop = 2
o.cursorlineopt = "both"
o.relativenumber = true
o.wrap = false
