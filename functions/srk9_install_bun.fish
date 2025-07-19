function srk9_install_bun --description "Install Bun runtime locally"
    set -l bun_install_path $HOME/.bun
    
    echo "Installing Bun locally at: $bun_install_path"
    echo "========================================================"
    
    # Install Bun v1.2.18
    curl -fsSL https://bun.sh/install | bash -s "bun-v1.2.18"
    
    # Add to shell environment
    echo "BUN_INSTALL=$bun_install_path" >> $HOME/.zprofile
    echo 'export PATH="$BUN_INSTALL/bin:$PATH"' >> $HOME/.zprofile
    
    # Set Fish environment variables
    set -Ux BUN_INSTALL $bun_install_path
    fish_add_path $bun_install_path/bin
    
    echo "========================================================"
    echo "Bun installation completed!"
    echo "For zsh compatibility, run: source ~/.zprofile"
    echo "For Fish, the environment is already set."
    
    # Test installation
    if command -q bun
        echo "Bun version: "(bun --version)
    else
        echo "Note: You may need to restart your shell to use bun"
    end
end