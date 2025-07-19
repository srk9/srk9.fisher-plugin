function srk9_update --description "Update SRK9 system"
    echo "Updating SRK9 system..."
    echo "========================================"
    
    set -l srk9_dir $HOME/.srk9
    
    if test -d "$srk9_dir/.git"
        echo "Updating SRK9 from Git repository..."
        cd $srk9_dir
        git pull origin master
        echo "SRK9 updated successfully!"
    else
        echo "SRK9 is not a Git repository."
        echo "Manual update required or re-clone from source."
    end
    
    echo "========================================"
    echo "Update completed!"
    echo "If Fish functions were updated, they are automatically available."
end