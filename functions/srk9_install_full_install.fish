function srk9_init --description "Initialize SRK9 system environment"
    echo '#############################################'
    echo 'Triggered srk9_init'
    echo '#############################################'
    
    # Create shell config files if they don't exist
    touch $HOME/.zshrc
    touch $HOME/.zprofile
    
    # Set SRK9 environment variables
    set -l SRK9_INSTALL_PATH $HOME/.srk9
    set -l SRK9_BACKUP_DIR $HOME/.srk9.backups
    set -l SRK9_DOTFILES $HOME/.srk9/assets/dotfiles
    
    # Add SRK9 to PATH in zsh configs (for compatibility)
    echo "SRK9_BIN=$SRK9_INSTALL_PATH" >> $HOME/.zshrc
    echo "PATH=\$SRK9_BIN:\$PATH" >> $HOME/.zshrc
    
    # Create backup directory if it doesn't exist
    if not test -d $HOME/.srk9.backups
        mkdir -p $HOME/.srk9.backups
    end
    
    # Backup existing configs if they exist
    if test -f $HOME/.zshrc
        cp $HOME/.zshrc $HOME/.srk9.backups/
    end
    
    if test -f $HOME/.zprofile
        cp $HOME/.zprofile $HOME/.srk9.backups/
    end
    
    echo "srk9 functions are now available in Fish"
    echo "For zsh compatibility, source ~/.zshrc"
end