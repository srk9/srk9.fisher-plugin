#!/bin/bash
set -e

echo "========================================"
echo "SrK9 Bootstrapper Installation"
echo "========================================"

# Check if running on macOS or Linux
if [[ "$OSTYPE" != "darwin"* ]] && [[ "$OSTYPE" != "linux-gnu"* ]]; then
    echo "Error: This installer supports macOS and Linux only"
    exit 1
fi

# Install Homebrew if not present
if ! command -v brew &> /dev/null; then
    echo ""
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # Add Homebrew to PATH for this session
    if [[ "$OSTYPE" == "darwin"* ]]; then
        if [[ $(uname -m) == "arm64" ]]; then
            eval "$(/opt/homebrew/bin/brew shellenv)"
        else
            eval "$(/usr/local/bin/brew shellenv)"
        fi
    else
        eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    fi
else
    echo "✓ Homebrew already installed"
fi

# Install Fish if not present
if ! command -v fish &> /dev/null; then
    echo ""
    echo "Installing Fish shell..."
    brew install fish
else
    echo "✓ Fish shell already installed"
fi

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
    fisher install srk9/srk9.bootstrapper

    echo ""
    echo "========================================"
    echo "Installation complete!"
    echo "========================================"
    echo ""
    echo "Available commands:"
    echo "  srk9-bootstrap              # Full system bootstrap"
    echo "  srk9-sync status            # Check sync service"
    echo "  srk9-install-*              # Install individual tools"
    echo "  srk9-list-functions         # List all commands"
    echo ""
    echo "Run: fish"
    echo "Then: srk9-bootstrap"
    echo ""
'
