function srk9-install-go --description "Install Go programming language (XDG compliant)"
    # Use XDG-compliant paths
    set -q SRK9_OPT_DIR; or set -l SRK9_OPT_DIR $HOME/.local/share/srk9/opt
    set -q SRK9_BIN_DIR; or set -l SRK9_BIN_DIR $HOME/.local/bin
    set -l go_version "1.22.0"
    set -l goroot $SRK9_OPT_DIR/go
    set -l gopath $SRK9_OPT_DIR/gopath

    echo "========================================================"
    echo "Installing Go $go_version"
    echo "========================================================"
    echo "GOROOT: $goroot"
    echo "GOPATH: $gopath"
    echo ""

    # Check if already installed
    if test -x $goroot/bin/go
        echo "Go is already installed"
        echo "Version: "($goroot/bin/go version)
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

    # Ensure directories exist
    mkdir -p (dirname $goroot)
    mkdir -p $gopath/bin $gopath/src $gopath/pkg
    mkdir -p $SRK9_BIN_DIR

    # Download and extract Go
    set -l tarball "go$go_version.$os-$arch.tar.gz"
    set -l download_url "https://go.dev/dl/$tarball"

    echo "Downloading from: $download_url"

    curl -fsSL $download_url | tar -xz -C (dirname $goroot)

    # Set environment variables
    set -Ux GOROOT $goroot
    set -Ux GOPATH $gopath
    fish_add_path $goroot/bin
    fish_add_path $gopath/bin

    # Create symlinks in bin directory
    if test -x $goroot/bin/go
        ln -sf $goroot/bin/go $SRK9_BIN_DIR/go
        ln -sf $goroot/bin/gofmt $SRK9_BIN_DIR/gofmt
        echo "✓ Created symlinks in $SRK9_BIN_DIR"
    end

    echo ""
    echo "========================================================"
    echo "Go installation completed!"
    echo "========================================================"

    # Test installation
    if test -x $goroot/bin/go
        echo "Go version: "($goroot/bin/go version)
    else
        echo "Note: You may need to restart your shell to use go"
    end
end
