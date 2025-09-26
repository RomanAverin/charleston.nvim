# "Charleston" dark theme for neovim

![Screenshot From 2025-03-18 23-34-44](https://github.com/user-attachments/assets/8986ee3a-7fe7-48ec-a27e-3d15602f80a5)
![Screenshot From 2025-03-18 23-35-16](https://github.com/user-attachments/assets/6a6ea35e-596f-4556-aa0f-e7eee42c91c8)
![Screenshot From 2025-03-18 23-35-34](https://github.com/user-attachments/assets/7ccb9bc7-6514-4b53-962c-42a574258946)

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
  transparent = false, -- enables transparent background (with full terminal compatibility)
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

## 🔍 Transparency

The Charleston colorscheme now includes enhanced transparency support with full terminal compatibility:

```lua
require("charleston").setup({
  transparent = true,
})
```

### Features

- ✅ **Full Terminal Compatibility**: Works in GUI and terminal modes
- ✅ **Automatic Processing**: All transparent groups receive proper `guibg=NONE` and `ctermbg=NONE` attributes
- ✅ **Backward Compatibility**: Works with older Neovim/Vim versions
- ✅ **Terminal Independence**: Consistent behavior across different terminal emulators

### Testing

Run the included test to verify transparency works correctly:

```vim
:source test_transparency.lua
```

See `TRANSPARENCY_FIX.md` for technical details about the transparency implementation.

## 🍭 Extras

Themes for other app. In the extras folder.
