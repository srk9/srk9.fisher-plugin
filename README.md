# SrK9 Bootstrapper - Fish(er) Plugin (v0.1.0)

> A Systems Redundancy & Recovery Agent

**NOTE:** This package is not POSIX-compatible as it was hand-crafted just for Fish

- 100% pure Fish - simple to contribute to or tweak
- Tab-completable for seamless shell integration
- XDG Base Directory compliant
- No setup needed - it just works!

## Features

### Development Tool Installation
Install popular development tools locally with a single command:

- **Bun** - Fast JavaScript runtime
- **Volta** - Node.js version manager
- **Rust** - Systems programming language (via rustup)
- **Python** - Via pyenv for version management
- **Go** - Go programming language
- **Docker** - Container runtime
- **Homebrew** - Package manager (global or local installation)
- **Claude CLI** - Anthropic's Claude command-line interface
- **Rosetta** - Apple Silicon compatibility layer

### Dotfiles Management
Complete system for managing and syncing your configuration files:

- Initialize dotfiles repository
- Create symlinks for managed configs
- Backup and restore functionality
- Git integration for version control

### Status & Utilities
- Check installation status of all tools
- List available functions
- Comprehensive help system

## Installation

### Via Fisher (Recommended)
```fish
fisher install srk9/bootstrapper
```

### Update
```fish
fisher update srk9/bootstrapper
```

### Uninstall
```fish
fisher remove srk9/bootstrapper
```

## Dependency Chain

1. **Homebrew** - `which brew`
   ```bash
   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
   ```

2. **Fish Shell** - `which fish` (easiest via Homebrew)
   ```fish
   brew install fish
   ```

3. **Fisher** - Must be run inside Fish shell
   ```fish
   curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher
   ```

4. **SrK9 Bootstrapper**
   ```fish
   fisher install srk9/bootstrapper
   ```

## Usage

### Quick Start
```fish
# See available commands
srk9-help

# Check what's installed
srk9-status

# List all srk9 functions
srk9-list-functions
```

### Installation Commands
```fish
srk9-install-bun          # Install Bun runtime
srk9-install-volta        # Install Volta + Node.js
srk9-install-rust         # Install Rust via rustup
srk9-install-python       # Install pyenv + Python
srk9-install-go           # Install Go
srk9-install-docker       # Install Docker
srk9-install-homebrew     # Install Homebrew (global)
srk9-install-claude       # Install Claude CLI
srk9-install-rosetta      # Install Rosetta (Apple Silicon)
```

### Uninstall Commands
```fish
srk9-uninstall-bun        # Remove Bun
srk9-uninstall-volta      # Remove Volta
srk9-uninstall-rust       # Remove Rust
srk9-uninstall-python     # Remove pyenv
srk9-uninstall-go         # Remove Go
```

### Dotfiles Management
```fish
srk9-dots-init            # Initialize dotfiles management
srk9-dots-link            # Create symlinks
srk9-dots-status          # Show sync status
srk9-backup-dots          # Create timestamped backup
srk9-restore-dots         # Restore from backup
```

## Project Structure

```
bootstrapper/
├── functions/            # Fish functions (auto-loaded)
│   ├── srk9-install-*.fish    # Installation functions
│   ├── srk9-uninstall-*.fish  # Uninstall functions
│   ├── srk9-dots-*.fish       # Dotfiles management
│   ├── srk9-status.fish       # Status checking
│   └── srk9-help.fish         # Help command
├── completions/          # Tab-completion definitions
│   └── srk9.fish
├── conf.d/               # Shell startup configuration
│   └── 09-srk9-init.fish
├── CLAUDE.md             # AI assistant instructions
├── README.md             # This file
└── LICENSE.md            # MIT License
```

## Tips

- All installations are **local** (in `$HOME/.local` or `$HOME/.toolname`) to avoid system conflicts
- Functions automatically configure both Fish and zsh environments
- All functions are **idempotent** - safe to run multiple times
- Use `srk9-status` to see what's currently installed
- Fisher tracks installed plugins in `$__fish_config_dir/fish_plugins` - version control this file!

## License

MIT License - see [LICENSE.md](LICENSE.md)
