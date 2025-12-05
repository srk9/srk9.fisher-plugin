# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

SrK9 Bootstrapper is a Fish shell plugin for Fisher that provides a Systems Redundancy & Recovery Agent. It's designed as a collection of Fish functions for installing and managing development tools locally on macOS and Linux systems. The plugin is 100% pure Fish and provides tab-completable functions for seamless shell integration.

## Architecture

### Core Components

- **functions/**: Fish functions (auto-loaded by Fisher)
  - **Installation**: `srk9-install-*.fish` - Install development tools
  - **Uninstallation**: `srk9-uninstall-*.fish` - Remove installed tools
  - **Dotfiles**: `srk9-dots-*.fish` - Dotfiles management system
  - **Utilities**: `srk9-status.fish`, `srk9-help.fish`, `srk9-list-functions.fish`

- **completions/**: Tab-completion definitions
  - `srk9.fish` - Completions for all srk9 commands

- **conf.d/**: Fish configuration that runs on shell startup
  - `09-srk9-init.fish` - Aliases and development helper functions

### Plugin Structure

This is a Fisher plugin following Fish shell conventions:
- Functions in `functions/` directory are auto-loaded when plugin is installed
- Completions in `completions/` provide tab-completion
- Configuration in `conf.d/` runs automatically on shell startup
- No build step required - functions work immediately after installation

## Available Functions

### Installation Functions
```fish
srk9-install-bun        # Install Bun runtime locally
srk9-install-homebrew   # Install Homebrew globally
srk9-install-volta      # Install Volta Node.js manager
srk9-install-rosetta    # Install Rosetta (Apple Silicon)
srk9-install-claude     # Install Claude CLI
srk9-install-rust       # Install Rust via rustup
srk9-install-python     # Install Python via pyenv
srk9-install-go         # Install Go programming language
srk9-install-docker     # Install Docker
```

### Uninstall Functions
```fish
srk9-uninstall-bun      # Remove Bun installation
srk9-uninstall-volta    # Remove Volta installation
srk9-uninstall-rust     # Remove Rust installation
srk9-uninstall-python   # Remove pyenv installation
srk9-uninstall-go       # Remove Go installation
```

### Dotfiles Management
```fish
srk9-dots-init          # Initialize dotfiles management system
srk9-dots-link          # Create symlinks for managed dotfiles
srk9-dots-status        # Show dotfiles sync status
srk9-backup-dots        # Create timestamped backup of dotfiles
srk9-restore-dots       # Restore dotfiles from backup
```

### Utilities
```fish
srk9-status             # Show status of all installed tools
srk9-help               # Show help and available commands
srk9-list-functions     # List all srk9 functions
```

## Common Development Commands

### Plugin Development
```fish
# Development helpers (from conf.d)
dev-commit      # Git add and commit
dev-push        # Push to origin
dev-update      # Update Fisher plugin
dev-upgrade     # Full pipeline: commit -> push -> update
```

### Fisher Plugin Management
```fish
fisher install srk9/bootstrapper    # Install plugin
fisher update srk9/bootstrapper     # Update plugin
fisher remove srk9/bootstrapper     # Uninstall plugin
```

## Installation Requirements

1. **Fish Shell** - Required base shell
2. **Fisher** - Fish plugin manager
3. **Homebrew** - Recommended for installing Fish

### Dependency Chain
```bash
# Install Homebrew first
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install Fish via Homebrew
brew install fish

# Install Fisher inside Fish shell
curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher

# Install SrK9 plugin
fisher install srk9/bootstrapper
```

## Key Features

- **Local Installation Focus**: All tools install locally to avoid system conflicts
- **XDG Base Directory Compliant**: Follows proper directory standards
- **Tab Completion**: All functions are tab-completable in Fish
- **Shell Environment Management**: Automatically sets up PATH and environment variables
- **Cross-shell Compatibility**: Adds configuration for both Fish and zsh
- **Dotfiles Management**: Complete system for managing configuration files
- **Idempotent Design**: Safe to run functions multiple times

## Coding Conventions

When adding new functions:
1. Use the naming convention `srk9-<action>-<tool>.fish`
2. Include a `--description` in the function definition
3. Print progress with `echo "========..."`
4. Check if tool is already installed before proceeding
5. Add to both Fish path and `~/.zprofile` for zsh compatibility
6. Test installation at the end and provide feedback
7. Add completions to `completions/srk9.fish`

## Important Notes

- All installation functions create local installations (in `$HOME/.local` or `$HOME/.toolname`)
- Functions automatically add tools to both Fish environment and zsh profile
- The plugin is designed to be idempotent - safe to run multiple times
- No setup required after Fisher installation - functions are immediately available
