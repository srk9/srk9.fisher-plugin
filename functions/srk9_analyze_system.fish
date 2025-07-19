function srk9_analyze_system --description "Analyze current system configuration and installed tools"
    echo "SRK9 System Analysis"
    echo "===================="
    echo ""
    
    # Check operating system
    echo "Operating System: "(uname -s)" "(uname -r)
    echo "Architecture: "(uname -m)
    echo ""
    
    # Check if common tools are installed
    set -l tools brew bun volta node npm git fish zsh
    echo "Tool Status:"
    for tool in $tools
        if command -q $tool
            echo "  ✓ $tool: "(which $tool)" - "($tool --version 2>/dev/null | head -n1)
        else
            echo "  ✗ $tool: not installed"
        end
    end
    echo ""
    
    # Check SRK9 directories
    echo "SRK9 Directories:"
    set -l dirs ~/.srk9 ~/.srk9.backups ~/.bun ~/.volta ~/.local/opt/homebrew
    for dir in $dirs
        if test -d $dir
            echo "  ✓ $dir exists"
        else
            echo "  ✗ $dir missing"
        end
    end
    echo ""
    
    # Check dotfiles
    echo "Dotfiles Status:"
    set -l dotfiles .zshrc .zprofile .gitconfig .config/fish/config.fish
    for file in $dotfiles
        if test -e "$HOME/$file"
            if test -L "$HOME/$file"
                echo "  ↗ $file (symlink)"
            else
                echo "  ✓ $file (regular file)"
            end
        else
            echo "  ✗ $file missing"
        end
    end
    echo ""
    
    echo "System analysis complete."
end