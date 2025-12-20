-- Tests for utils module
local utils = require("lib.utils")

describe("Utils module", function()
  describe("is_empty", function()
    it("returns true for nil", function()
      assert.is_true(utils.is_empty(nil))
    end)

    it("returns true for empty string", function()
      assert.is_true(utils.is_empty(""))
    end)

    it("returns true for empty table", function()
      assert.is_true(utils.is_empty({}))
    end)

    it("returns false for non-empty string", function()
      assert.is_false(utils.is_empty("hello"))
    end)

    it("returns false for non-empty table", function()
      assert.is_false(utils.is_empty({ a = 1 }))
    end)
  end)

  describe("format_bytes", function()
    it("formats bytes correctly", function()
      assert.equals("1.00 KB", utils.format_bytes(1024))
      assert.equals("1.00 MB", utils.format_bytes(1024 * 1024))
      assert.equals("1.50 KB", utils.format_bytes(1536))
    end)
  end)

  describe("get_extension", function()
    it("extracts file extension", function()
      assert.equals("lua", utils.get_extension("test.lua"))
      assert.equals("txt", utils.get_extension("file.txt"))
      assert.equals("", utils.get_extension("noextension"))
    end)
  end)

  describe("deep_copy", function()
    it("creates a deep copy of table", function()
      local original = { a = 1, b = { c = 2 } }
      local copy = utils.deep_copy(original)

      copy.b.c = 3

      assert.equals(2, original.b.c)
      assert.equals(3, copy.b.c)
    end)
  end)
end)
