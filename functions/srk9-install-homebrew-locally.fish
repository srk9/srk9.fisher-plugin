function srk9-install-homebrew-locally --description "Install Homebrew locally (XDG compliant, no sudo)"
    # Use XDG-compliant path
    set -q SRK9_OPT_DIR; or set -l SRK9_OPT_DIR $HOME/.local/share/srk9/opt
    set -q SRK9_BIN_DIR; or set -l SRK9_BIN_DIR $HOME/.local/bin
    set -l homebrew_prefix $SRK9_OPT_DIR/homebrew

    echo "========================================================"
    echo "Installing Homebrew locally (no sudo required)"
    echo "========================================================"
    echo "Install path: $homebrew_prefix"
    echo ""

    # Check if already installed
    if test -x $homebrew_prefix/bin/brew
        echo "Homebrew is already installed at $homebrew_prefix"
        echo "Version: "($homebrew_prefix/bin/brew --version | head -1)
        return 0
    end

    # Ensure directories exist
    mkdir -p $homebrew_prefix
    mkdir -p $SRK9_BIN_DIR

    # Download and extract Homebrew
    echo "Downloading Homebrew..."
    curl -fsSL https://github.com/Homebrew/brew/tarball/master | tar xz --strip 1 -C $homebrew_prefix

    # Set environment variables
    set -Ux HOMEBREW_PREFIX $homebrew_prefix
    set -Ux HOMEBREW_CELLAR $homebrew_prefix/Cellar
    set -Ux HOMEBREW_REPOSITORY $homebrew_prefix

    # Add to PATH
    fish_add_path $homebrew_prefix/bin
    fish_add_path $homebrew_prefix/sbin

    # Create symlink in bin directory
    if test -x $homebrew_prefix/bin/brew
        ln -sf $homebrew_prefix/bin/brew $SRK9_BIN_DIR/brew
        echo "✓ Created symlink in $SRK9_BIN_DIR"
    end

    echo ""
    echo "========================================================"
    echo "Homebrew installation completed!"
    echo "========================================================"

    # Test installation
    if test -x $homebrew_prefix/bin/brew
        echo "Homebrew version: "($homebrew_prefix/bin/brew --version | head -1)
        echo ""
        echo "Note: This is a local installation without sudo."
        echo "Some formulae may not work correctly without system access."
    else
        echo "Installation may have failed. Check the output above."
    end
end
