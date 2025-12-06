function srk9-install-rust --description "Install Rust via rustup (XDG compliant)"
    # Use XDG-compliant paths
    set -q SRK9_OPT_DIR; or set -l SRK9_OPT_DIR $HOME/.local/share/srk9/opt
    set -q SRK9_BIN_DIR; or set -l SRK9_BIN_DIR $HOME/.local/bin
    set -l cargo_home $SRK9_OPT_DIR/cargo
    set -l rustup_home $SRK9_OPT_DIR/rustup

    echo "========================================================"
    echo "Installing Rust via rustup"
    echo "========================================================"
    echo "CARGO_HOME:  $cargo_home"
    echo "RUSTUP_HOME: $rustup_home"
    echo ""

    # Check if already installed
    if test -x $cargo_home/bin/rustc
        echo "Rust is already installed"
        echo "Version: "($cargo_home/bin/rustc --version)
        echo ""
        echo "To update, run: rustup update"
        return 0
    end

    # Ensure directories exist
    mkdir -p $cargo_home
    mkdir -p $rustup_home
    mkdir -p $SRK9_BIN_DIR

    # Set environment for installer
    set -x CARGO_HOME $cargo_home
    set -x RUSTUP_HOME $rustup_home

    # Install rustup
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --no-modify-path

    # Set Fish environment variables
    set -Ux CARGO_HOME $cargo_home
    set -Ux RUSTUP_HOME $rustup_home
    fish_add_path $cargo_home/bin

    # Create symlinks in bin directory
    if test -x $cargo_home/bin/cargo
        ln -sf $cargo_home/bin/cargo $SRK9_BIN_DIR/cargo
        ln -sf $cargo_home/bin/rustc $SRK9_BIN_DIR/rustc
        ln -sf $cargo_home/bin/rustup $SRK9_BIN_DIR/rustup
        ln -sf $cargo_home/bin/rustfmt $SRK9_BIN_DIR/rustfmt 2>/dev/null
        ln -sf $cargo_home/bin/clippy-driver $SRK9_BIN_DIR/clippy-driver 2>/dev/null
        echo "✓ Created symlinks in $SRK9_BIN_DIR"
    end

    echo ""
    echo "========================================================"
    echo "Rust installation completed!"
    echo "========================================================"

    # Test installation
    if test -x $cargo_home/bin/rustc
        echo "Rust version: "($cargo_home/bin/rustc --version)
        echo "Cargo version: "($cargo_home/bin/cargo --version)
    else
        echo "Note: You may need to restart your shell to use rust/cargo"
    end
end
