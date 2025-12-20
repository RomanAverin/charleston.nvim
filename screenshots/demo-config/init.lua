-- Minimal Neovim config for Charleston colorscheme demo
-- Usage: nvim -u screenshots/demo-config/init.lua

-- Set runtime path to use local charleston
local charleston_path = vim.fn.getcwd()
vim.opt.runtimepath:prepend(charleston_path)

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Plugin specifications
local plugins = {
  -- Charleston colorscheme (local)
  {
    dir = charleston_path,
    name = "charleston",
    priority = 1000,
    config = function()
      require("charleston").setup({
        terminal_colors = true,
        italic = true,
        transparent = false,
      })
      vim.cmd("colorscheme charleston")
    end,
  },

  -- Lualine
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("lualine").setup({
        options = {
          theme = "charleston",
          component_separators = { left = "", right = "" },
          section_separators = { left = "", right = "" },
        },
      })
    end,
  },

  -- Telescope
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = "Telescope",
    keys = {
      { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find Files" },
      { "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Live Grep" },
      { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
    },
  },

  -- Neo-tree
  {
    "nvim-neo-tree/neo-tree.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    cmd = "Neotree",
    keys = {
      { "<leader>e", "<cmd>Neotree toggle<cr>", desc = "Toggle Neo-tree" },
    },
    config = function()
      require("neo-tree").setup({
        close_if_last_window = true,
        window = {
          width = 30,
        },
      })
    end,
  },

  -- Treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = { "lua", "python", "typescript", "rust", "javascript" },
        highlight = { enable = true },
        indent = { enable = true },
      })
    end,
  },

  -- Gitsigns
  {
    "lewis6991/gitsigns.nvim",
    event = "BufReadPre",
    config = function()
      require("gitsigns").setup()
    end,
  },

  -- Which-key (for showing keybindings)
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    config = function()
      require("which-key").setup()
    end,
  },

  -- Mason (LSP installer UI)
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    config = function()
      require("mason").setup()
    end,
  },

  -- Noice (modern UI)
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    },
    config = function()
      require("noice").setup({
        lsp = {
          override = {
            ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
            ["vim.lsp.util.stylize_markdown"] = true,
            ["cmp.entry.get_documentation"] = true,
          },
        },
        presets = {
          bottom_search = true,
          command_palette = true,
          long_message_to_split = true,
        },
      })
    end,
  },

  -- Dashboard (snacks or alpha)
  {
    "folke/snacks.nvim",
    priority = 900,
    lazy = false,
    config = function()
      require("snacks").setup({
        dashboard = {
          enabled = true,
          preset = {
            header = [[
╔═══════════════════════════════════════════╗
║                                           ║
║          Charleston Colorscheme           ║
║                                           ║
║     Dark theme with smooth colors         ║
║                                           ║
╚═══════════════════════════════════════════╝
            ]],
          },
        },
      })
    end,
  },

  -- Bufferline
  {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    config = function()
      require("bufferline").setup({
        options = {
          mode = "buffers",
          separator_style = "thin",
          always_show_bufferline = true,
        },
      })
    end,
  },

  -- Indent-blankline
  {
    "lukas-reineke/indent-blankline.nvim",
    event = "BufReadPre",
    main = "ibl",
    config = function()
      require("ibl").setup()
    end,
  },
}

-- Load lazy.nvim
require("lazy").setup(plugins, {
  install = {
    missing = true,
  },
})

-- General settings
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.signcolumn = "yes"
vim.opt.cursorline = true
vim.opt.termguicolors = true
vim.opt.showmode = false
vim.opt.clipboard = "unnamedplus"

-- Set leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Auto commands for demo
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    -- Show a welcome message
    vim.notify("Charleston Demo Environment Loaded!", "info", {
      title = "Charleston",
    })
  end,
})

-- Helper commands for screenshots
vim.api.nvim_create_user_command("DemoTelescope", function()
  vim.cmd("Telescope find_files")
end, {})

vim.api.nvim_create_user_command("DemoNeotree", function()
  vim.cmd("Neotree toggle")
end, {})

vim.api.nvim_create_user_command("DemoMason", function()
  vim.cmd("Mason")
end, {})

vim.api.nvim_create_user_command("DemoDashboard", function()
  vim.cmd("lua require('snacks').dashboard.open()")
end, {})

vim.api.nvim_create_user_command("DemoSplit", function()
  -- Create split layout for demo
  vim.cmd("vsplit")
  vim.cmd("wincmd l")
  vim.cmd("split")
  vim.cmd("wincmd k")
end, {})

-- Print instructions
print("\n")
print("╔═══════════════════════════════════════════════════════════╗")
print("║  Charleston Screenshot Demo Environment                  ║")
print("╠═══════════════════════════════════════════════════════════╣")
print("║  Commands for screenshots:                                ║")
print("║  :DemoTelescope  - Open Telescope finder                  ║")
print("║  :DemoNeotree    - Toggle Neo-tree file explorer          ║")
print("║  :DemoMason      - Open Mason LSP installer               ║")
print("║  :DemoDashboard  - Show dashboard                         ║")
print("║  :DemoSplit      - Create split layout                    ║")
print("║                                                           ║")
print("║  Keybindings:                                             ║")
print("║  <Space>ff       - Find files                             ║")
print("║  <Space>fg       - Live grep                              ║")
print("║  <Space>e        - Toggle file explorer                   ║")
print("╚═══════════════════════════════════════════════════════════╝")
print("\n")
