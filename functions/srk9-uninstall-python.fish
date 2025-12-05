function srk9-uninstall-python --description "Uninstall pyenv and Python versions"
    set -l pyenv_root $HOME/.pyenv

    echo "Uninstalling pyenv..."
    echo "========================================================"

    if not test -d $pyenv_root
        echo "pyenv is not installed at $pyenv_root"
        return 0
    end

    # Show installed versions
    if command -q pyenv
        echo "Installed Python versions:"
        pyenv versions
        echo ""
    end

    # Confirm removal
    read -l -P "Remove pyenv and all installed Python versions at $pyenv_root? [y/N] " confirm
    if test "$confirm" != "y" -a "$confirm" != "Y"
        echo "Cancelled."
        return 0
    end

    # Remove installation directory
    rm -rf $pyenv_root
    echo "Removed: $pyenv_root"

    # Remove from Fish path
    if set -l index (contains -i $pyenv_root/bin $fish_user_paths)
        set -e fish_user_paths[$index]
        echo "Removed from Fish path"
    end

    # Unset environment variable
    set -e PYENV_ROOT

    echo "========================================================"
    echo "pyenv uninstalled successfully!"
    echo "Note: You may need to manually remove PYENV entries from ~/.zprofile and ~/.config/fish/config.fish"
end
