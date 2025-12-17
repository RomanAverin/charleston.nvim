<h1 align="center">
Charleston color theme for neovim
<img width="512" height="512" alt="charleston_logo" src="https://github.com/user-attachments/assets/cb96efe8-aed0-4ef3-8cdb-07bde9a361af" />
</h3>

## 📸 Screenshots

<details>
<p align="center">
<img src="https://github.com/user-attachments/assets/c5a89833-15d4-40d2-8286-7fb715a5579f"</img>
<img src="https://github.com/user-attachments/assets/d922f452-9d0a-4fe8-99ab-6e623deac06c"</img>
<img src="https://github.com/user-attachments/assets/b41e8bf0-4a60-4baa-8ee3-6d606f95c0de"</img>
</p>
</details>

## ✨ Features

- High contrast color theme with a low saturation and smooth colors
- Many plugins supported
- Italic font style option
- Transparent supported
- Mainly designed for use with lazyvim

> [!WARNING]
> The color scheme is under deep development.
> But it will be very useful to get feedback.

## 🗺️ Roadmap

- ✅ ~~Transparent supported (with enhanced terminal compatibility)~~
- ✅ ~~Customization colors~~

## 📋 Requirements

- neovim >= 0.9

## 🔌 Supported plugins

- [neo-tree.nvim](https://github.com/nvim-neo-tree/neo-tree.nvim)
- [blink.cmp](https://github.com/Saghen/blink.cmp)
- [bufferline.nvim](https://github.com/akinsho/bufferline.nvim)
- [diffview.nvim](https://github.com/sindrets/diffview.nvim)
- [fzf-lua](https://github.com/ibhagwan/fzf-lua)
- [gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim)
- [noice.nvim](https://github.com/folke/noice.nvim)
- [render-markdown.nvim](https://github.com/MeanderingProgrammer/render-markdown.nvim)
- [snacks.nvim](https://github.com/folke/snacks.nvim)
- [telescope.nvim](https://github.com/nvim-telescope/telescope.nvim)
- [neogit](https://github.com/NeogitOrg/neogit)

## 📦 Install

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
    version = "1.8.0", -- or use "*" for the latest in the main branch
    priority = 1000,
},
```

## 🚀 Usage

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

Force compile cache
`: CharlestonCompile`

## ⚙️ Options

To configure options, add `opts` to the plugin declaration:

```lua
opts = {
  terminal_colors = true, -- sets terminal colors
  italic = true, -- use italic font style
  darker_background = false, -- use more darker background
  transparent = false, -- enable transparent background
  palette_overrides = {}, -- override palette colors
}
```

## 🎨 Customization

Charleston supports customization of the color palette through `palette_overrides`.

### Palette Customization

You can override any color from the palette or add custom colors:

```lua
{
  "romanaverin/charleston.nvim",
  name = "charleston",
  priority = 1000,
  opts = {
    palette_overrides = {
      -- Override existing colors
      red = "#ff0000",
      bg = "#000000",
      bg_dimmed = "#0a0a0a",

      -- Add custom colors for use with other plugins(example below)
      my_custom_color = "#abcdef",
    }
  }
}
```

All overrides are fully cached for maximum performance.

### Integration with Other Plugins

You can use `get_palette()` to access the customized palette in other plugins:

```lua
{
  "romanaverin/charleston.nvim",
  name = "charleston",
  priority = 1000,
  opts = {
    palette_overrides = {
      statusline_bg = "#2a2a2a",
    }
  }
}

-- In your lualine config
local colors = require("charleston").get_palette()

require("lualine").setup({
  options = {
    theme = {
      normal = {
        a = { bg = colors.blue, fg = colors.bg },
        b = { bg = colors.statusline_bg, fg = colors.text },
      }
    }
  }
})
```

### Available Colors

<details>
<summary>Click to see the full color palette</summary>

#### Main Palette Colors

| Color Name       | Hex Value | Preview                                                                   |
| ---------------- | --------- | ------------------------------------------------------------------------- |
| `red`            | `#cc6666` | ![#cc6666](https://img.shields.io/badge/-cc6666-cc6666) |
| `green`          | `#A9C476` | ![#A9C476](https://img.shields.io/badge/-A9C476-A9C476) |
| `yellow`         | `#D0AB3C` | ![#D0AB3C](https://img.shields.io/badge/-D0AB3C-D0AB3C) |
| `blue`           | `#88ABDC` | ![#88ABDC](https://img.shields.io/badge/-88ABDC-88ABDC) |
| `magenta`        | `#B689BC` | ![#B689BC](https://img.shields.io/badge/-B689BC-B689BC) |
| `cyan`           | `#7fb2c8` | ![#7fb2c8](https://img.shields.io/badge/-7fb2c8-7fb2c8) |
| `charcoal`       | `#708499` | ![#708499](https://img.shields.io/badge/-708499-708499) |
| `teal`           | `#749689` | ![#749689](https://img.shields.io/badge/-749689-749689) |
| `beige`          | `#EFC986` | ![#EFC986](https://img.shields.io/badge/-EFC986-EFC986) |
| `orange`         | `#de935f` | ![#de935f](https://img.shields.io/badge/-de935f-de935f) |
| `purple`         | `#b08cba` | ![#b08cba](https://img.shields.io/badge/-b08cba-b08cba) |
| `silver`         | `#acbcc3` | ![#acbcc3](https://img.shields.io/badge/-acbcc3-acbcc3) |
| `cambridge_blue` | `#99C1B9` | ![#99C1B9](https://img.shields.io/badge/-99C1B9-99C1B9) |
| `english_violet` | `#59546C` | ![#59546C](https://img.shields.io/badge/-59546C-59546C) |

#### Base Colors

| Color Name          | Hex Value | Preview                                                                   |
| ------------------- | --------- | ------------------------------------------------------------------------- |
| `bg`                | `#1D2024` | ![#1D2024](https://img.shields.io/badge/-1D2024-1D2024) |
| `bg_dimmed`         | `#262B31` | ![#262B31](https://img.shields.io/badge/-262B31-262B31) |
| `text`              | `#C5C8D3` | ![#C5C8D3](https://img.shields.io/badge/-C5C8D3-C5C8D3) |
| `strong_text`       | `#80838f` | ![#80838f](https://img.shields.io/badge/-80838f-80838f) |
| `faded_text`        | `#686d75` | ![#686d75](https://img.shields.io/badge/-686d75-686d75) |
| `strong_faded_text` | `#464b50` | ![#464b50](https://img.shields.io/badge/-464b50-464b50) |
| `medium_backgroud`  | `#51545C` | ![#51545C](https://img.shields.io/badge/-51545C-51545C) |

#### UI Elements

| Color Name       | Hex Value | Preview                                                                   |
| ---------------- | --------- | ------------------------------------------------------------------------- |
| `thin_line`      | `#363E47` | ![#363E47](https://img.shields.io/badge/-363E47-363E47) |
| `thick_line`     | `#5F6366` | ![#5F6366](https://img.shields.io/badge/-5F6366-5F6366) |
| `float_bg`       | `#30353b` | ![#30353b](https://img.shields.io/badge/-30353b-30353b) |
| `bar_bg`         | `#2c323c` | ![#2c323c](https://img.shields.io/badge/-2c323c-2c323c) |
| `bar_text`       | `#b5bac8` | ![#b5bac8](https://img.shields.io/badge/-b5bac8-b5bac8) |
| `bar_faded_text` | `#70757d` | ![#70757d](https://img.shields.io/badge/-70757d-70757d) |
| `white`          | `#ffffff` | ![#ffffff](https://img.shields.io/badge/-ffffff-ffffff) |
| `darker_gray`    | `#2c323c` | ![#2c323c](https://img.shields.io/badge/-2c323c-2c323c) |
| `medium_gray`    | `#515151` | ![#515151](https://img.shields.io/badge/-515151-515151) |
| `lighter_gray`   | `#3e4452` | ![#3e4452](https://img.shields.io/badge/-3e4452-3e4452) |

#### Git Colors

| Color Name       | Hex Value | Preview                                                                   |
| ---------------- | --------- | ------------------------------------------------------------------------- |
| `diff_add_bg`    | `#3a413b` | ![#3a413b](https://img.shields.io/badge/-3a413b-3a413b) |
| `diff_delete_bg` | `#443c3f` | ![#443c3f](https://img.shields.io/badge/-443c3f-443c3f) |

#### Terminal Colors

| Color Name      | Hex Value | Preview                                                                   |
| --------------- | --------- | ------------------------------------------------------------------------- |
| `brightBlack`   | `#636363` | ![#636363](https://img.shields.io/badge/-636363-636363) |
| `brightRed`     | `#a04041` | ![#a04041](https://img.shields.io/badge/-a04041-a04041) |
| `brightGreen`   | `#8b9440` | ![#8b9440](https://img.shields.io/badge/-8b9440-8b9440) |
| `brightYellow`  | `#ec9c62` | ![#ec9c62](https://img.shields.io/badge/-ec9c62-ec9c62) |
| `brightBlue`    | `#5d7f9a` | ![#5d7f9a](https://img.shields.io/badge/-5d7f9a-5d7f9a) |
| `brightMagenta` | `#b689bC` | ![#b689bC](https://img.shields.io/badge/-b689bC-b689bC) |
| `brightCyan`    | `#5e8d87` | ![#5e8d87](https://img.shields.io/badge/-5e8d87-5e8d87) |
| `brightWhite`   | `#6d757d` | ![#6d757d](https://img.shields.io/badge/-6d757d-6d757d) |

</details>

See `lua/charleston/colors.lua` for the complete reference.

## 🎯 Lualine

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
