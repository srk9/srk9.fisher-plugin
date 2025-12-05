function srk9-install-docker --description "Install Docker Desktop (macOS) or Docker Engine (Linux)"
    echo "Installing Docker..."
    echo "========================================================"

    # Check if already installed
    if command -q docker
        echo "Docker is already installed: "(docker --version)
        return 0
    end

    set -l os (uname -s)

    switch $os
        case Darwin
            echo "Detected macOS - Installing Docker Desktop..."
            echo ""
            echo "Docker Desktop requires manual download from:"
            echo "  https://www.docker.com/products/docker-desktop/"
            echo ""
            echo "Or install via Homebrew:"
            echo "  brew install --cask docker"
            echo ""

            # Attempt Homebrew installation if available
            if command -q brew
                read -l -P "Install Docker Desktop via Homebrew? [y/N] " confirm
                if test "$confirm" = "y" -o "$confirm" = "Y"
                    brew install --cask docker
                    echo ""
                    echo "Docker Desktop installed. Please launch it from Applications."
                end
            end

        case Linux
            echo "Detected Linux - Installing Docker Engine..."
            echo ""

            # Detect Linux distribution
            if test -f /etc/os-release
                source /etc/os-release

                switch $ID
                    case ubuntu debian
                        echo "Installing Docker for $ID..."
                        # Add Docker's official GPG key
                        sudo apt-get update
                        sudo apt-get install -y ca-certificates curl gnupg
                        sudo install -m 0755 -d /etc/apt/keyrings
                        curl -fsSL https://download.docker.com/linux/$ID/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
                        sudo chmod a+r /etc/apt/keyrings/docker.gpg

                        # Add the repository
                        echo "deb [arch="(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/$ID "(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

                        # Install Docker Engine
                        sudo apt-get update
                        sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

                        # Add user to docker group
                        sudo usermod -aG docker $USER

                    case fedora
                        echo "Installing Docker for Fedora..."
                        sudo dnf -y install dnf-plugins-core
                        sudo dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
                        sudo dnf install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
                        sudo systemctl start docker
                        sudo systemctl enable docker
                        sudo usermod -aG docker $USER

                    case '*'
                        echo "Unsupported Linux distribution: $ID"
                        echo "Please follow Docker's official installation guide:"
                        echo "  https://docs.docker.com/engine/install/"
                        return 1
                end
            else
                echo "Cannot detect Linux distribution."
                echo "Please follow Docker's official installation guide:"
                echo "  https://docs.docker.com/engine/install/"
                return 1
            end

        case '*'
            echo "Unsupported operating system: $os"
            return 1
    end

    echo "========================================================"
    echo "Docker installation completed!"
    echo "Note: You may need to log out and back in for group changes to take effect."
end
