function srk9_manage_dotfiles --description "Manage dotfiles with symlinks"
    echo "Managing dotfiles with symlinks..."
    echo "======================================"
    
    set -l dotfiles zshrc zprofile gitconfig gitignore
    set -l source_dir $HOME/.srk9/src/configurator/dot-files
    
    # Check if source directory exists
    if not test -d $source_dir
        echo "Error: Source dotfiles directory not found at $source_dir"
        return 1
    end
    
    for file in $dotfiles
        set -l source_file "$source_dir/dot-$file"
        set -l target_file "$HOME/.$file"
        
        if test -f $source_file
            echo "Creating symlink for $file"
            # Remove existing file/symlink if it exists
            if test -e $target_file
                rm $target_file
            end
            ln -s $source_file $target_file
        else
            echo "Warning: Source file not found: $source_file"
        end
    end
    
    echo "Dotfile management completed!"
end