function srk9_install_homebrew_locally_advanced --description "Install Homebrew locally with advanced Fish integration"
    echo "Installing Homebrew locally with advanced configuration..."
    echo "========================================================"
    
    set -l homebrew_path "$HOME/.local/opt/homebrew"
    
    # Check if already installed
    if test -d $homebrew_path/bin and command -q $homebrew_path/bin/brew
        echo "Homebrew already installed at $homebrew_path"
        echo "Current version: "($homebrew_path/bin/brew --version | head -n1)
        return 0
    end
    
    echo "Creating installation directory: $homebrew_path"
    mkdir -p $homebrew_path
    
    echo "Downloading and extracting Homebrew..."
    curl -L https://github.com/Homebrew/brew/tarball/master | tar xz --strip 1 -C $homebrew_path
    
    if not test -f $homebrew_path/bin/brew
        echo "✗ Installation failed - brew binary not found"
        return 1
    end
    
    echo ""
    echo "Configuring Fish environment..."
    
    # Set universal variables for Fish
    set -Ux HOMEBREW_PREFIX "$HOME/.local/opt/homebrew"
    set -Ux HOMEBREW_CELLAR "$HOMEBREW_PREFIX/Cellar"
    set -Ux HOMEBREW_REPOSITORY "$HOMEBREW_PREFIX"
    
    # Add to PATH
    fish_add_path "$HOMEBREW_PREFIX/bin"
    fish_add_path "$HOMEBREW_PREFIX/sbin"
    
    # Test installation
    if command -q brew
        echo "✓ Homebrew installed successfully!"
        echo "Location: "(which brew)
        echo "Version: "(brew --version | head -n1)
    else
        echo "✗ Installation completed but brew not found in PATH"
        echo "You may need to restart your shell"
        return 1
    end
    
    echo ""
    echo "========================================================"
    echo "Homebrew is ready to use!"
    echo "Try: brew install git"
end