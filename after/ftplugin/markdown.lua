-- Enable word wrap for markdown files
vim.opt_local.wrap = true
vim.opt_local.linebreak = true

-- Spell checking
vim.opt_local.spell = true
vim.opt_local.spelllang = 'en_us'

-- Better concealing for markdown syntax
vim.opt_local.conceallevel = 2
vim.opt_local.concealcursor = ''

-- Auto-enable render-markdown if available (with error handling)
local ok, render = pcall(require, 'render-markdown')
if ok then
  vim.schedule(function()
    local success = pcall(function()
      vim.cmd('RenderMarkdown enable')
    end)
    if not success then
      vim.notify('Failed to enable RenderMarkdown', vim.log.levels.WARN)
    end
  end)
end
