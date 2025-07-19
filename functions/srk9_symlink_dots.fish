function srk9_symlink_dots --description "Create symlinks for dotfiles"
    echo "Creating symlinks for dotfiles..."
    
    set -l dotfiles zshrc zprofile gitconfig gitignore
    set -l configurator_dir $HOME/.srk9/src/configurator/dot-files
    
    if not test -d $configurator_dir
        echo "Error: Configurator directory not found at $configurator_dir"
        return 1
    end
    
    for file in $dotfiles
        set -l source "$configurator_dir/dot-$file"
        set -l target "$HOME/.$file"
        
        if test -f $source
            echo "Linking .$file -> $source"
            ln -sf $source $target
        else
            echo "Warning: Source file $source not found"
        end
    end
    
    echo "Symlink creation completed!"
end