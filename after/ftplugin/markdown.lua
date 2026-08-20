vim.opt_local.wrap = true
vim.opt_local.linebreak = true

vim.opt_local.spell = true

vim.opt_local.conceallevel = 2
vim.opt_local.concealcursor = ""

local ok, render = pcall(require, "render-markdown")
if ok then
  vim.schedule(function()
    local success = pcall(function()
      vim.cmd("RenderMarkdown enable")
    end)
    if not success then
      vim.notify("Failed to enable RenderMarkdown", vim.log.levels.WARN)
    end
  end)
end

local function md_gf()
  local line = vim.api.nvim_get_current_line()
  local col = vim.api.nvim_win_get_cursor(0)[2] + 1

  local target
  local init = 1
  while true do
    local open = line:find("%(", init)
    if not open then
      break
    end
    local close = line:find("%)", open)
    if not close then
      break
    end
    if col >= open and col <= close then
      target = line:sub(open + 1, close - 1)
      break
    end
    init = close + 1
  end

  if not target then
    vim.cmd("normal! gf")
    return
  end

  if target:match("^%a+://") or target:match("^mailto:") then
    vim.cmd("normal! gf")
    return
  end

  local file, anchor = target:match("^([^#]*)#?(.*)$")

  if file == "" or not file:lower():match("%.md$") then
    vim.cmd("normal! gf")
    return
  end

  local dir = vim.fn.expand("%:p:h")
  local path = vim.fn.fnamemodify(dir .. "/" .. file, ":p")
  vim.cmd("edit " .. vim.fn.fnameescape(path))

  if anchor and anchor ~= "" then
    local words = {}
    for w in anchor:gmatch("[^%-]+") do
      table.insert(words, vim.pesc(w))
    end
    local pattern = "\\c^#\\+.*" .. table.concat(words, ".*")
    vim.fn.search(pattern, "w")
  end
end

vim.keymap.set(
  "n",
  "gf",
  md_gf,
  { buffer = true, desc = "gf: mở file .md + nhảy tới #anchor" }
)
