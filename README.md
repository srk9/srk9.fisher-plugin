# srk9.bootstrapper

Fisher plugin for bootstrapping and syncing srk9 environments.

## Quick Install (One-Liner)

```bash
curl -fsSL https://raw.githubusercontent.com/srk9/srk9.bootstrapper/master/install.sh | bash
```

This installs Homebrew, Fish, Fisher, and the srk9-bootstrapper plugin automatically.

## Manual Installation

If you already have Fish and Fisher installed:

```fish
fisher install srk9/srk9.bootstrapper
```

## Commands

### Bootstrap
```fish
srk9-bootstrap              # Full system bootstrap
```

### Sync
```fish
srk9-sync status            # Check sync.srk9.io status
srk9-sync fish pull         # Pull fish functions to cache
srk9-sync claude pull       # Pull claude assets to cache
```

### Install Tools
```fish
srk9-install-homebrew       # Install Homebrew (global)
srk9-install-homebrew-locally  # Install Homebrew (local)
srk9-install-bun            # Install Bun runtime
srk9-install-volta          # Install Volta (Node manager)
srk9-install-claude         # Install Claude CLI
srk9-install-rosetta        # Install Rosetta (Apple Silicon)
```

### Utilities
```fish
srk9-list-functions         # List all srk9 functions
srk9-backup-dots            # Backup dotfiles
```

## Cache Directory

Synced assets are stored in:
```
~/.local/cache/srk9/sync/
├── fish/       # Fish functions
└── claude/     # Claude assets
```

## Related

- [sync.srk9.io](https://sync.srk9.io) - Asset sync service
- [srk9.sync](https://github.com/srk9/srk9.sync) - Service + CLI
