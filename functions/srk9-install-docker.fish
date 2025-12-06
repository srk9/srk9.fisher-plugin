function srk9-install-docker --description "Install Docker (with deviation documentation)"
    echo "========================================================"
    echo "Docker Installation"
    echo "========================================================"
    echo ""
    echo "DEVIATION: Docker requires elevated privileges"
    echo "--------------------------------------------"
    echo "What:       Docker daemon requires root/admin access"
    echo "Why:        Kernel access for containerization (cgroups, namespaces)"
    echo "Impact:     Cannot install Docker without sudo/admin privileges"
    echo "Future Fix: Use rootless Docker mode or Podman as alternative"
    echo ""
    echo "See: SPEC.md for full deviation documentation"
    echo "========================================================"
    echo ""

    # Check if already installed
    if command -q docker
        echo "Docker is already installed: "(docker --version)
        return 0
    end

    set -l os (uname -s)

    switch $os
        case Darwin
            echo "macOS detected"
            echo ""
            echo "Options:"
            echo "  1. Docker Desktop (requires admin): brew install --cask docker"
            echo "  2. Colima (lighter alternative):    brew install colima docker"
            echo "  3. Podman (rootless alternative):   brew install podman"
            echo ""
            echo "Recommended for least-privilege: Podman"
            echo "  brew install podman"
            echo "  podman machine init"
            echo "  podman machine start"
            echo ""

            if command -q brew
                read -l -P "Install Podman (rootless) via Homebrew? [y/N] " confirm
                if test "$confirm" = "y" -o "$confirm" = "Y"
                    brew install podman
                    echo ""
                    echo "Podman installed. Initialize with:"
                    echo "  podman machine init"
                    echo "  podman machine start"
                end
            end

        case Linux
            echo "Linux detected"
            echo ""
            echo "Options:"
            echo "  1. Docker Engine (requires sudo) - see docs.docker.com"
            echo "  2. Rootless Docker - https://docs.docker.com/engine/security/rootless/"
            echo "  3. Podman (rootless) - apt/dnf install podman"
            echo ""
            echo "Recommended for least-privilege: Podman or Rootless Docker"
            echo ""

            # Detect distribution
            if test -f /etc/os-release
                source /etc/os-release
                echo "Detected: $ID"
                echo ""
                echo "To install Podman (no sudo for runtime):"

                switch $ID
                    case ubuntu debian
                        echo "  sudo apt install podman"
                    case fedora
                        echo "  sudo dnf install podman"
                    case arch
                        echo "  sudo pacman -S podman"
                    case '*'
                        echo "  Check your package manager for 'podman'"
                end
            end

        case '*'
            echo "Unsupported operating system: $os"
            return 1
    end

    echo ""
    echo "========================================================"
    echo "Note: This function does not auto-install Docker"
    echo "due to sudo requirements. See options above."
    echo "========================================================"
end
