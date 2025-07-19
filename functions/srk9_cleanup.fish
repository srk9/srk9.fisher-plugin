function srk9_cleanup --description "Clean up system files and directories"
    echo "Cleaning up system files..."
    echo "WARNING: This will remove various files and directories!"
    echo "Press Ctrl+C to cancel, or Enter to continue..."
    read -l confirm
    
    echo "Removing directories and files..."
    
    # Remove directories
    set -l dirs_to_remove ~/.bin ~/.wallpapers ~/.fonts
    for dir in $dirs_to_remove
        if test -d $dir
            echo "Removing directory: $dir"
            rm -rvf $dir
        end
    end
    
    # Remove files
    set -l files_to_remove ~/README.md ~/.zshrc ~/.zprofile ~/stow.sh ~/backup.sh ~/__init__.sh ~/cleanup.sh ~/.stow-cleanup.sh ~/.gitconfig
    for file in $files_to_remove
        if test -f $file
            echo "Removing file: $file"
            rm $file
        end
    end
    
    echo "Cleanup completed!"
end