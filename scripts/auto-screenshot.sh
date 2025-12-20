#!/usr/bin/env bash

# Automated screenshot capture for Charleston colorscheme
# This script helps automate taking screenshots of Neovim with Charleston theme

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
OUTPUT_DIR="$PROJECT_DIR/screenshots/output"
DELAY=3  # Delay before taking screenshot

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

# Detect screenshot tool
detect_screenshot_tool() {
    if command -v flameshot &> /dev/null; then
        echo "flameshot"
    elif command -v spectacle &> /dev/null; then
        echo "spectacle"
    elif command -v gnome-screenshot &> /dev/null; then
        echo "gnome-screenshot"
    elif command -v scrot &> /dev/null; then
        echo "scrot"
    elif command -v maim &> /dev/null; then
        echo "maim"
    else
        echo "none"
    fi
}

# Take screenshot with detected tool
take_screenshot() {
    local name="$1"
    local tool="$2"
    local output_file="$OUTPUT_DIR/${name}.png"

    mkdir -p "$OUTPUT_DIR"

    log_info "Taking screenshot: $name (in ${DELAY}s)"
    sleep "$DELAY"

    case "$tool" in
        flameshot)
            flameshot gui --path "$output_file" --delay $((DELAY * 1000))
            ;;
        spectacle)
            spectacle -a -b -n -o "$output_file"
            ;;
        gnome-screenshot)
            gnome-screenshot -a -f "$output_file"
            ;;
        scrot)
            scrot -s "$output_file"
            ;;
        maim)
            maim -s "$output_file"
            ;;
        *)
            log_info "No screenshot tool found, please take screenshot manually"
            log_info "Save as: $output_file"
            read -p "Press Enter when screenshot is saved..."
            ;;
    esac

    if [ -f "$output_file" ]; then
        log_success "Screenshot saved: $output_file"
        return 0
    else
        return 1
    fi
}

# Show instructions
show_instructions() {
    cat << 'EOF'
╔═══════════════════════════════════════════════════════════╗
║           Automated Screenshot Capture                    ║
╠═══════════════════════════════════════════════════════════╣
║                                                           ║
║  This script will guide you through taking screenshots   ║
║  of Neovim with Charleston colorscheme.                   ║
║                                                           ║
║  For each screenshot:                                     ║
║    1. Position your Neovim window                         ║
║    2. Execute the suggested command in Neovim             ║
║    3. Press Enter here to trigger screenshot              ║
║    4. Select the area to capture                          ║
║                                                           ║
╚═══════════════════════════════════════════════════════════╝

EOF
}

# Screenshot scenarios
capture_screenshots() {
    local tool
    tool=$(detect_screenshot_tool)

    log_info "Detected screenshot tool: $tool"
    echo ""

    local scenarios=(
        "01-dashboard:Show dashboard (:DemoDashboard)"
        "02-code-editing:Open src/main.lua and show code"
        "03-telescope:Open Telescope (:DemoTelescope or <Space>ff)"
        "04-neotree:Open Neo-tree (:DemoNeotree or <Space>e)"
        "05-mason:Open Mason (:DemoMason)"
        "06-split-layout:Show split windows (:DemoSplit)"
        "07-diagnostics:Show LSP diagnostics and errors"
        "08-git-signs:Show git signs in gutter"
    )

    for scenario in "${scenarios[@]}"; do
        IFS=':' read -r name description <<< "$scenario"

        echo ""
        echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
        echo -e "${GREEN}Screenshot:${NC} $name"
        echo -e "${BLUE}Action:${NC} $description"
        echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
        echo ""

        read -p "Ready? Press Enter to take screenshot (or 's' to skip): " response

        if [ "$response" = "s" ] || [ "$response" = "S" ]; then
            log_info "Skipped: $name"
            continue
        fi

        take_screenshot "$name" "$tool" || log_info "Screenshot failed or cancelled"
    done

    echo ""
    log_success "Screenshot session completed!"
    log_info "Screenshots saved in: $OUTPUT_DIR"
}

# Main
main() {
    show_instructions

    read -p "Press Enter to start screenshot capture session..."

    capture_screenshots

    echo ""
    log_info "Review your screenshots:"
    echo ""
    ls -lh "$OUTPUT_DIR"/*.png 2>/dev/null || echo "No screenshots found"
}

main "$@"
