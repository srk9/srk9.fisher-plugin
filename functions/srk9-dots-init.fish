function srk9-dots-init --description "Initialize dotfiles management system"
    set -l dots_dir $HOME/.dotfiles

    echo "Initialize Dotfiles Management"
    echo "========================================================"

    # Create dotfiles directory structure
    if not test -d $dots_dir
        mkdir -p $dots_dir
        echo "Created: $dots_dir"
    else
        echo "Dotfiles directory already exists: $dots_dir"
    end

    # Create subdirectories
    mkdir -p $dots_dir/fish
    mkdir -p $dots_dir/git
    mkdir -p $dots_dir/shell
    mkdir -p $dots_dir/config

    echo "Created directory structure:"
    echo "  $dots_dir/fish    - Fish shell config"
    echo "  $dots_dir/git     - Git configuration"
    echo "  $dots_dir/shell   - Shell profiles (zsh, bash)"
    echo "  $dots_dir/config  - App configurations"
    echo ""

    # Initialize as git repo if git is available
    if command -q git
        if not test -d $dots_dir/.git
            git -C $dots_dir init
            echo "Initialized git repository"

            # Create basic .gitignore
            echo "# Secrets and credentials" > $dots_dir/.gitignore
            echo "*.secret" >> $dots_dir/.gitignore
            echo "*.private" >> $dots_dir/.gitignore
            echo ".env" >> $dots_dir/.gitignore
            echo ""
        end
    end

    # Copy existing dotfiles into managed directory
    read -l -P "Copy existing dotfiles into $dots_dir? [y/N] " confirm
    if test "$confirm" = "y" -o "$confirm" = "Y"
        # Fish config
        if test -d $HOME/.config/fish
            cp -r $HOME/.config/fish/* $dots_dir/fish/ 2>/dev/null
            echo "Copied: Fish config"
        end

        # Git config
        if test -f $HOME/.gitconfig
            cp $HOME/.gitconfig $dots_dir/git/
            echo "Copied: .gitconfig"
        end

        # Shell profiles
        if test -f $HOME/.zshrc
            cp $HOME/.zshrc $dots_dir/shell/
            echo "Copied: .zshrc"
        end
        if test -f $HOME/.zprofile
            cp $HOME/.zprofile $dots_dir/shell/
            echo "Copied: .zprofile"
        end
        if test -f $HOME/.bashrc
            cp $HOME/.bashrc $dots_dir/shell/
            echo "Copied: .bashrc"
        end
    end

    echo ""
    echo "========================================================"
    echo "Dotfiles management initialized!"
    echo ""
    echo "Next steps:"
    echo "  1. Edit files in $dots_dir"
    echo "  2. Run 'srk9-dots-link' to create symlinks"
    echo "  3. Commit changes: cd $dots_dir && git add . && git commit"
end
