#!/usr/bin/env bash

# Screenshot generator for Charleston colorscheme
# Supports multiple screenshot methods: neovim-html, silicon, freeze

set -euo pipefail

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
EXAMPLES_DIR="$PROJECT_DIR/screenshots/examples"
OUTPUT_DIR="$PROJECT_DIR/screenshots/output"
TEMP_DIR="/tmp/charleston-screenshots-$$"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Default settings
METHOD="auto"
WIDTH=100
HEIGHT=40
FONT_SIZE=16
FONT_FAMILY="Fira Mono"

# Print colored message
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Show help
show_help() {
    cat << EOF
Charleston Screenshot Generator

Usage: $0 [OPTIONS] [FILES...]

Options:
    -m, --method METHOD     Screenshot method: auto, nvim, silicon, freeze (default: auto)
    -w, --width WIDTH       Screenshot width in characters (default: 100)
    -h, --height HEIGHT     Screenshot height in lines (default: 40)
    -f, --font-size SIZE    Font size (default: 16)
    --font FONT             Font family (default: JetBrains Mono)
    -o, --output DIR        Output directory (default: screenshots/output)
    --help                  Show this help message

Methods:
    auto      - Automatically detect available tool
    nvim      - Use Neovim with HTML export
    silicon   - Use silicon (requires: cargo install silicon)
    freeze    - Use freeze (requires: go install github.com/charmbracelet/freeze@latest)

Examples:
    # Generate screenshots for all examples
    $0

    # Generate screenshot for specific file
    $0 screenshots/examples/example.lua

    # Use specific method
    $0 --method silicon

    # Custom dimensions
    $0 --width 120 --height 50

EOF
}

# Check if command exists
command_exists() {
    command -v "$1" &> /dev/null
}

# Detect best available method
detect_method() {
    if command_exists freeze; then
        echo "freeze"
    elif command_exists silicon; then
        echo "silicon"
    elif command_exists nvim; then
        echo "nvim"
    else
        log_error "No screenshot tool available. Install freeze, silicon, or neovim."
        exit 1
    fi
}

# Export Charleston colors to theme file
export_charleston_theme() {
    local theme_file="$1"

    cat > "$theme_file" << 'EOF'
{
  "name": "Charleston",
  "author": "Roman Averin",
  "background": "#1D2024",
  "foreground": "#C5C8D3",
  "black": "#1D2024",
  "red": "#cc6666",
  "green": "#A9C476",
  "yellow": "#D0AB3C",
  "blue": "#88ABDC",
  "magenta": "#B689BC",
  "cyan": "#7fb2c8",
  "white": "#C5C8D3",
  "bright-black": "#636363",
  "bright-red": "#a04041",
  "bright-green": "#8b9440",
  "bright-yellow": "#ec9c62",
  "bright-blue": "#5d7f9a",
  "bright-magenta": "#b689bC",
  "bright-cyan": "#5e8d87",
  "bright-white": "#6d757d",
  "selection-background": "#363E47",
  "selection-foreground": "#C5C8D3",
  "cursor": "#C5C8D3",
  "cursor-text": "#1D2024"
}
EOF
}

# Generate screenshot using Neovim
screenshot_nvim() {
    local input_file="$1"
    local output_file="$2"

    log_info "Generating screenshot with Neovim: $(basename "$input_file")"

    # Run Lua script
    nvim -l "$SCRIPT_DIR/screenshot.lua" \
        --width "$WIDTH" \
        --height "$HEIGHT" \
        --output "$OUTPUT_DIR" \
        "$input_file"

    # The HTML file is generated
    local html_file="${output_file%.png}.html"
    if [[ -f "$html_file" ]]; then
        log_success "HTML generated: $html_file"

        # Optionally convert HTML to PNG using wkhtmltoimage if available
        if command_exists wkhtmltoimage; then
            wkhtmltoimage --quality 100 --width 1200 "$html_file" "$output_file" 2>/dev/null
            log_success "PNG generated: $output_file"
        else
            log_warning "wkhtmltoimage not found. HTML file created instead."
        fi
    fi
}

