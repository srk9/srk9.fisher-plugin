function srk9_install_volta --description "Install Volta Node.js version manager"
    echo "Installing Volta Node.js version manager..."
    echo "========================================================"
    
    # Install Volta
    curl https://get.volta.sh | bash
    
    # Add Volta to Fish path
    if test -d $HOME/.volta/bin
        fish_add_path $HOME/.volta/bin
    end
    
    # Install latest Node.js
    if command -q volta
        echo "Installing latest Node.js with Volta..."
        volta install node
        echo "Node.js installation completed!"
        echo "Node version: "(node --version)
        echo "npm version: "(npm --version)
    else
        echo "Please restart your shell and run 'volta install node' to install Node.js"
    end
    
    echo "========================================================"
    echo "Volta installation completed!"
end