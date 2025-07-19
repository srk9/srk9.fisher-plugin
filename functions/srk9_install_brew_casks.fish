function srk9_install_brew_casks --description "Install essential Homebrew casks (GUI applications)"
    if not command -q brew
        echo "Error: Homebrew not found. Please run 'srk9_install_homebrew' first."
        return 1
    end
    
    echo "Installing essential Homebrew casks..."
    echo "========================================"
    
    set -l casks zed visual-studio-code hugin imageoptim autopano-sift-c obsidian blender chatgpt
    
    for cask in $casks
        echo "Installing $cask..."
        brew install --cask $cask
    end
    
    echo "========================================"
    echo "Cask installation completed!"
end