# Generate screenshot using silicon
screenshot_silicon() {
    local input_file="$1"
    local output_file="$2"

    log_info "Generating screenshot with silicon: $(basename "$input_file")"

    # Create theme file
    local theme_file="$TEMP_DIR/charleston.tmTheme"
    export_charleston_theme "$theme_file"

    silicon \
        --from-clipboard=false \
        --to-clipboard=false \
        --background "#1D2024" \
        --font "$FONT_FAMILY" \
        --shadow-blur-radius 0 \
        --shadow-offset-x 0 \
        --shadow-offset-y 0 \
        --pad-horiz 40 \
        --pad-vert 30 \
        --output "$output_file" \
        "$input_file" 2>/dev/null || {
            log_warning "Silicon failed, trying without custom theme..."
            silicon \
                --from-clipboard=false \
                --to-clipboard=false \
                --background "#1D2024" \
                --font "$FONT_FAMILY" \
                --output "$output_file" \
                "$input_file"
        }

    log_success "Screenshot generated: $output_file"
}

# Generate screenshot using freeze
screenshot_freeze() {
    local input_file="$1"
    local output_file="$2"

    log_info "Generating screenshot with freeze: $(basename "$input_file")"

    freeze \
        --output "$output_file" \
        --background "#1D2024" \
        --font.family "$FONT_FAMILY" \
        --font.size "$FONT_SIZE" \
        --width "$WIDTH" \
        --height "$HEIGHT" \
        --window=false \
        --show-line-numbers \
        "$input_file"

    log_success "Screenshot generated: $output_file"
}

# Generate screenshot using detected method
generate_screenshot() {
    local input_file="$1"
    local method="${2:-$METHOD}"

    # Get base filename without extension
    local basename=$(basename "$input_file")
    local name="${basename%.*}"
    local output_file="$OUTPUT_DIR/${name}.png"

    # Create output directory
    mkdir -p "$OUTPUT_DIR"

    case "$method" in
        nvim)
            screenshot_nvim "$input_file" "$output_file"
            ;;
        silicon)
            screenshot_silicon "$input_file" "$output_file"
            ;;
        freeze)
            screenshot_freeze "$input_file" "$output_file"
            ;;
        *)
            log_error "Unknown method: $method"
            exit 1
            ;;
    esac
}

# Parse command line arguments
parse_args() {
    local files=()

    while [[ $# -gt 0 ]]; do
        case $1 in
            -m|--method)
                METHOD="$2"
                shift 2
                ;;
            -w|--width)
                WIDTH="$2"
                shift 2
                ;;
            -h|--height)
                HEIGHT="$2"
                shift 2
                ;;
            -f|--font-size)
                FONT_SIZE="$2"
                shift 2
                ;;
            --font)
                FONT_FAMILY="$2"
                shift 2
                ;;
            -o|--output)
                OUTPUT_DIR="$2"
                shift 2
                ;;
            --help)
                show_help
                exit 0
                ;;
            -*)
                log_error "Unknown option: $1"
                show_help
                exit 1
                ;;
            *)
                files+=("$1")
                shift
                ;;
        esac
    done

    echo "${files[@]}"
}

# Main function
main() {
    log_info "Charleston Screenshot Generator"
    log_info "================================"

    # Parse arguments
    local files=($(parse_args "$@"))

    # Create temp directory
    mkdir -p "$TEMP_DIR"
    trap "rm -rf $TEMP_DIR" EXIT

    # Auto-detect method if needed
    if [[ "$METHOD" == "auto" ]]; then
        METHOD=$(detect_method)
        log_info "Auto-detected method: $METHOD"
    fi

    # Validate method
    case "$METHOD" in
        nvim)
            if ! command_exists nvim; then
                log_error "Neovim not found"
                exit 1
            fi
            ;;
        silicon)
            if ! command_exists silicon; then
                log_error "Silicon not found. Install: cargo install silicon"
                exit 1
            fi
            ;;
        freeze)
            if ! command_exists freeze; then
                log_error "Freeze not found. Install: go install github.com/charmbracelet/freeze@latest"
                exit 1
            fi
            ;;
    esac

    # If no files specified, process all examples
    if [[ ${#files[@]} -eq 0 ]]; then
        log_info "Processing all example files..."
        files=("$EXAMPLES_DIR"/*.{lua,py,ts,rs,js,go})
    fi

    # Generate screenshots
    local count=0
    for file in "${files[@]}"; do
        if [[ -f "$file" ]]; then
            generate_screenshot "$file" "$METHOD"
            ((count++))
        else
            log_warning "File not found: $file"
        fi
    done

    log_success "Generated $count screenshot(s) in $OUTPUT_DIR"
}

# Run main function
main "$@"
