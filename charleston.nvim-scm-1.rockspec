local _MODREV, _SPECREV = "scm", "-1"

rockspec_format = "3.0"
package = "charleston.nvim"
version = _MODREV .. _SPECREV

description = {
  summary = "High contrast Neovim colorscheme with low saturation and smooth colors",
  detailed = [[
      Charleston is a clean, dark Neovim theme designed for high contrast
      with low saturation colors. Features include support for many popular
      plugins, customizable palette, transparent background option, and
      comprehensive LSP and treesitter integration. Primarily designed for
      use with LazyVim.
   ]],
  labels = { "neovim", "colorscheme", "theme", "vim" },
  homepage = "https://github.com/RomanAverin/charleston.nvim",
  license = "MIT",
}

dependencies = {
  "lua >= 5.1",
}

test_dependencies = {
  "lua >= 5.1",
}

source = {
  url = "git+https://github.com/RomanAverin/charleston.nvim.git",
}

build = {
  type = "builtin",
  copy_directories = {
    "colors",
    "doc",
    "extras",
  },
}
