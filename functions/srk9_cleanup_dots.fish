function srk9_cleanup_dots --description "Clean up dotfile symlinks"
    echo "Cleaning up dotfile symlinks..."
    
    set -l dotfiles zshrc zprofile gitconfig gitignore
    
    for file in $dotfiles
        set -l target "$HOME/.$file"
        
        if test -L $target
            echo "Removing symlink: .$file"
            rm $target
        else if test -f $target
            echo "Warning: .$file exists but is not a symlink. Skipping."
        else
            echo ".$file does not exist"
        end
    end
    
    echo "Dotfile cleanup completed!"
end