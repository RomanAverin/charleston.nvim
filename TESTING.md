# Testing

This document describes the testing setup for charleston.nvim.

## Unit Tests

The project includes comprehensive unit tests for highlight definitions located in the `tests/` directory.

### Running Tests

To run the unit tests:

```bash
./run-tests.sh
```

Or directly with Lua:

```bash
lua tests/init.lua
```

### Test Structure

- `tests/init.lua` - Test runner and framework setup
- `tests/highlights_spec.lua` - Tests for highlight definitions

### What Tests Cover

1. **Structure validation**: Ensures highlight groups have correct structure and valid keys
2. **Required groups**: Verifies all standard Neovim highlight groups are defined
3. **Link validation**: Checks that highlight group links reference existing groups
4. **Circular link detection**: Prevents circular references in highlight links
5. **Color validation**: Ensures color values are valid hex colors or palette references
6. **Options handling**: Tests theme options (transparent, italic, darker_background)

### Adding New Tests

To add new tests, create a new file in the `tests/` directory following the naming convention `*_spec.lua`. Use the provided test framework functions:

- `describe(name, fn)` - Group related tests
- `it(description, fn)` - Individual test case
- `assert(condition, message)` - Assertion with optional message

Example:

```lua
describe("New Feature", function()
  it("should work correctly", function()
    assert(some_condition, "Expected condition to be true")
  end)
end)
```

## CI Integration

Tests are automatically run in CI on both Ubuntu and macOS platforms via GitHub Actions. The workflow is defined in `.github/workflows/neovim.yml`.