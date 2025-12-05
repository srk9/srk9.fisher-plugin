# Completions for srk9 commands

# Main srk9 commands completion
complete -c srk9 -f -d "SrK9 Systems Redundancy & Recovery Agent"

# Installation commands
complete -c srk9-install-bun -f -d "Install Bun runtime locally"
complete -c srk9-install-homebrew -f -d "Install Homebrew globally"
complete -c srk9-install-homebrew-locally -f -d "Install Homebrew locally"
complete -c srk9-install-volta -f -d "Install Volta Node.js version manager"
complete -c srk9-install-rosetta -f -d "Install Rosetta for Apple Silicon"
complete -c srk9-install-claude -f -d "Install Claude CLI"
complete -c srk9-install-rust -f -d "Install Rust via rustup"
complete -c srk9-install-python -f -d "Install Python via pyenv"
complete -c srk9-install-go -f -d "Install Go programming language"
complete -c srk9-install-docker -f -d "Install Docker"

# Status commands
complete -c srk9-status -f -d "Show status of all installed tools"
complete -c srk9-status-all -f -d "Show detailed status of all tools"

# Uninstall commands
complete -c srk9-uninstall-bun -f -d "Uninstall Bun runtime"
complete -c srk9-uninstall-volta -f -d "Uninstall Volta"
complete -c srk9-uninstall-rust -f -d "Uninstall Rust"
complete -c srk9-uninstall-python -f -d "Uninstall pyenv"
complete -c srk9-uninstall-go -f -d "Uninstall Go"

# Utility commands
complete -c srk9-list-functions -f -d "List available srk9 functions"
complete -c srk9-backup-dots -f -d "Backup dotfiles with timestamp"
complete -c srk9-restore-dots -f -d "Restore dotfiles from backup"
complete -c srk9-help -f -d "Show srk9 help and available commands"
