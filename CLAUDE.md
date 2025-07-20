# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

SrK9 is a Fish shell plugin for Fisher that provides a Systems Redundancy & Recovery Agent. It's designed as a collection of Fish functions for installing and managing development tools locally on macOS systems. The plugin is 100% pure Fish and provides tab-completable functions for seamless shell integration.

## Architecture

### Core Components

- **functions/**: Fish functions for installing development tools
  - `srk9.install_bun.fish` - Installs Bun runtime locally
  - `srk9.install_homebrew.fish` - Installs Homebrew locally  
  - `srk9.install_volta.fish` - Installs Volta Node.js version manager
  - `srk9.install_rosetta.fish` - Installs Rosetta for Apple Silicon compatibility
  - `srk9.list_functions.fish` - Lists available srk9 functions

- **conf.d/**: Fish configuration that runs on shell startup
  - `srk9.on_start.fish` - Lists srk9 functions when new terminal opens

- **_hidden/**: Contains extensive dotfiles and configuration management system
  - Comprehensive system for managing macOS development environments
  - Configuration templates for git, zsh, starship, ghostty, etc.
  - Font collection and system initialization scripts

### Plugin Structure

This is a Fisher plugin following Fish shell conventions:
- Functions in `functions/` directory are auto-loaded when plugin is installed
- Configuration in `conf.d/` runs automatically on shell startup
- No build step required - functions work immediately after installation

## Common Development Commands

### Plugin Development
```bash
# Reload plugin during development
dev_reload_plug  # Commits changes and updates Fisher plugin

# List available srk9 functions
list_functions   # Shows all srk9 functions
```

### Installation Functions
```bash
# Install development tools locally
srk9_install_bun        # Install Bun runtime
srk9_install_homebrew   # Install Homebrew locally
srk9_install_volta      # Install Volta Node.js manager
srk9_install_rosetta    # Install Rosetta for compatibility
```

### Fisher Plugin Management
```bash
# Install plugin
fisher install srk9/srk9.fisher-plugin

# Update plugin
fisher update srk9/srk9.fisher-plugin

# Uninstall plugin
fisher remove srk9/srk9.fisher-plugin
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
fisher install srk9/srk9.fisher-plugin
```

## Key Features

- **Local Installation Focus**: All tools install locally to avoid system conflicts
- **XDG Base Directory Compliant**: Follows proper directory standards
- **Tab Completion**: All functions are tab-completable in Fish
- **Shell Environment Management**: Automatically sets up PATH and environment variables
- **Cross-shell Compatibility**: Adds configuration for both Fish and zsh

## Important Notes

- All installation functions create local installations (in `$HOME/.local` or `$HOME/.toolname`)
- Functions automatically add tools to both Fish environment and zsh profile
- The plugin is designed to be idempotent - safe to run multiple times
- No setup required after Fisher installation - functions are immediately available