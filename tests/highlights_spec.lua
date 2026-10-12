-- Tests for highlights.lua
local colors = require("charleston.colors")
local highlights = require("charleston.highlights")

describe("Highlights", function()
  local palette = colors.palette
  local opts = {
    transparent = false,
    italic = true,
    darker_background = false,
  }

  describe("get function", function()
    it("should return a table", function()
      local result = highlights.get(palette, opts)
      assert(type(result) == "table", "get() should return a table")
    end)

    it("should return non-empty table", function()
      local result = highlights.get(palette, opts)
      assert(next(result) ~= nil, "get() should return non-empty table")
    end)
  end)

  describe("highlight group structure", function()
    it("should have valid highlight group names", function()
      local hl_groups = highlights.get(palette, opts)
      for group_name, _ in pairs(hl_groups) do
        assert(type(group_name) == "string", "Group name should be string: " .. tostring(group_name))
        assert(group_name ~= "", "Group name should not be empty")
      end
    end)

    it("should have valid highlight definitions", function()
      local hl_groups = highlights.get(palette, opts)
      local valid_keys = {
        "fg",
        "bg",
        "sp",
        "bold",
        "italic",
        "underline",
        "undercurl",
        "underdashed",
        "strikethrough",
        "reverse",
        "link",
        "force",
      }

      for group_name, definition in pairs(hl_groups) do
        assert(type(definition) == "table", "Definition should be table for group: " .. group_name)

        for key, value in pairs(definition) do
          -- Check if key is valid
          local is_valid_key = false
          for _, valid_key in ipairs(valid_keys) do
            if key == valid_key then
              is_valid_key = true
              break
            end
          end
          assert(is_valid_key, "Invalid key '" .. key .. "' in group '" .. group_name .. "'")

          -- Check value types
          if key == "link" then
            assert(type(value) == "string", "Link value should be string in group: " .. group_name)
          elseif key == "force" then
            assert(type(value) == "boolean", "Force value should be boolean in group: " .. group_name)
          elseif
            key == "bold"
            or key == "italic"
            or key == "underline"
            or key == "undercurl"
            or key == "underdashed"
            or key == "strikethrough"
            or key == "reverse"
          then
            assert(type(value) == "boolean", key .. " should be boolean in group: " .. group_name)
          elseif key == "fg" or key == "bg" or key == "sp" then
            -- Color values can be strings (hex colors) or references to palette
            assert(type(value) == "string", key .. " should be string in group: " .. group_name)
          end
        end
      end
    end)

    it("should have required base highlight groups", function()
      local hl_groups = highlights.get(palette, opts)
      local required_groups = {
        "Normal",
        "Comment",
        "Constant",
        "String",
        "Character",
        "Number",
        "Boolean",
        "Identifier",
        "Function",
        "Statement",
        "Conditional",
        "Repeat",
        "Label",
        "Operator",
        "Keyword",
        "Exception",
        "PreProc",
        "Include",
        "Define",
        "Macro",
        "PreCondit",
        "Type",
        "Typedef",
        "StorageClass",
        "Structure",
        "Special",
        "SpecialChar",
        "Delimiter",
        "SpecialComment",
        "Underlined",
        "Error",
        "Conceal",
        "Cursor",
        "lCursor",
        "CursorIM",
        "CursorColumn",
        "CursorLine",
        "ColorColumn",
        "Directory",
        "EndOfBuffer",
        "ErrorMsg",
        "Folded",
        "FoldColumn",
        "SignColumn",
        "LineNr",
        "CursorLineNr",
        "MatchParen",
        "ModeMsg",
        "MoreMsg",
        "NonText",
        "NormalFloat",
        "FloatBorder",
        "NormalNC",
        "Pmenu",
        "Question",
        "Search",
        "SpecialKey",
        "StatusLine",
        "StatusLineNC",
        "TabLine",
        "TabLineFill",
        "TabLineSel",
        "Title",
        "VertSplit",
        "Visual",
        "WarningMsg",
        "Whitespace",
        "WinSeparator",
        "WildMenu",
        "Winbar",
        "WinbarNC",
      }

      for _, group in ipairs(required_groups) do
        assert(hl_groups[group] ~= nil, "Required group '" .. group .. "' should be defined")
      end
    end)
  end)

  describe("link validation", function()
    it("should have valid links to existing groups", function()
      local hl_groups = highlights.get(palette, opts)
      for group_name, definition in pairs(hl_groups) do
        if definition.link then
          assert(
            hl_groups[definition.link] ~= nil,
            "Group '" .. group_name .. "' links to non-existent group '" .. definition.link .. "'"
          )
        end
      end
    end)

    it("should not have circular links", function()
      local hl_groups = highlights.get(palette, opts)
      local function check_circular_link(group_name, visited)
        visited = visited or {}
        if visited[group_name] then
          assert(false, "Circular link detected involving '" .. group_name .. "'")
        end

        visited[group_name] = true

        local definition = hl_groups[group_name]
        if definition and definition.link then
          check_circular_link(definition.link, visited)
        end
      end

      for group_name, _ in pairs(hl_groups) do
        check_circular_link(group_name, {})
      end
    end)
  end)

  describe("color references", function()
    it("should use valid color references", function()
      local hl_groups = highlights.get(palette, opts)
      for group_name, definition in pairs(hl_groups) do
        for key, value in pairs(definition) do
          if key == "fg" or key == "bg" or key == "sp" then
            -- Check if it's a valid hex color or palette reference
            if type(value) == "string" then
              -- Check if it's a hex color
              local is_hex = value:match("^#%x%x%x%x%x%x$") or value:match("^#%x%x%x$")
              -- Check if it's a palette reference
              local is_palette_ref = palette[value] ~= nil
              -- Check if it's "NONE"
              local is_none = value == "NONE"

              assert(
                is_hex or is_palette_ref or is_none,
                "Invalid color value '" .. value .. "' in group '" .. group_name .. "' for key '" .. key .. "'"
              )
            end
          end
        end
      end
    end)
  end)

  describe("semantic roles", function()
    local hl = highlights.get(palette, opts)

    it("should not define language-specific groups except Vim commands used by Noice", function()
      local languages = {
        "python",
        "rust",
        "lua",
        "go",
        "typescript",
        "javascript",
        "c",
        "cpp",
        "ruby",
        "java",
        "php",
        "markdown",
        "html",
        "css",
        "json",
        "yaml",
        "toml",
        "vim",
        "sh",
        "bash",
        "zsh",
      }

      for group_name, _ in pairs(hl) do
        for _, lang in ipairs(languages) do
          assert(
            group_name == "@function.macro.vim" or not group_name:match("^@.*%." .. lang .. "$"),
            "Language-specific group '" .. group_name .. "' should not exist"
          )
        end
      end
    end)

    it("should paint every keyword with one color", function()
      local keyword_groups = {
        "Statement",
        "Conditional",
        "Repeat",
        "Label",
        "Exception",
        "StorageClass",
        "PreProc",
        "Include",
        "Define",
        "@keyword",
      }

      for _, group in ipairs(keyword_groups) do
        assert(
          hl[group].fg == hl.Keyword.fg,
          "Group '" .. group .. "' should share the keyword color, got " .. tostring(hl[group].fg)
        )
      end
    end)

    it("should paint every literal value with one color", function()
      local value_groups = {
        "Float",
        "Boolean",
        "SpecialChar",
        "@constructor",
        "@lsp.type.enumMember",
      }

      for _, group in ipairs(value_groups) do
        assert(
          hl[group].fg == hl.Number.fg,
          "Group '" .. group .. "' should share the value color, got " .. tostring(hl[group].fg)
        )
      end
      for _, group in ipairs({ "@operator", "@punctuation.bracket" }) do
        assert(hl[group].fg == palette.silver, "Group '" .. group .. "' should use the punctuation color")
      end
    end)

    it("should paint names that hold data with one color", function()
      local name_groups = { "Constant", "@variable", "@variable.parameter", "@property", "@lsp.type.property" }

      for _, group in ipairs(name_groups) do
        assert(
          hl[group].fg == hl.Identifier.fg,
          "Group '" .. group .. "' should share the data-name color, got " .. tostring(hl[group].fg)
        )
      end
    end)

    it("should distinguish definitions from usages", function()
      assert(hl["@function"].fg == palette.white, "Function definitions should use the definition color")
      assert(hl["@function.call"].fg == palette.cyan, "Function calls should use the call color")
      assert(hl["@function.method.call"].fg == palette.cyan, "Method calls should use the call color")
      assert(
        hl["@lsp.type.function"].fg == palette.cyan,
        "LSP function tokens should use the call color, otherwise semantic tokens repaint call sites"
      )
      assert(
        hl["@lsp.typemod.function.declaration"].fg == palette.white,
        "LSP function declarations should use the definition color"
      )
    end)

    it("should use one color per type role", function()
      local type_groups = { "Type", "Structure", "@type", "@module", "@lsp.type.class", "@lsp.type.namespace" }

      for _, group in ipairs(type_groups) do
        assert(
          hl[group].fg == palette.cyan,
          "Group '" .. group .. "' should share the type color, got " .. tostring(hl[group].fg)
        )
      end
    end)

    it("should keep the code palette limited to the semantic roles", function()
      local core_groups = {
        "String",
        "Character",
        "Number",
        "Boolean",
        "Constant",
        "Identifier",
        "Function",
        "Type",
        "Structure",
        "Keyword",
        "Conditional",
        "Repeat",
        "Statement",
        "Operator",
        "Delimiter",
        "Macro",
        "Comment",
        "@variable",
        "@variable.parameter",
        "@function.call",
        "@punctuation.bracket",
      }

      local seen, count = {}, 0
      for _, group in ipairs(core_groups) do
        local fg = hl[group].fg
        assert(fg ~= nil, "Core syntax group '" .. group .. "' should define a foreground")
        if not seen[fg] then
          seen[fg] = true
          count = count + 1
        end
      end

      -- One color per role in the `syn` table (call and type share cyan,
      -- value and punctuation share silver).
      assert(count <= 8, "Code should use at most 8 role colors, got " .. count)
    end)

    it("should not italicize variables", function()
      assert(hl["@variable"].italic == nil, "Variables should not be italic, it covers most of the buffer")
    end)
  end)

  describe("options handling", function()
    it("should handle transparent option", function()
      local transparent_opts = vim.tbl_extend("force", opts, { transparent = true })
      local hl_groups = highlights.get(palette, transparent_opts)

      -- Check that background colors are set to NONE when transparent
      assert(hl_groups.Normal.bg == "NONE", "Normal.bg should be NONE when transparent")
    end)

    it("should handle italic option", function()
      local italic_opts = vim.tbl_extend("force", opts, { italic = true })
      local hl_groups = highlights.get(palette, italic_opts)

      -- Check that italic comments are enabled
      assert(hl_groups.Comment.italic == true, "Comment should be italic when italic option is true")
    end)

    it("should handle darker_background option", function()
      local darker_opts = vim.tbl_extend("force", opts, { darker_background = true })
      local hl_groups = highlights.get(palette, darker_opts)

      -- Check that background is set to bg instead of bg_dimmed
      assert(hl_groups.Normal.bg == palette.bg, "Normal.bg should use bg when darker_background is true")
    end)
  end)
end)

