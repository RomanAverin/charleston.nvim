#!/usr/bin/env bash

# Charleston Neovim Demo Launcher
# This script launches Neovim with Charleston colorscheme and demo configuration

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
DEMO_CONFIG="$PROJECT_DIR/screenshots/demo-config/init.lua"
DEMO_PROJECT="$PROJECT_DIR/screenshots/demo-project"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m'

print_header() {
    echo -e "${MAGENTA}"
    echo "╔═══════════════════════════════════════════════════════════╗"
    echo "║                                                           ║"
    echo "║          Charleston Colorscheme Demo Launcher            ║"
    echo "║                                                           ║"
    echo "╚═══════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
}

print_instructions() {
    echo -e "${CYAN}📸 Screenshot Instructions:${NC}"
    echo ""
    echo -e "${GREEN}Available screenshot tools:${NC}"
    echo -e "  1. ${YELLOW}Flameshot${NC}  - Interactive screenshot tool"
    echo -e "     Command: ${BLUE}flameshot gui${NC}"
    echo ""
    echo -e "  2. ${YELLOW}Spectacle${NC}  - KDE screenshot tool"
    echo -e "     Command: ${BLUE}spectacle${NC}"
    echo ""
    echo -e "  3. ${YELLOW}GNOME Screenshot${NC}"
    echo -e "     Command: ${BLUE}gnome-screenshot -i${NC}"
    echo ""
    echo -e "  4. ${YELLOW}Scrot${NC}      - CLI screenshot tool"
    echo -e "     Command: ${BLUE}scrot -s 'screenshot_%Y%m%d_%H%M%S.png'${NC}"
    echo ""
    echo -e "${GREEN}Demo commands in Neovim:${NC}"
    echo -e "  ${BLUE}:DemoTelescope${NC}  - Open Telescope (file finder)"
    echo -e "  ${BLUE}:DemoNeotree${NC}    - Toggle Neo-tree (file explorer)"
    echo -e "  ${BLUE}:DemoMason${NC}      - Open Mason (LSP installer)"
    echo -e "  ${BLUE}:DemoDashboard${NC}  - Show dashboard"
    echo -e "  ${BLUE}:DemoSplit${NC}      - Create split layout"
    echo ""
    echo -e "${GREEN}Suggested screenshots:${NC}"
    echo -e "  1. ${CYAN}Dashboard${NC}         - Show welcome screen"
    echo -e "  2. ${CYAN}Code editing${NC}      - Open src/main.lua"
    echo -e "  3. ${CYAN}Telescope${NC}         - File finder UI"
    echo -e "  4. ${CYAN}Neo-tree${NC}          - File explorer sidebar"
    echo -e "  5. ${CYAN}Mason${NC}             - LSP installer UI"
    echo -e "  6. ${CYAN}Split windows${NC}     - Multiple panes"
    echo -e "  7. ${CYAN}Diagnostics${NC}       - Error/warning highlights"
    echo ""
    echo -e "${YELLOW}Press Enter to launch Neovim demo...${NC}"
    read -r
}

check_dependencies() {
    if ! command -v nvim &> /dev/null; then
        echo -e "${RED}Error: Neovim not found${NC}"
        exit 1
    fi

    echo -e "${GREEN}✓${NC} Neovim found: $(nvim --version | head -n1)"

    # Check for screenshot tools
    local screenshot_tools=("flameshot" "spectacle" "gnome-screenshot" "scrot")
    local found_tools=()

    for tool in "${screenshot_tools[@]}"; do
        if command -v "$tool" &> /dev/null; then
            found_tools+=("$tool")
        fi
    done

    if [ ${#found_tools[@]} -eq 0 ]; then
        echo -e "${YELLOW}⚠${NC}  No screenshot tool found. Install one of: ${screenshot_tools[*]}"
    else
        echo -e "${GREEN}✓${NC} Screenshot tools found: ${found_tools[*]}"
    fi

    echo ""
}

launch_neovim() {
    cd "$DEMO_PROJECT" || exit 1

    echo -e "${BLUE}Launching Neovim with Charleston demo configuration...${NC}"
    echo -e "${YELLOW}Note: First run will install plugins (may take a few minutes)${NC}"
    echo ""

    sleep 2

    # Launch Neovim with demo config
    NVIM_APPNAME="charleston-demo" nvim -u "$DEMO_CONFIG" "$DEMO_PROJECT/src/main.lua"
}

main() {
    print_header
    check_dependencies
    print_instructions
    launch_neovim
}

main "$@"
