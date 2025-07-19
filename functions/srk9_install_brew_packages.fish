function srk9_install_brew_packages --description "Install essential Homebrew packages"
    if not command -q brew
        echo "Error: Homebrew not found. Please run 'srk9_install_homebrew' first."
        return 1
    end
    
    echo "Installing essential Homebrew packages..."
    echo "========================================"
    
    set -l packages curl git wget zig rust ruby oven-sh/bun podman docker warp protobuf iterm2 exiftool imagemagick hermes libvpx ffmpeg
    
    for package in $packages
        echo "Installing $package..."
        brew install $package
    end
    
    echo "========================================"
    echo "Package installation completed!"
end