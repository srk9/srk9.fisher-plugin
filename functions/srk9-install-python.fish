function srk9-install-python --description "Install Python via pyenv (XDG compliant)"
    # Use XDG-compliant paths
    set -q SRK9_OPT_DIR; or set -l SRK9_OPT_DIR $HOME/.local/share/srk9/opt
    set -q SRK9_BIN_DIR; or set -l SRK9_BIN_DIR $HOME/.local/bin
    set -l pyenv_root $SRK9_OPT_DIR/pyenv

    echo "========================================================"
    echo "Installing Python via pyenv"
    echo "========================================================"
    echo "PYENV_ROOT: $pyenv_root"
    echo ""

    # Check if pyenv already installed
    if test -x $pyenv_root/bin/pyenv
        echo "pyenv is already installed"
        echo "Version: "($pyenv_root/bin/pyenv --version)
        echo ""
        echo "To install a specific Python version, run:"
        echo "  pyenv install <version>"
        return 0
    end

    # Ensure directories exist
    mkdir -p (dirname $pyenv_root)
    mkdir -p $SRK9_BIN_DIR

    # Install pyenv via git
    git clone https://github.com/pyenv/pyenv.git $pyenv_root

    # Set environment variables
    set -Ux PYENV_ROOT $pyenv_root
    fish_add_path $pyenv_root/bin
    fish_add_path $pyenv_root/shims

    # Create symlink in bin directory
    if test -x $pyenv_root/bin/pyenv
        ln -sf $pyenv_root/bin/pyenv $SRK9_BIN_DIR/pyenv
        echo "✓ Created symlink in $SRK9_BIN_DIR"
    end

    # Add pyenv init to fish config if not present
    set -l fish_config $HOME/.config/fish/config.fish
    if test -f $fish_config
        if not grep -q "pyenv init" $fish_config 2>/dev/null
            echo "" >> $fish_config
            echo "# pyenv initialization (added by srk9-install-python)" >> $fish_config
            echo 'if test -d $PYENV_ROOT' >> $fish_config
            echo '    status is-interactive; and pyenv init --path | source' >> $fish_config
            echo 'end' >> $fish_config
        end
    end

    echo ""
    echo "========================================================"
    echo "pyenv installation completed!"
    echo "========================================================"
    echo ""
    echo "To install Python, run:"
    echo "  pyenv install 3.12.0"
    echo "  pyenv global 3.12.0"

    # Test installation
    if test -x $pyenv_root/bin/pyenv
        echo ""
        echo "pyenv version: "($pyenv_root/bin/pyenv --version)
    else
        echo "Note: You may need to restart your shell to use pyenv"
    end
end
