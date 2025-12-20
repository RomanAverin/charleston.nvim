#!/usr/bin/env -S nvim -l

-- Screenshot generator for Charleston colorscheme
-- This script runs in headless Neovim and generates screenshots

local args = arg or {...}

local config = {
  output_dir = "screenshots/output",
  width = 80,
  height = 30,
  font_size = 14,
  line_offset = 1,
}

-- Parse command line arguments
local function parse_args()
  local file_path = nil
  local skip_next = false
  local value_flags = {["--width"] = true, ["--height"] = true, ["--output"] = true}

  for i, arg in ipairs(args) do
    if skip_next then
      skip_next = false
    elseif arg == "--width" then
      config.width = tonumber(args[i + 1])
      skip_next = true
    elseif arg == "--height" then
      config.height = tonumber(args[i + 1])
      skip_next = true
    elseif arg == "--output" then
      config.output_dir = args[i + 1]
      skip_next = true
    elseif arg == "--help" then
      print([[
Usage: nvim -l screenshot.lua [options] <file>

Options:
  --width <num>    Set window width (default: 80)
  --height <num>   Set window height (default: 30)
  --output <dir>   Output directory (default: screenshots/output)
  --help          Show this help message

Example:
  nvim -l screenshot.lua --width 100 --height 40 example.lua
]])
      os.exit(0)
    elseif not arg:match("^%-%-") then
      file_path = arg
    end
  end

  return file_path
end

-- Setup Neovim environment
local function setup_neovim()
  -- Set options for clean output
  vim.opt.number = true
  vim.opt.relativenumber = false
  vim.opt.signcolumn = "no"
  vim.opt.foldcolumn = "0"
  vim.opt.cursorline = false
  vim.opt.wrap = false
  vim.opt.list = false

  -- Load colorscheme
  pcall(function()
    vim.cmd("colorscheme charleston")
  end)

  -- Set window dimensions
  vim.opt.columns = config.width
  vim.opt.lines = config.height
end

-- Generate HTML from current buffer
local function generate_html(output_file)
  -- Use TOhtml to generate HTML with syntax highlighting
  vim.cmd("TOhtml")

  -- Get the HTML buffer
  local html_bufnr = vim.api.nvim_get_current_buf()
  local html_lines = vim.api.nvim_buf_get_lines(html_bufnr, 0, -1, false)

  -- Write to file
  local file = io.open(output_file, "w")
  if file then
    file:write(table.concat(html_lines, "\n"))
    file:close()
    print("HTML generated: " .. output_file)
  else
    error("Failed to write HTML file: " .. output_file)
  end

  -- Close HTML buffer
  vim.cmd("bdelete!")
end

-- Export terminal colors for external tools
local function export_colors()
  local colors = {}

  -- Try to get colors from charleston theme
  local ok, charleston = pcall(require, "charleston")
  if ok and charleston.get_palette then
    colors = charleston.get_palette()
  else
    -- Fallback colors
    colors = {
      bg = "#1D2024",
      fg = "#C5C8D3",
      red = "#cc6666",
      green = "#A9C476",
      yellow = "#D0AB3C",
      blue = "#88ABDC",
      magenta = "#B689BC",
      cyan = "#7fb2c8",
    }
  end

  local export_file = config.output_dir .. "/colors.json"
  local file = io.open(export_file, "w")
  if file then
    file:write(vim.json.encode(colors))
    file:close()
    print("Colors exported: " .. export_file)
  end

  return colors
end

-- Main function
local function main()
  local file_path = parse_args()

  if not file_path then
    print("Error: No input file specified")
    print("Use --help for usage information")
    os.exit(1)
  end

  -- Check if file exists
  local file = io.open(file_path, "r")
  if not file then
    print("Error: File not found: " .. file_path)
    os.exit(1)
  end
  file:close()

  -- Setup Neovim
  setup_neovim()

  -- Create output directory if it doesn't exist
  vim.fn.mkdir(config.output_dir, "p")

  -- Export colors
  export_colors()

  -- Open the file
  vim.cmd("edit " .. file_path)

  -- Wait for file to load and syntax to be applied
  vim.wait(1000)

  -- Generate output filename
  local basename = vim.fn.fnamemodify(file_path, ":t:r")
  local output_html = config.output_dir .. "/" .. basename .. ".html"

  -- Generate HTML
  generate_html(output_html)

  print("Screenshot generation complete!")

  -- Exit
  vim.cmd("quitall!")
end

-- Run main function
local status, err = pcall(main)
if not status then
  print("Error: " .. tostring(err))
  os.exit(1)
end
