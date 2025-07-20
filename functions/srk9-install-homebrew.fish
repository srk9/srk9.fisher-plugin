function srk9-install-homebrew --description "Install Homebrew locally"

    set -l homebrew_global_install_path /opt/homebrew

    echo "Installing Homebrew locally to: $homebrew_global_install_path"
    echo "========================================================"

    # Create installation directory
    mkdir -p $homebrew_global_install_path

    # Download and extract Homebrew
    curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh
    #curl -L https://github.com/Homebrew/brew/tarball/master | tar xz --strip 1 -C $homebrew_local_path

    # Add to shell environment
    echo "HOMEBREW_GLOBAL_INSTALL_PATH=$homebrew_global_install_path" >> $HOME/.zprofile
    echo "eval \"\$($homebrew_global_install_path/bin/brew shellenv)\"" >> $HOME/.zprofile

    # Set Fish environment
    set -Ux HOMEBREW_GLOBAL_INSTALL_PATH $homebrew_global_install_path
    eval ($homebrew_global_install_path/bin/brew shellenv)

    echo "========================================================"

    # Activate in current session
    # source $HOME/.zprofile

    echo "========================================================"
    echo "Testing Homebrew installation..."

    if command -q brew
        echo "Homebrew installed successfully at: "(which brew)
    else
        echo "Installation may have failed. Check the output above."
    end

    echo "========================================================"
    echo "To activate Homebrew in zsh, run: source ~/.zprofile"
    echo "For Fish, Homebrew is already available in this session."
end
