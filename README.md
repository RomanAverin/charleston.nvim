# "Charleston" dark theme for neovim

[![Create Release](https://github.com/RomanAverin/charleston.nvim/actions/workflows/release.yml/badge.svg)](https://github.com/RomanAverin/charleston.nvim/actions/workflows/release.yml)

![Screenshot From 2025-10-16 20-56-45 (Edit)](https://github.com/user-attachments/assets/c5a89833-15d4-40d2-8286-7fb715a5579f)
![Screenshot From 2025-10-16 20-58-16 (Edit)](https://github.com/user-attachments/assets/d922f452-9d0a-4fe8-99ab-6e623deac06c)
![Screenshot From 2025-10-16 20-58-38 (Edit)](https://github.com/user-attachments/assets/b41e8bf0-4a60-4baa-8ee3-6d606f95c0de)

## Features

- High contrast color theme with a low saturation and smooth colors
- Many plugins supported
- Italic font style option
- Transparent supported

> [!WARNING]
> The color scheme is under deep development.
> But it will be very useful to get feedback.

## Roadmap

- ✅ ~~Transparent supported (with enhanced terminal compatibility)~~
- Customization colors

## Requirements

- neovim >= 0.8

## Supported plugins

- [neo-tree.nvim](https://github.com/nvim-neo-tree/neo-tree.nvim)
- [blink.cmp](https://github.com/Saghen/blink.cmp)
- [diffview.nvim](https://github.com/sindrets/diffview.nvim)
- [fzf-lua](https://github.com/ibhagwan/fzf-lua)
- [gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim)
- [noice.nvim](https://github.com/folke/noice.nvim)
- [render-markdown.nvim](https://github.com/MeanderingProgrammer/render-markdown.nvim)
- [snacks.nvim](https://github.com/folke/snacks.nvim)
- [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim)
- [neogit](https://github.com/NeogitOrg/neogit)

## Install

Only use with lazy plugin manager:

```lua
{
    "romanaverin/charleston.nvim",
    name = "charleston",
    priority = 1000,
},
```

To use a specific version:

```lua
{
    "romanaverin/charleston.nvim",
    name = "charleston",
    version = "1.5.0", -- or use "*" for the latest release
    priority = 1000,
},
```

## Usage

Lazy:

```lua
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "charleston",
    },
  },
```

Or:

```lua
vim.cmd.colorscheme "charleston"
```

## Options

To configure options, add `opts` to the plugin declaration:

```lua
opts = {
  terminal_colors = true, -- sets terminal colors
  italic = true, -- use italic font style
  darker_background = false, -- use more darker background
  transparent = false, -- enable transparent background
}
```

For the lualine add this

```lua
require('lualine').setup {
    options = {
        theme = "charleston"
        -- ... the rest of your lualine config
    }
}
```

## 🍭 Extras

Themes for other app. In the extras folder.
