function srk9_install_advanced_brew_packages --description "Install comprehensive brew packages with intelligent checking"
    if not command -q brew
        echo "Error: Homebrew not found. Please run 'srk9_install_homebrew' first."
        return 1
    end
    
    echo "Installing advanced Homebrew packages..."
    echo "========================================"
    
    # Define packages and casks
    set -l packages git wget zig rust ruby podman docker warp protobuf iterm2 fswatch exiftool imagemagick hermes libvpx ffmpeg
    set -l casks zed visual-studio-code
    
    # Check for existing packages file
    set -l core_dir (dirname (dirname (dirname (dirname (status --current-filename)))))
    set -l packages_file "$core_dir/brew_packages.data"
    
    if test -f $packages_file
        echo "Found existing packages list: $packages_file"
        set packages (cat $packages_file)
    end
    
    # Get currently installed packages
    set -l installed_packages (brew list)
    set -l installed_casks (brew list --cask)
    
    echo ""
    echo "Installing packages:"
    for package in $packages
        if contains $package $installed_packages
            echo "  ✓ $package (already installed)"
        else
            echo "  → Installing $package..."
            brew install $package
            if test $status -eq 0
                echo "    ✓ $package installed"
            else
                echo "    ✗ $package failed to install"
            end
        end
    end
    
    echo ""
    echo "Installing casks:"
    for cask in $casks
        if contains $cask $installed_casks
            echo "  ✓ $cask (already installed)"
        else
            echo "  → Installing $cask..."
            brew install --cask $cask
            if test $status -eq 0
                echo "    ✓ $cask installed"
            else
                echo "    ✗ $cask failed to install"
            end
        end
    end
    
    echo ""
    echo "========================================"
    echo "Advanced package installation completed!"
end