# "Charleston" dark theme for neovim
![Screenshot From 2025-03-18 23-34-44](https://github.com/user-attachments/assets/8986ee3a-7fe7-48ec-a27e-3d15602f80a5)
![Screenshot From 2025-03-18 23-35-16](https://github.com/user-attachments/assets/6a6ea35e-596f-4556-aa0f-e7eee42c91c8)
![Screenshot From 2025-03-18 23-35-34](https://github.com/user-attachments/assets/7ccb9bc7-6514-4b53-962c-42a574258946)

## Features

- High contrast color theme with a low saturation and smooth colors
- Many plugins supported
- Italic
  

> [!WARNING]
> The color scheme is under deep development.
> But it will be very useful to get feedback.

## Roadmap

- Transparent supported

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

## Install

Only use with lazy plugin manager:

```lua
{
    "romanaverin/charleston.nvim",
    name = "charleston",
    priority = 1000,
    opts = {},
  },
}
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
  dimmed_background = false, -- use more dim background
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
