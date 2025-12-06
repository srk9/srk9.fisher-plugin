# srk9-bootstrapper

Fisher plugin for bootstrapping development environments. **Sudo-free, XDG-compliant.**

## Principles

1. **No sudo required** - Bootstrapper installs without elevated privileges
2. **XDG compliant** - Follows XDG Base Directory Specification
3. **Local-first** - All tools install to user directories
4. **Documented deviations** - Any exceptions are documented in SPEC.md

## Quick Install

**Prerequisites:** Fish shell must be installed first.

```sh
curl -fsSL https://raw.githubusercontent.com/jellylabs-ltd/srk9-bootstrapper/master/install.sh | bash
```

## Manual Installation

```fish
# Install Fisher
curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher

# Install srk9-bootstrapper
fisher install jellylabs-ltd/srk9-bootstrapper

# Initialize XDG directories
srk9-init-dirs
```

## Directory Structure

All paths follow XDG Base Directory Specification:

```
~/.config/srk9/           # Configuration
~/.cache/srk9/            # Cache (downloads, sync)
~/.local/state/srk9/      # State and logs
~/.local/share/srk9/      # Application data
~/.local/share/srk9/opt/  # Tool installations
~/.local/bin/             # Symlinks to binaries
```

## Commands

### Environment
```fish
srk9-init-dirs              # Initialize XDG directory structure
srk9-env                    # Show environment variables
srk9-status                 # Check installed tools
srk9-help                   # Show all commands
```

### Install Tools (sudo-free)
```fish
srk9-install-bun                # Bun runtime
srk9-install-volta              # Volta (Node.js manager)
srk9-install-rust               # Rust via rustup
srk9-install-python             # Python via pyenv
srk9-install-go                 # Go programming language
srk9-install-homebrew-locally   # Homebrew (local install)
srk9-install-claude             # Claude CLI
```

### Install Tools (with deviations)
```fish
srk9-install-docker         # Docker (see deviation docs)
srk9-install-rosetta        # Rosetta (Apple requirement)
```

### Dotfiles
```fish
srk9-dots-init              # Initialize dotfiles system
srk9-dots-link              # Create symlinks
srk9-dots-status            # Check sync status
srk9-backup-dots            # Backup dotfiles
srk9-restore-dots           # Restore from backup
```

### Sync
```fish
srk9-sync status            # Check sync.srk9.io status
srk9-sync fish pull         # Pull fish functions
srk9-sync claude pull       # Pull claude assets
```

## Tool Installation Paths

| Tool | Path |
|------|------|
| Bun | `~/.local/share/srk9/opt/bun` |
| Volta | `~/.local/share/srk9/opt/volta` |
| Rust | `~/.local/share/srk9/opt/{cargo,rustup}` |
| Python | `~/.local/share/srk9/opt/pyenv` |
| Go | `~/.local/share/srk9/opt/go` |
| Homebrew | `~/.local/share/srk9/opt/homebrew` |

## Documentation

- [SPEC.md](SPEC.md) - Full specification and deviation documentation
- [CLAUDE.md](CLAUDE.md) - AI assistant guidance

## Related

- [sync.srk9.io](https://sync.srk9.io) - Asset sync service
