require("nvchad.options")

local o = vim.o

if vim.loop.os_uname().sysname == "Windows_NT" then
  o.shell = "powershell.exe"
  o.shellcmdflag = "-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command"
  o.shellquote = ""
  o.shellxquote = ""
else
  -- Set Fish shell for Linux or other systems
  o.shell = "/usr/bin/fish"
end

-- Indenting
o.shiftwidth = 2
o.tabstop = 2
o.softtabstop = 2
o.cursorlineopt = "both"
o.relativenumber = true
o.wrap = false
