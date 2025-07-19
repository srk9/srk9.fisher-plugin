function srk9_install_omf --description "Install Oh My Fish framework for Fish shell"
    echo "Installing Oh My Fish (OMF)..."
    echo "=============================="
    
    # Check if already installed
    if command -q omf
        echo "Oh My Fish is already installed!"
        echo "Version: "(omf --version)
        return 0
    end
    
    echo "Downloading and installing OMF..."
    echo "This will download the installer script and run it."
    echo ""
    
    # Download and install OMF
    curl -L https://get.oh-my.fish | fish
    
    if command -q omf
        echo ""
        echo "✓ Oh My Fish installed successfully!"
        echo "Version: "(omf --version)
        echo ""
        echo "Getting started with OMF:"
        echo "  omf help                    - Show help"
        echo "  omf list                    - List available packages"
        echo "  omf install <package>       - Install a package"
        echo "  omf theme <theme>           - Change theme"
        echo ""
        echo "Popular themes to try:"
        echo "  omf install bobthefish      - or use 'srk9_install_bob_the_fish'"
        echo "  omf install agnoster"
        echo "  omf install clearance"
    else
        echo "✗ Installation failed or omf not found in PATH"
        echo "You may need to restart your Fish shell"
        return 1
    end
end