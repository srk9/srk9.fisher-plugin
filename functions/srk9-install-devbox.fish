function srk9-install-devbox --description "Install Devbox (Nix-based dev environments) - XDG compliant"
    # Use XDG-compliant path
    set -q SRK9_BIN_DIR; or set -l SRK9_BIN_DIR $HOME/.local/bin

    echo "========================================================"
    echo "Installing Devbox"
    echo "========================================================"
    echo "Devbox creates isolated dev environments using Nix"
    echo "https://www.jetpack.io/devbox"
    echo ""

    # Check if already installed
    if command -q devbox
        echo "Devbox is already installed: "(devbox version)
        return 0
    end

    # Ensure bin directory exists
    mkdir -p $SRK9_BIN_DIR

    # Install Devbox (installs to ~/.local/bin by default - XDG compliant)
    echo "Installing Devbox..."
    curl -fsSL https://get.jetpack.io/devbox | bash

    # Ensure path is set
    if not contains $SRK9_BIN_DIR $fish_user_paths
        fish_add_path $SRK9_BIN_DIR
    end

    echo ""
    echo "========================================================"
    echo "Devbox installation completed!"
    echo "========================================================"

    # Test installation
    if command -q devbox
        echo "Devbox version: "(devbox version)
        echo ""
        echo "Quick start:"
        echo "  devbox init          # Initialize in current directory"
        echo "  devbox add python    # Add packages"
        echo "  devbox shell         # Enter dev environment"
    else
        echo "Note: You may need to restart your shell to use devbox"
    end
end
