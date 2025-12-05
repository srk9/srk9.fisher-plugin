function srk9-uninstall-volta --description "Uninstall Volta Node.js version manager"
    set -l volta_home $HOME/.volta

    echo "Uninstalling Volta..."
    echo "========================================================"

    if not test -d $volta_home
        echo "Volta is not installed at $volta_home"
        return 0
    end

    # Confirm removal
    read -l -P "Remove Volta installation at $volta_home? This will also remove installed Node.js versions. [y/N] " confirm
    if test "$confirm" != "y" -a "$confirm" != "Y"
        echo "Cancelled."
        return 0
    end

    # Remove installation directory
    rm -rf $volta_home
    echo "Removed: $volta_home"

    # Remove from Fish path
    if set -l index (contains -i $volta_home/bin $fish_user_paths)
        set -e fish_user_paths[$index]
        echo "Removed from Fish path"
    end

    # Unset environment variable
    set -e VOLTA_HOME

    echo "========================================================"
    echo "Volta uninstalled successfully!"
    echo "Note: You may need to manually remove VOLTA entries from ~/.zprofile"
end
