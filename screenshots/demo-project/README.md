# Charleston Demo Project

This is a demo project for showcasing the **Charleston** Neovim colorscheme.

## Features

- Beautiful dark theme with smooth colors
- High contrast for better readability
- Support for popular plugins
- Tree-sitter syntax highlighting

## Project Structure

```
demo-project/
├── src/            # Source files
│   └── main.lua    # Main application
├── lib/            # Library modules
│   ├── config.lua  # Configuration
│   └── utils.lua   # Utilities
├── tests/          # Test files
│   └── test_utils.lua
└── README.md       # This file
```

## Supported Plugins

- **Telescope** - Fuzzy finder
- **Neo-tree** - File explorer
- **Lualine** - Status line
- **Treesitter** - Better syntax highlighting
- **Gitsigns** - Git integration
- **Mason** - LSP installer
- **Noice** - Modern UI

## Installation

```lua
{
  "romanaverin/charleston.nvim",
  name = "charleston",
  priority = 1000,
  config = function()
    require("charleston").setup()
    vim.cmd("colorscheme charleston")
  end,
}
```

## Color Palette

| Color   | Hex     | Usage                    |
|---------|---------|--------------------------|
| Red     | #cc6666 | Errors, warnings         |
| Green   | #A9C476 | Success, strings         |
| Yellow  | #D0AB3C | Warnings, highlights     |
| Blue    | #88ABDC | Functions, keywords      |
| Magenta | #B689BC | Constants, special       |
| Cyan    | #7fb2c8 | Types, classes           |

## License

MIT License
