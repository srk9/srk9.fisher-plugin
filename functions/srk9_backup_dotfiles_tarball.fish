function srk9_backup_dotfiles_tarball --description "Backup dotfiles to a compressed tarball"
    set -l timestamp (date +%Y%m%d_%H%M%S)
    set -l backup_file "$HOME/dotfiles_backup_$timestamp.tar.gz"
    
    echo "Creating dotfiles tarball backup..."
    echo "Target file: $backup_file"
    echo ""
    
    # Check which files exist before backing up
    set -l files_to_backup ~/.config ~/.zshrc ~/.zprofile ~/.vimrc ~/.gitconfig ~/.gitignore
    set -l existing_files
    
    for file in $files_to_backup
        if test -e $file
            set -a existing_files $file
            echo "  Including: $file"
        else
            echo "  Skipping: $file (doesn't exist)"
        end
    end
    
    if test (count $existing_files) -eq 0
        echo "No dotfiles found to backup!"
        return 1
    end
    
    echo ""
    echo "Creating tarball..."
    
    # Create the tarball with only existing files
    tar -czf $backup_file -C $HOME (for file in $existing_files; basename $file; end) 2>/dev/null
    
    if test $status -eq 0
        echo "✓ Backup created successfully: $backup_file"
        echo "Size: "(du -h $backup_file | cut -f1)
    else
        echo "✗ Backup failed!"
        return 1
    end
end