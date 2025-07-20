function srk9-backup-dots --description "Create backups of current dotfiles"
    set -l timestamp (date +%Y%m%d%H%M%S)
    set -l backup_dir "$HOME/$timestamp-dotsfiles-backup"

    echo "Creating backup directory: $backup_dir"
    mkdir -p $backup_dir

    # Backup common dotfiles if they exist
    set -l files_to_backup .config .zshrc .zprofile .gitconfig

    for file in $files_to_backup
        if test -e "$HOME/$file"
            echo "Backing up $file"
            mv "$HOME/$file" "$backup_dir/"(basename $file)
        else
            echo "Skipping $file (doesn't exist)"
        end
    end

    echo ""
    echo "Note: Currently stowed dotfiles will not be backed up because they are symlinks."
    echo "Backup completed - Located at: $backup_dir"
end
