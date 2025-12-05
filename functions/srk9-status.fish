function srk9-status --description "Show status of installed development tools"
    echo "SrK9 Development Environment Status"
    echo "========================================================"
    echo ""

    # Check Homebrew
    printf "%-15s" "Homebrew:"
    if command -q brew
        echo "installed ("(brew --version | head -n1)")"
    else
        echo "not installed"
    end

    # Check Fish
    printf "%-15s" "Fish:"
    if command -q fish
        echo "installed ("(fish --version)")"
    else
        echo "not installed"
    end

    # Check Fisher
    printf "%-15s" "Fisher:"
    if functions -q fisher
        echo "installed"
    else
        echo "not installed"
    end

    # Check Bun
    printf "%-15s" "Bun:"
    if command -q bun
        echo "installed (v"(bun --version)")"
    else
        echo "not installed"
    end

    # Check Volta
    printf "%-15s" "Volta:"
    if command -q volta
        echo "installed ("(volta --version)")"
    else
        echo "not installed"
    end

    # Check Node.js
    printf "%-15s" "Node.js:"
    if command -q node
        echo "installed ("(node --version)")"
    else
        echo "not installed"
    end

    # Check Rust
    printf "%-15s" "Rust:"
    if command -q rustc
        echo "installed ("(rustc --version | cut -d' ' -f2)")"
    else
        echo "not installed"
    end

    # Check Go
    printf "%-15s" "Go:"
    if command -q go
        echo "installed ("(go version | cut -d' ' -f3)")"
    else
        echo "not installed"
    end

    # Check Python/pyenv
    printf "%-15s" "pyenv:"
    if command -q pyenv
        echo "installed ("(pyenv --version | cut -d' ' -f2)")"
    else
        echo "not installed"
    end

    printf "%-15s" "Python:"
    if command -q python3
        echo "installed ("(python3 --version | cut -d' ' -f2)")"
    else if command -q python
        echo "installed ("(python --version | cut -d' ' -f2)")"
    else
        echo "not installed"
    end

    # Check Docker
    printf "%-15s" "Docker:"
    if command -q docker
        echo "installed ("(docker --version | cut -d' ' -f3 | tr -d ',')")"
    else
        echo "not installed"
    end

    # Check Claude CLI
    printf "%-15s" "Claude CLI:"
    if command -q claude
        echo "installed"
    else
        echo "not installed"
    end

    # Check Git
    printf "%-15s" "Git:"
    if command -q git
        echo "installed ("(git --version | cut -d' ' -f3)")"
    else
        echo "not installed"
    end

    echo ""
    echo "========================================================"
    echo "Run 'srk9-list-functions' to see available install commands"
end
