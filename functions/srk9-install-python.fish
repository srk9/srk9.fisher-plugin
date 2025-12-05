function srk9-install-python --description "Install Python via pyenv"
    set -l pyenv_root $HOME/.pyenv

    echo "Installing Python via pyenv..."
    echo "========================================================"

    # Check if pyenv already installed
    if command -q pyenv
        echo "pyenv is already installed: "(pyenv --version)
        echo "To install a specific Python version, run: pyenv install <version>"
        return 0
    end

    # Install pyenv via git
    if not test -d $pyenv_root
        git clone https://github.com/pyenv/pyenv.git $pyenv_root
    end

    # Add to Fish path
    fish_add_path $pyenv_root/bin

    # Set environment variables
    set -Ux PYENV_ROOT $pyenv_root

    # Add pyenv init to config
    if not grep -q "pyenv init" $HOME/.config/fish/config.fish 2>/dev/null
        echo "" >> $HOME/.config/fish/config.fish
        echo "# pyenv initialization" >> $HOME/.config/fish/config.fish
        echo 'status is-interactive; and pyenv init --path | source' >> $HOME/.config/fish/config.fish
    end

    # Add to zprofile for zsh compatibility
    echo 'export PYENV_ROOT="$HOME/.pyenv"' >> $HOME/.zprofile
    echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> $HOME/.zprofile
    echo 'eval "$(pyenv init --path)"' >> $HOME/.zprofile

    echo "========================================================"
    echo "pyenv installation completed!"
    echo ""
    echo "To install Python, run:"
    echo "  pyenv install 3.12.0"
    echo "  pyenv global 3.12.0"

    # Test installation
    if command -q pyenv
        echo ""
        echo "pyenv version: "(pyenv --version)
    else
        echo "Note: You may need to restart your shell to use pyenv"
    end
end
