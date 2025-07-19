function srk9_install_powerline_fonts --description "Install Powerline patched Nerd Fonts"
    echo "Installing Powerline patched Nerd Fonts..."
    echo "=========================================="
    
    set -l temp_dir "$HOME/.local/tmp"
    set -l target_dir "$temp_dir/powerline_nerd_fonts"
    set -l fonts_target "$HOME/Library/Fonts"
    
    # Create temporary directory
    mkdir -p $temp_dir
    
    # Clean up any existing clone
    if test -d $target_dir
        echo "Removing existing fonts directory..."
        rm -rf $target_dir
    end
    
    echo "Cloning Powerline fonts repository..."
    git clone https://github.com/powerline/fonts.git --depth=1 $target_dir
    
    if not test -d $target_dir
        echo "✗ Failed to clone fonts repository"
        return 1
    end
    
    echo "Installing fonts..."
    cd $target_dir
    
    # Make install script executable and run it
    chmod +x install.sh
    ./install.sh
    
    if test $status -eq 0
        echo ""
        echo "✓ Powerline fonts installed successfully!"
        echo ""
        echo "To use the fonts:"
        echo "  1. Restart your terminal application"
        echo "  2. Go to terminal preferences/settings"
        echo "  3. Select a font ending with 'for Powerline'"
        echo "  4. Popular choices: 'Meslo LG S for Powerline', 'Source Code Pro for Powerline'"
        echo ""
        echo "Cleaning up temporary files..."
        cd $HOME
        rm -rf $target_dir
    else
        echo "✗ Font installation failed"
        return 1
    end
end