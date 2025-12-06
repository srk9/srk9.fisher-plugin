# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

SrK9 Bootstrapper is a Fish shell plugin for Fisher that provides a Systems Redundancy & Recovery Agent. It's designed as a collection of Fish functions for installing and managing development tools locally on macOS and Linux systems. The plugin is 100% pure Fish and provides tab-completable functions for seamless shell integration.

## Principles

1. **Bootstrapper Installation** - MUST be sudo-free, MUST use XDG structure
2. **XDG Compliance** - Follow XDG Base Directory Specification strictly
3. **Least Privilege** - Avoid sudo in tool installations where possible
4. **Document Deviations** - Any deviation must be documented (see SPEC.md)

## Architecture

### XDG Directory Structure

```
SRK9_CONFIG_DIR  = $XDG_CONFIG_HOME/srk9   # ~/.config/srk9
SRK9_CACHE_DIR   = $XDG_CACHE_HOME/srk9    # ~/.cache/srk9
SRK9_STATE_DIR   = $XDG_STATE_HOME/srk9    # ~/.local/state/srk9
SRK9_SHARE_DIR   = $XDG_DATA_HOME/srk9     # ~/.local/share/srk9
SRK9_BIN_DIR     = ~/.local/bin            # User executables
SRK9_OPT_DIR     = $SRK9_SHARE_DIR/opt     # Tool installations
```

### Core Components

- **functions/**: Fish functions (auto-loaded by Fisher)
  - **Installation**: `srk9-install-*.fish` - Install development tools
  - **Uninstallation**: `srk9-uninstall-*.fish` - Remove installed tools
  - **Dotfiles**: `srk9-dots-*.fish` - Dotfiles management system
  - **Utilities**: `srk9-status.fish`, `srk9-help.fish`, `srk9-env.fish`

- **completions/**: Tab-completion definitions

- **conf.d/**: Fish configuration that runs on shell startup
  - `09-srk9-init.fish` - XDG environment setup and aliases

### Plugin Structure

This is a Fisher plugin following Fish shell conventions:
- Functions in `functions/` directory are auto-loaded when plugin is installed
- Completions in `completions/` provide tab-completion
- Configuration in `conf.d/` runs automatically on shell startup
- No build step required - functions work immediately after installation

## Available Functions

### Environment Setup
```fish
srk9-init-dirs          # Initialize XDG directory structure
srk9-env                # Display environment variables
```

### Installation Functions (XDG Compliant, No Sudo)
```fish
srk9-install-bun                # Install Bun to $SRK9_OPT_DIR/bun
srk9-install-volta              # Install Volta to $SRK9_OPT_DIR/volta
srk9-install-rust               # Install Rust to $SRK9_OPT_DIR/{cargo,rustup}
srk9-install-python             # Install pyenv to $SRK9_OPT_DIR/pyenv
srk9-install-go                 # Install Go to $SRK9_OPT_DIR/go
srk9-install-homebrew-locally   # Install Homebrew to $SRK9_OPT_DIR/homebrew
srk9-install-claude             # Install Claude CLI (via Bun)
```

### Installation Functions (Documented Deviations)
```fish
srk9-install-docker     # Docker (requires sudo - see deviation docs)
srk9-install-rosetta    # Rosetta (requires sudo - Apple requirement)
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

## Installation

### Prerequisites
- Fish shell (user must install)

### One-liner (sudo-free)
```bash
curl -fsSL https://raw.githubusercontent.com/jellylabs-ltd/srk9-bootstrapper/master/install.sh | bash
```

### Manual Installation
```fish
# Install Fisher
curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher

# Install srk9-bootstrapper
fisher install jellylabs-ltd/srk9-bootstrapper

# Initialize directories
srk9-init-dirs
```

## Key Features

- **Sudo-Free Installation**: Bootstrapper installs without elevated privileges
- **XDG Base Directory Compliant**: All paths follow XDG specification
- **Local Installation Focus**: All tools install to `$SRK9_OPT_DIR`
- **Single PATH Entry**: Symlinks in `~/.local/bin`
- **Tab Completion**: All functions are tab-completable in Fish
- **Idempotent Design**: Safe to run functions multiple times
- **Documented Deviations**: Any sudo requirements are documented in SPEC.md

## Coding Conventions

When adding new functions:
1. Use the naming convention `srk9-<action>-<tool>.fish`
2. Include a `--description` in the function definition
3. Use `$SRK9_OPT_DIR` for tool installations
4. Create symlinks in `$SRK9_BIN_DIR`
5. Set environment variables with `set -Ux`
6. If sudo is required, document as deviation (see SPEC.md format)
7. Check if tool is already installed before proceeding
8. Add completions to `completions/srk9.fish`

## Important Notes

- All installation functions use XDG-compliant paths
- Tools install to `$SRK9_OPT_DIR` (~/.local/share/srk9/opt/)
- Binaries symlink to `$SRK9_BIN_DIR` (~/.local/bin/)
- See SPEC.md for full specification and deviation documentation
