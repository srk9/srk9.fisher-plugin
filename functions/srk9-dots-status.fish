function srk9-dots-status --description "Show dotfiles management status"
    set -l dots_dir $HOME/.dotfiles

    echo "Dotfiles Management Status"
    echo "========================================================"

    if not test -d $dots_dir
        echo "Dotfiles directory not found at $dots_dir"
        echo "Run 'srk9-dots-init' to initialize."
        return 1
    end

    echo ""
    echo "Managed dotfiles directory: $dots_dir"
    echo ""

    # Check git status if it's a repo
    if test -d $dots_dir/.git
        echo "Git Status:"
        echo "-------------------------------------------------------"
        git -C $dots_dir status --short
        echo ""
    end

    # Check symlink status
    echo "Symlink Status:"
    echo "-------------------------------------------------------"

    function _check_link
        set -l target $argv[1]
        set -l expected $argv[2]
        set -l name $argv[3]

        printf "  %-20s" "$name:"

        if test -L $target
            set -l actual (readlink $target)
            if test "$actual" = "$expected"
                echo "linked"
            else
                echo "linked (different target)"
            end
        else if test -e $target
            echo "exists (not linked)"
        else
            echo "missing"
        end
    end

    # Check Fish config
    _check_link $HOME/.config/fish/config.fish $dots_dir/fish/config.fish "Fish config"

    # Check Git config
    _check_link $HOME/.gitconfig $dots_dir/git/.gitconfig ".gitconfig"

    # Check shell profiles
    _check_link $HOME/.zshrc $dots_dir/shell/.zshrc ".zshrc"
    _check_link $HOME/.zprofile $dots_dir/shell/.zprofile ".zprofile"
    _check_link $HOME/.bashrc $dots_dir/shell/.bashrc ".bashrc"

    # Clean up helper function
    functions -e _check_link

    echo ""

    # Show directory contents
    echo "Managed Files:"
    echo "-------------------------------------------------------"
    if command -q tree
        tree -L 2 $dots_dir --noreport
    else
        ls -la $dots_dir
    end

    echo ""
    echo "========================================================"
    echo "Commands:"
    echo "  srk9-dots-init   - Initialize dotfiles management"
    echo "  srk9-dots-link   - Create symlinks"
    echo "  srk9-backup-dots - Create timestamped backup"
end
