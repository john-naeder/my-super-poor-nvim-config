require("nvchad.options")

local o = vim.o

if require("env").system_name == "Windows_NT" then
  o.shell = "powershell.exe"
  o.shellcmdflag = "-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command"
  o.shellquote = ""
  o.shellxquote = ""
else
  o.shell = "/usr/bin/zsh"
end

-- Indenting
o.shiftwidth = 2
o.tabstop = 2
o.softtabstop = 2
o.cursorlineopt = "both"
o.relativenumber = true
o.wrap = true

-- WSL: Use custom opener for URLs
if vim.fn.has('wsl') == 1 then
  -- Override vim.ui.open for WSL to open URLs in Windows browser
  vim.ui.open = function(path)
    -- Check if it's a web URL
    if path:match('^https?://') or path:match('^www%.') then
      -- Open in Windows browser
      vim.system({ vim.fn.expand('~/.local/bin/wsl-open'), path }, { detach = true })
      return
    end
    
    -- For file paths, determine how to open based on file type
    local expanded_path = vim.fn.expand(path)
    
    -- If path is relative (doesn't start with / or ~), resolve it relative to current buffer's directory
    if not expanded_path:match('^[/~]') then
      local current_file = vim.api.nvim_buf_get_name(0)
      if current_file ~= '' then
        local current_dir = vim.fn.fnamemodify(current_file, ':p:h')
        expanded_path = vim.fn.fnamemodify(current_dir .. '/' .. expanded_path, ':p')
      end
    end
    
    -- If file doesn't exist, show error
    if vim.fn.filereadable(expanded_path) == 0 and vim.fn.isdirectory(expanded_path) == 0 then
      vim.notify('File not found: ' .. expanded_path, vim.log.levels.ERROR)
      return
    end
    
    -- Get file extension (if any)
    local ext = expanded_path:match('%.([^.]+)$') or ''
    
    -- Binary files that should open with Windows apps
    local binary_exts = {
      -- Images
      'png', 'jpg', 'jpeg', 'gif', 'bmp', 'ico', 'svg', 'webp',
      -- Documents
      'pdf', 'doc', 'docx', 'xls', 'xlsx', 'ppt', 'pptx',
      -- Archives
      'zip', 'tar', 'gz', 'bz2', '7z', 'rar',
      -- Executables
      'exe', 'dll', 'so', 'dylib',
      -- Audio/Video
      'mp3', 'mp4', 'avi', 'mkv', 'wav', 'flac',
      -- Other binary
      'bin', 'dat', 'db', 'sqlite'
    }
    
    local is_binary = false
    for _, e in ipairs(binary_exts) do
      if ext:lower() == e then
        is_binary = true
        break
      end
    end
    
    if is_binary then
      -- Binary files: open with Windows app
      if vim.fn.executable('cmd.exe') == 1 then
        local winpath = vim.fn.system('wslpath -w ' .. vim.fn.shellescape(expanded_path)):gsub('\n', '')
        vim.system({ 'cmd.exe', '/c', 'start', '', winpath }, { detach = true })
      else
        vim.notify('Cannot open binary file: ' .. expanded_path, vim.log.levels.WARN)
      end
    else
      -- Everything else (text, code, config files): open in Neovim
      vim.cmd('edit ' .. vim.fn.fnameescape(expanded_path))
    end
  end
end
