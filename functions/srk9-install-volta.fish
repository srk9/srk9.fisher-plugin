function srk9-install-volta --description "Install Volta Node.js version manager (XDG compliant)"
    # Use XDG-compliant path
    set -q SRK9_OPT_DIR; or set -l SRK9_OPT_DIR $HOME/.local/share/srk9/opt
    set -q SRK9_BIN_DIR; or set -l SRK9_BIN_DIR $HOME/.local/bin
    set -l volta_home $SRK9_OPT_DIR/volta

    echo "========================================================"
    echo "Installing Volta Node.js version manager"
    echo "========================================================"
    echo "Install path: $volta_home"
    echo ""

    # Check if already installed
    if test -x $volta_home/bin/volta
        echo "Volta is already installed at $volta_home"
        echo "Version: "($volta_home/bin/volta --version)
        return 0
    end

    # Ensure directories exist
    mkdir -p $volta_home
    mkdir -p $SRK9_BIN_DIR

    # Install Volta with custom home
    set -x VOLTA_HOME $volta_home
    curl https://get.volta.sh | bash -s -- --skip-setup

    # Set Fish environment variables
    set -Ux VOLTA_HOME $volta_home
    fish_add_path $volta_home/bin

    # Create symlinks in bin directory
    if test -x $volta_home/bin/volta
        ln -sf $volta_home/bin/volta $SRK9_BIN_DIR/volta
        echo "✓ Created symlink in $SRK9_BIN_DIR"
    end

    echo ""
    echo "========================================================"
    echo "Volta installation completed!"
    echo "========================================================"

    # Install latest Node.js
    if test -x $volta_home/bin/volta
        echo ""
        echo "Installing latest Node.js with Volta..."
        $volta_home/bin/volta install node

        # Create symlinks for node/npm
        if test -x $volta_home/bin/node
            ln -sf $volta_home/bin/node $SRK9_BIN_DIR/node
            ln -sf $volta_home/bin/npm $SRK9_BIN_DIR/npm
            ln -sf $volta_home/bin/npx $SRK9_BIN_DIR/npx
            echo "✓ Created node/npm symlinks"
        end

        echo "Node version: "(node --version)
        echo "npm version: "(npm --version)
    else
        echo "Please restart your shell and run 'volta install node'"
    end
end
