function srk9-install-bun --description "Install Bun runtime locally (XDG compliant)"
    # Use XDG-compliant path
    set -q SRK9_OPT_DIR; or set -l SRK9_OPT_DIR $HOME/.local/share/srk9/opt
    set -q SRK9_BIN_DIR; or set -l SRK9_BIN_DIR $HOME/.local/bin
    set -l bun_install_path $SRK9_OPT_DIR/bun

    echo "========================================================"
    echo "Installing Bun runtime"
    echo "========================================================"
    echo "Install path: $bun_install_path"
    echo ""

    # Check if already installed
    if test -x $bun_install_path/bin/bun
        echo "Bun is already installed at $bun_install_path"
        echo "Version: "($bun_install_path/bin/bun --version)
        echo ""
        echo "To reinstall, remove the directory first:"
        echo "  rm -rf $bun_install_path"
        return 0
    end

    # Ensure directories exist
    mkdir -p $bun_install_path
    mkdir -p $SRK9_BIN_DIR

    # Install Bun with custom install path
    set -x BUN_INSTALL $bun_install_path
    curl -fsSL https://bun.sh/install | bash

    # Set Fish environment variables
    set -Ux BUN_INSTALL $bun_install_path
    fish_add_path $bun_install_path/bin

    # Create symlinks in bin directory
    if test -x $bun_install_path/bin/bun
        ln -sf $bun_install_path/bin/bun $SRK9_BIN_DIR/bun
        ln -sf $bun_install_path/bin/bunx $SRK9_BIN_DIR/bunx
        echo "✓ Created symlinks in $SRK9_BIN_DIR"
    end

    echo ""
    echo "========================================================"
    echo "Bun installation completed!"
    echo "========================================================"

    # Test installation
    if command -q bun
        echo "Bun version: "(bun --version)
    else
        echo "Note: You may need to restart your shell to use bun"
    end
end
