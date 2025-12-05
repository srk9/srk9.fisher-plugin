function srk9-install-rust --description "Install Rust via rustup"
    set -l cargo_home $HOME/.cargo

    echo "Installing Rust via rustup..."
    echo "========================================================"

    # Check if already installed
    if command -q rustc
        echo "Rust is already installed: "(rustc --version)
        echo "To update, run: rustup update"
        return 0
    end

    # Install rustup (Rust's official installer)
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

    # Add to Fish path
    if test -d $cargo_home/bin
        fish_add_path $cargo_home/bin
    end

    # Set environment variables
    set -Ux CARGO_HOME $cargo_home
    set -Ux RUSTUP_HOME $HOME/.rustup

    echo "========================================================"
    echo "Rust installation completed!"

    # Test installation
    if command -q rustc
        echo "Rust version: "(rustc --version)
        echo "Cargo version: "(cargo --version)
    else
        echo "Note: You may need to restart your shell to use rust/cargo"
    end
end
