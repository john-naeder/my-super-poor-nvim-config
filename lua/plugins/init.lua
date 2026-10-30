return {
  {
    "christoomey/vim-tmux-navigator",
    cmd = {
      "TmuxNavigateLeft",
      "TmuxNavigateDown",
      "TmuxNavigateUp",
      "TmuxNavigateRight",
      "TmuxNavigatePrevious",
      "TmuxNavigatorProcessList",
    },
    event = "VeryLazy",
    keys = {
      { "<c-h>", "<cmd><C-U>TmuxNavigateLeft<cr>" },
      { "<c-j>", "<cmd><C-U>TmuxNavigateDown<cr>" },
      { "<c-k>", "<cmd><C-U>TmuxNavigateUp<cr>" },
      { "<c-l>", "<cmd><C-U>TmuxNavigateRight<cr>" },
      { "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>" },
    },
  },
  {
    "3rd/image.nvim",
    -- Disabled for WSL/VSCode - these don't support graphics protocols
    enabled = false,
    ft = { 'markdown', 'quarto', 'vimwiki' },
    dependencies = {
      {
        "vhyrro/luarocks.nvim",
        priority = 1001,
        opts = {
          rocks = { "magick" },
        },
      },
    },
    config = function()
      -- Check if WSL or VSCode terminal
      local is_wsl = vim.fn.has('wsl') == 1 or vim.fn.readfile('/proc/version')[1]:match('microsoft')
      local is_vscode = vim.env.VSCODE ~= nil or vim.env.TERM_PROGRAM == 'vscode'
      
      if is_wsl or is_vscode then
        vim.notify(
          "Image rendering not supported in WSL/VSCode terminal.\n" ..
          "Use :MarkdownPreview to view images in browser instead.",
          vim.log.levels.INFO
        )
        return
      end
      
      -- Auto-detect best backend
      local backend = "kitty"
      
      -- Check if in tmux
      if vim.env.TMUX then
        local handle = io.popen("tmux show -g allow-passthrough 2>/dev/null")
        if handle then
          local result = handle:read("*a")
          handle:close()
          if not result:match("on") then
            vim.notify(
              "Image rendering disabled: tmux needs 'set -g allow-passthrough on'.\n" ..
              "Add to ~/.tmux.conf and reload: tmux source ~/.tmux.conf",
              vim.log.levels.WARN
            )
            return
          end
        end
      end
      
      -- Setup image.nvim with detected backend
      require("image").setup({
        backend = backend,
        integrations = {
          markdown = {
            enabled = true,
            clear_in_insert_mode = false,
            download_remote_images = true,
            only_render_image_at_cursor = false,
          },
        },
        max_width = nil,
        max_height = nil,
        max_width_window_percentage = nil,
        max_height_window_percentage = 50,
        window_overlap_clear_enabled = false,
        window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "" },
        editor_only_render_when_focused = false,
        tmux_show_only_in_active_window = false,
        hijack_file_patterns = { "*.png", "*.jpg", "*.jpeg", "*.gif", "*.webp", "*.svg" },
      })
    end,
  },
  {
    "iamcco/markdown-preview.nvim",
    build = ":call mkdp#util#install()",
    ft = { "markdown" },
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    init = function()
      vim.g.mkdp_auto_close = 0
      vim.g.mkdp_echo_preview_url = 1
      vim.g.mkdp_theme = 'dark'
      
      if vim.fn.has('wsl') == 1 then
        vim.g.mkdp_browser = 'firefox'
      end
    end,
  },
  {
    'MeanderingProgrammer/render-markdown.nvim',
    dependencies = { 
      'nvim-treesitter/nvim-treesitter', 
      'nvim-tree/nvim-web-devicons',
    },
    ft = { 'markdown', 'quarto' },
    ---@module 'render-markdown'
    ---@type render.md.UserConfig
    opts = function()
      return require("configs.render-markdown")
    end,
    cmd = { 'RenderMarkdown' },
    keys = {
      { '<leader>mt', '<cmd>RenderMarkdown toggle<cr>', desc = 'Toggle Markdown Render', ft = 'markdown' },
      { '<leader>me', '<cmd>RenderMarkdown enable<cr>', desc = 'Enable Markdown Render', ft = 'markdown' },
      { '<leader>md', '<cmd>RenderMarkdown disable<cr>', desc = 'Disable Markdown Render', ft = 'markdown' },
    },
  },
  {
    "kylechui/nvim-surround",
    version = "*",
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup()
    end,
  },
  {
    "rcarriga/nvim-notify",
    opts = {
      timeout = 2500,
      max_height = function()
        return math.floor(vim.o.lines * 0.75)
      end,
      max_width = function()
        return math.floor(vim.o.columns * 0.75)
      end,
      background_colour = "#000000",
    },
  },
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    },
    config = function()
      require("noice").setup(require("configs.noice-nvim"))

      -- The output split keeps old messages; clear it before each `:!cmd`
      -- so it only shows the latest run (full log stays in :Noice history).
      vim.api.nvim_create_autocmd("CmdlineLeave", {
        group = vim.api.nvim_create_augroup("NoiceShellOutput", { clear = true }),
        callback = function()
          if vim.v.event.abort or vim.fn.getcmdtype() ~= ":" then
            return
          end
          if vim.fn.getcmdline():match("^%s*!") then
            require("noice").cmd("dismiss")
          end
        end,
      })
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false, -- main branch does not support lazy-loading
    build = ":TSUpdate",
    config = function()
      require("configs.treesitter")
    end,
  },

  -- Lspconfig
  {
    "neovim/nvim-lspconfig",
    opts = {
      setup = {
        rust_analyzer = function()
          return true
        end,
      },
    },
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("nvchad.configs.lspconfig").defaults()
      require("configs.lspconfig")
    end,
  },

  {
    "williamboman/mason-lspconfig.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-lspconfig" },
    config = function()
      require("configs.mason-lspconfig")
    end,
  },

  -- Linting
  {
    "mfussenegger/nvim-lint",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("configs.lint")
    end,
  },

  {
    "rshkarin/mason-nvim-lint",
    event = "VeryLazy",
    dependencies = { "nvim-lint" },
    config = function()
      require("configs.mason-lint")
    end,
  },

  {
    "MysticalDevil/inlay-hints.nvim",
    event = "LspAttach",
    dependencies = { "neovim/nvim-lspconfig" },
    config = function()
      require("inlay-hints").setup({
        commands = { enable = false },
        autocmd = { enable = false },
      })
    end,
  },

  -- Conform
  {
    "stevearc/conform.nvim",
    event = "BufWritePre",
    config = function()
      require("configs.conform")
    end,
  },

  {
    "zapling/mason-conform.nvim",
    event = "VeryLazy",
    dependencies = { "conform.nvim" },
    config = function()
      require("configs.mason-conform")
    end,
  },

  -- Rust
  {
    "mrcjkb/rustaceanvim",
    version = "^5",
    lazy = false,
    ft = { "rust" },
    config = function()
      require("configs.rustaceanvim")
    end,
  },

  {
    "saecki/crates.nvim",
    ft = { "toml" },
    config = function(_, opts)
      local crates = require("crates")
      crates.setup(opts)
      require("cmp").setup.buffer({
        sources = { { name = "crates" } },
      })
      crates.show()
    end,
  },

  -- Dap
  {
    "mfussenegger/nvim-dap",
    config = function()
      require("configs.nvim-dap")
    end,
  },

  {
    "rcarriga/nvim-dap-ui",
    event = "VeryLazy",
    dependencies = "mfussenegger/nvim-dap",
    config = function()
      require("dapui").setup()
      local dap, dapui = require("dap"), require("dapui")

      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end
    end,
  },

  {
    "theHamsta/nvim-dap-virtual-text",
    config = function()
      require("nvim-dap-virtual-text").setup()
    end,
  },

  {
    "jay-babu/mason-nvim-dap.nvim",
    event = "VeryLazy",
    dependencies = {
      "williamboman/mason.nvim",
      "mfussenegger/nvim-dap",
    },
    opts = {
      ensure_installed = {
        "codelldb",
        "lldb-vscode",
        "debugpy",
      },
      automatic_installation = true,
    },
    config = function(_, opts)
      require("mason-nvim-dap").setup(opts)
    end,
  },
  {
    "nvim-neotest/nvim-nio",
  },

  -- Jump around
  {
    "smoka7/hop.nvim",
    opts = {
      keys = "etovxqpdygfblzhckisuran",
      multi_window = true,
      uppercase_labels = true,
    },
  },

  -- JSON/YAML Schema Store
  {
    "b0o/schemastore.nvim",
    lazy = true,
  },
}
