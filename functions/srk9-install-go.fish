function srk9-install-go --description "Install Go programming language"
    set -l go_version "1.22.0"
    set -l go_install_path $HOME/.local/go
    set -l gopath $HOME/go

    echo "Installing Go $go_version..."
    echo "========================================================"

    # Check if already installed
    if command -q go
        echo "Go is already installed: "(go version)
        return 0
    end

    # Detect architecture
    set -l arch (uname -m)
    set -l os (uname -s | string lower)

    switch $arch
        case x86_64
            set arch "amd64"
        case arm64 aarch64
            set arch "arm64"
        case '*'
            echo "Unsupported architecture: $arch"
            return 1
    end

    # Download and extract Go
    set -l tarball "go$go_version.$os-$arch.tar.gz"
    set -l download_url "https://go.dev/dl/$tarball"

    echo "Downloading from: $download_url"

    mkdir -p (dirname $go_install_path)
    curl -fsSL $download_url | tar -xz -C (dirname $go_install_path)
    mv (dirname $go_install_path)/go $go_install_path

    # Create GOPATH directory
    mkdir -p $gopath/bin $gopath/src $gopath/pkg

    # Add to Fish path
    fish_add_path $go_install_path/bin
    fish_add_path $gopath/bin

    # Set environment variables
    set -Ux GOROOT $go_install_path
    set -Ux GOPATH $gopath

    # Add to zprofile for zsh compatibility
    echo "export GOROOT=$go_install_path" >> $HOME/.zprofile
    echo "export GOPATH=$gopath" >> $HOME/.zprofile
    echo 'export PATH="$GOROOT/bin:$GOPATH/bin:$PATH"' >> $HOME/.zprofile

    echo "========================================================"
    echo "Go installation completed!"

    # Test installation
    if command -q go
        echo "Go version: "(go version)
    else
        echo "Note: You may need to restart your shell to use go"
    end
end
