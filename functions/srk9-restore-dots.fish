function srk9-restore-dots --description "Restore dotfiles from backup"
    set -l backup_base $HOME/.dotfiles-backup

    echo "Restore Dotfiles from Backup"
    echo "========================================================"

    # Check if backup directory exists
    if not test -d $backup_base
        echo "No backup directory found at $backup_base"
        return 1
    end

    # List available backups
    echo "Available backups:"
    set -l backups (ls -1 $backup_base 2>/dev/null)

    if test (count $backups) -eq 0
        echo "No backups found."
        return 1
    end

    set -l i 1
    for backup in $backups
        echo "  $i) $backup"
        set i (math $i + 1)
    end

    echo ""
    read -l -P "Enter backup number to restore (or 'q' to quit): " choice

    if test "$choice" = "q"
        echo "Cancelled."
        return 0
    end

    # Validate choice
    if not string match -qr '^\d+$' -- $choice
        echo "Invalid selection."
        return 1
    end

    if test $choice -lt 1 -o $choice -gt (count $backups)
        echo "Invalid selection."
        return 1
    end

    set -l selected_backup $backups[$choice]
    set -l backup_path $backup_base/$selected_backup

    echo ""
    echo "Restoring from: $backup_path"
    echo ""

    # Confirm
    read -l -P "This will overwrite current dotfiles. Continue? [y/N] " confirm
    if test "$confirm" != "y" -a "$confirm" != "Y"
        echo "Cancelled."
        return 0
    end

    # Restore files
    if test -d $backup_path/.config
        cp -r $backup_path/.config $HOME/
        echo "Restored: .config"
    end

    if test -f $backup_path/.zshrc
        cp $backup_path/.zshrc $HOME/
        echo "Restored: .zshrc"
    end

    if test -f $backup_path/.zprofile
        cp $backup_path/.zprofile $HOME/
        echo "Restored: .zprofile"
    end

    if test -f $backup_path/.gitconfig
        cp $backup_path/.gitconfig $HOME/
        echo "Restored: .gitconfig"
    end

    echo ""
    echo "========================================================"
    echo "Dotfiles restored successfully!"
    echo "You may need to restart your shell for changes to take effect."
end
