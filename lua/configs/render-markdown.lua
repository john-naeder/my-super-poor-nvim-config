return {
  -- Enable/disable the plugin
  enabled = true,
  
  -- Maximum file size to render (in MB)
  max_file_size = 10.0,
  
  -- Debounce rendering in milliseconds
  debounce = 100,
  
  -- Log level for debugging
  log_level = 'error',
  
  -- File types to enable on
  file_types = { 'markdown', 'quarto' },
  
  -- Rendering configuration
  render_modes = { 'n', 'v', 'i', 'c' }, -- normal, visual, insert, command
  
  -- Heading configuration
  headings = {
    -- Enable heading rendering
    enabled = true,
    -- Heading signs
    sign = true,
    -- Icons for each heading level
    icons = { '󰲡 ', '󰲣 ', '󰲥 ', '󰲧 ', '󰲩 ', '󰲫 ' },
    -- Background highlight for headings
    backgrounds = {
      'RenderMarkdownH1Bg',
      'RenderMarkdownH2Bg',
      'RenderMarkdownH3Bg',
      'RenderMarkdownH4Bg',
      'RenderMarkdownH5Bg',
      'RenderMarkdownH6Bg',
    },
    -- Foreground highlight for headings
    foregrounds = {
      'RenderMarkdownH1',
      'RenderMarkdownH2',
      'RenderMarkdownH3',
      'RenderMarkdownH4',
      'RenderMarkdownH5',
      'RenderMarkdownH6',
    },
  },
  
  -- Code block configuration
  code = {
    enabled = true,
    sign = true,
    style = 'full', -- 'full', 'normal', 'language', or 'none'
    left_pad = 2,
    right_pad = 2,
    width = 'block', -- 'full', 'block'
    border = 'thin', -- 'thick', 'thin'
    highlight = 'RenderMarkdownCode',
  },
  
  -- Dash/horizontal rule
  dash = {
    enabled = true,
    icon = '─',
    width = 'full', -- 'full' or number
    highlight = 'RenderMarkdownDash',
  },
  
  -- Bullet points
  bullet = {
    enabled = true,
    icons = { '●', '○', '◆', '◇' },
    highlight = 'RenderMarkdownBullet',
  },
  
  -- Checkboxes
  checkbox = {
    enabled = true,
    unchecked = {
      icon = '󰄱 ',
      highlight = 'RenderMarkdownUnchecked',
    },
    checked = {
      icon = '󰱒 ',
      highlight = 'RenderMarkdownChecked',
    },
  },
  
  -- Block quotes
  quote = {
    enabled = true,
    icon = '▋',
    highlight = 'RenderMarkdownQuote',
  },
  
  -- Tables
  pipe_table = {
    enabled = true,
    style = 'full', -- 'full', 'normal', 'none'
    cell = 'padded', -- 'padded', 'raw'
    border = {
      '┌', '┬', '┐',
      '├', '┼', '┤',
      '└', '┴', '┘',
      '│', '─',
    },
  },
  
  -- Callouts (GitHub style)
  callout = {
    note = { raw = '[!NOTE]', rendered = '󰋽 Note', highlight = 'RenderMarkdownInfo' },
    tip = { raw = '[!TIP]', rendered = '󰌶 Tip', highlight = 'RenderMarkdownSuccess' },
    important = { raw = '[!IMPORTANT]', rendered = '󰅾 Important', highlight = 'RenderMarkdownHint' },
    warning = { raw = '[!WARNING]', rendered = '󰀪 Warning', highlight = 'RenderMarkdownWarn' },
    caution = { raw = '[!CAUTION]', rendered = '󰳦 Caution', highlight = 'RenderMarkdownError' },
  },
  
  -- Links
  link = {
    enabled = true,
    image = '󰥶 ',
    hyperlink = '󰌹 ',
    highlight = 'RenderMarkdownLink',
  },
  
  -- Inline code
  inline_code = {
    enabled = true,
    highlight = 'RenderMarkdownCodeInline',
  },
  
  -- LaTeX (math)
  latex = {
    enabled = true,
    converter = 'latex2text', -- 'latex2text' or custom function
    highlight = 'RenderMarkdownMath',
  },
  
  -- Override default handlers to integrate with image.nvim
  overrides = {
    buftype = {
      nofile = {
        padding = { left = 2, right = 2 },
        sign = false,
      },
    },
  },
}
