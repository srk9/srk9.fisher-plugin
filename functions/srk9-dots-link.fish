function srk9-dots-link --description "Create symlinks for managed dotfiles"
    set -l dots_dir $HOME/.dotfiles

    echo "Create Dotfile Symlinks"
    echo "========================================================"

    if not test -d $dots_dir
        echo "Dotfiles directory not found. Run 'srk9-dots-init' first."
        return 1
    end

    # Helper function to create symlink with backup
    function _create_link
        set -l source $argv[1]
        set -l target $argv[2]

        if not test -e $source
            return
        end

        # Backup existing file if it's not already a symlink
        if test -e $target -a ! -L $target
            set -l backup "$target.bak"
            mv $target $backup
            echo "  Backed up: $target -> $backup"
        end

        # Remove existing symlink
        if test -L $target
            rm $target
        end

        # Create parent directory if needed
        mkdir -p (dirname $target)

        # Create symlink
        ln -s $source $target
        echo "  Linked: $target -> $source"
    end

    echo ""
    echo "Creating symlinks..."
    echo ""

    # Link Fish config
    if test -d $dots_dir/fish
        for file in $dots_dir/fish/*
            set -l filename (basename $file)
            _create_link $file $HOME/.config/fish/$filename
        end
    end

    # Link Git config
    if test -f $dots_dir/git/.gitconfig
        _create_link $dots_dir/git/.gitconfig $HOME/.gitconfig
    end

    # Link shell profiles
    if test -f $dots_dir/shell/.zshrc
        _create_link $dots_dir/shell/.zshrc $HOME/.zshrc
    end
    if test -f $dots_dir/shell/.zprofile
        _create_link $dots_dir/shell/.zprofile $HOME/.zprofile
    end
    if test -f $dots_dir/shell/.bashrc
        _create_link $dots_dir/shell/.bashrc $HOME/.bashrc
    end

    # Link config files
    if test -d $dots_dir/config
        for dir in $dots_dir/config/*
            if test -d $dir
                set -l dirname (basename $dir)
                _create_link $dir $HOME/.config/$dirname
            end
        end
    end

    # Clean up helper function
    functions -e _create_link

    echo ""
    echo "========================================================"
    echo "Symlinks created successfully!"
end
