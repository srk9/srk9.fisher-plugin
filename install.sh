#!/bin/bash
set -e

echo "========================================"
echo "SrK9 Bootstrapper Installation"
echo "========================================"
echo ""
echo "Principles:"
echo "  - No sudo required"
echo "  - XDG Base Directory compliant"
echo "  - Local-first installation"
echo ""

# Check if running on macOS or Linux
if [[ "$OSTYPE" != "darwin"* ]] && [[ "$OSTYPE" != "linux-gnu"* ]]; then
    echo "Error: This installer supports macOS and Linux only"
    exit 1
fi

# Check for Fish shell (REQUIRED - user must install)
if ! command -v fish &> /dev/null; then
    echo "Error: Fish shell is required but not installed."
    echo ""
    echo "Please install Fish first:"
    echo "  macOS:  brew install fish"
    echo "          or download from https://fishshell.com"
    echo "  Debian: apt install fish"
    echo "  Fedora: dnf install fish"
    echo "  Arch:   pacman -S fish"
    echo ""
    echo "Then re-run this installer."
    exit 1
fi

echo "✓ Fish shell found: $(which fish)"

# Get Fish path
FISH_PATH=$(which fish)

# Install Fisher and srk9-bootstrapper plugin
echo ""
echo "Installing Fisher and srk9-bootstrapper plugin..."
$FISH_PATH -c '
    # Install Fisher if not present
    if not functions -q fisher
        echo "Installing Fisher..."
        curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source
        fisher install jorgebucaran/fisher
    else
        echo "✓ Fisher already installed"
    end

    # Install srk9-bootstrapper plugin
    echo ""
    echo "Installing srk9-bootstrapper plugin..."
    fisher install jellylabs-ltd/srk9-bootstrapper

    # Initialize XDG directory structure
    echo ""
    echo "Initializing XDG directory structure..."
    srk9-init-dirs

    echo ""
    echo "========================================"
    echo "Installation complete!"
    echo "========================================"
    echo ""
    echo "Available commands:"
    echo "  srk9-env                    # Show environment variables"
    echo "  srk9-help                   # Show all commands"
    echo "  srk9-status                 # Check installed tools"
    echo "  srk9-install-*              # Install individual tools"
    echo ""
    echo "Start using:"
    echo "  fish                        # Enter Fish shell"
    echo "  srk9-help                   # View available commands"
    echo ""
'
