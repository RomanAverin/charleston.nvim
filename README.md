# "Charleston" dark theme for neovim
![Screenshot From 2025-10-16 20-56-45 (Edit)](https://github.com/user-attachments/assets/c5a89833-15d4-40d2-8286-7fb715a5579f)
![Screenshot From 2025-10-16 20-58-16 (Edit)](https://github.com/user-attachments/assets/d922f452-9d0a-4fe8-99ab-6e623deac06c)
![Screenshot From 2025-10-16 20-58-38 (Edit)](https://github.com/user-attachments/assets/b41e8bf0-4a60-4baa-8ee3-6d606f95c0de)


## Features

- High contrast color theme with a low saturation and smooth colors
- Many plugins supported
- Italic font style option

> [!WARNING]
> The color scheme is under deep development.
> But it will be very useful to get feedback.

## Roadmap

- ✅ Transparent supported (with enhanced terminal compatibility)

## Requirements

- neovim >= 0.8

## Supported plugins

- NeoTree
- blink.cmp
- diffveiw.nvim
- fzf-lua
- gitsings.nvim
- noice.nvim
- render-markdown.nvim
- snacks.nvim
- telescope.nvim
- neogit

## Install

Only use with lazy plugin manager:

```lua
{
    "romanaverin/charleston.nvim",
    name = "charleston",
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
  darken_background = false, -- use more darker background
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
