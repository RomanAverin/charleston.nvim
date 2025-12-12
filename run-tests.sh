#!/bin/bash

# Test runner script for charleston.nvim
# This script runs the unit tests using plain Lua

echo "Running charleston.nvim tests..."
echo

# Run tests with plain Lua (not Neovim)
lua tests/init.lua

# Check exit code
if [ $? -eq 0 ]; then
    echo
    echo "✓ All tests passed!"
    exit 0
else
    echo
    echo "✗ Some tests failed!"
    exit 1
fi