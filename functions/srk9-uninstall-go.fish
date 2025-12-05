function srk9-uninstall-go --description "Uninstall Go programming language"
    set -l go_install_path $HOME/.local/go
    set -l gopath $HOME/go

    echo "Uninstalling Go..."
    echo "========================================================"

    if not test -d $go_install_path
        echo "Go is not installed at $go_install_path"
        return 0
    end

    # Confirm removal
    read -l -P "Remove Go installation at $go_install_path? [y/N] " confirm
    if test "$confirm" != "y" -a "$confirm" != "Y"
        echo "Cancelled."
        return 0
    end

    # Ask about GOPATH
    if test -d $gopath
        read -l -P "Also remove GOPATH at $gopath? (contains your Go projects) [y/N] " confirm_gopath
        if test "$confirm_gopath" = "y" -o "$confirm_gopath" = "Y"
            rm -rf $gopath
            echo "Removed: $gopath"
        end
    end

    # Remove installation directory
    rm -rf $go_install_path
    echo "Removed: $go_install_path"

    # Remove from Fish path
    if set -l index (contains -i $go_install_path/bin $fish_user_paths)
        set -e fish_user_paths[$index]
    end
    if set -l index (contains -i $gopath/bin $fish_user_paths)
        set -e fish_user_paths[$index]
    end
    echo "Removed from Fish path"

    # Unset environment variables
    set -e GOROOT
    set -e GOPATH

    echo "========================================================"
    echo "Go uninstalled successfully!"
    echo "Note: You may need to manually remove GO entries from ~/.zprofile"
end
