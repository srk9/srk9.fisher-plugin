function srk9_reset --description "Reset development environment"
    echo "Resetting development environment..."
    echo "WARNING: This will remove Fish installation and related files!"
    echo "Press Ctrl+C to cancel, or Enter to continue..."
    read -l confirm
    
    set -l fish_install_path /.local/bin/fish
    
    if test -d $fish_install_path
        echo "Removing Fish installation: $fish_install_path"
        rm -rvf $fish_install_path
        echo "Removed $fish_install_path"
    else
        echo "Fish installation not found at $fish_install_path"
    end
    
    echo ""
    echo "TODO: Remove fish from /etc/shells manually if needed"
    echo "You can verify by running 'cat /etc/shells'"
    echo ""
    echo "Development environment reset completed!"
end