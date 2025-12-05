function srk9-uninstall-bun --description "Uninstall Bun runtime"
    set -l bun_install_path $HOME/.bun

    echo "Uninstalling Bun..."
    echo "========================================================"

    if not test -d $bun_install_path
        echo "Bun is not installed at $bun_install_path"
        return 0
    end

    # Confirm removal
    read -l -P "Remove Bun installation at $bun_install_path? [y/N] " confirm
    if test "$confirm" != "y" -a "$confirm" != "Y"
        echo "Cancelled."
        return 0
    end

    # Remove installation directory
    rm -rf $bun_install_path
    echo "Removed: $bun_install_path"

    # Remove from Fish path
    if set -l index (contains -i $bun_install_path/bin $fish_user_paths)
        set -e fish_user_paths[$index]
        echo "Removed from Fish path"
    end

    # Unset environment variable
    set -e BUN_INSTALL

    echo "========================================================"
    echo "Bun uninstalled successfully!"
    echo "Note: You may need to manually remove BUN entries from ~/.zprofile"
end
