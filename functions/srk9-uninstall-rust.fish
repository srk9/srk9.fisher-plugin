function srk9-uninstall-rust --description "Uninstall Rust via rustup"
    echo "Uninstalling Rust..."
    echo "========================================================"

    if not command -q rustup
        echo "Rust/rustup is not installed"
        return 0
    end

    # Confirm removal
    read -l -P "Remove Rust installation? [y/N] " confirm
    if test "$confirm" != "y" -a "$confirm" != "Y"
        echo "Cancelled."
        return 0
    end

    # Use rustup's self-uninstall
    rustup self uninstall -y

    # Remove from Fish path
    set -l cargo_home $HOME/.cargo
    if set -l index (contains -i $cargo_home/bin $fish_user_paths)
        set -e fish_user_paths[$index]
        echo "Removed from Fish path"
    end

    # Unset environment variables
    set -e CARGO_HOME
    set -e RUSTUP_HOME

    echo "========================================================"
    echo "Rust uninstalled successfully!"
end
