# SRK9 Bootstrapper Specification

## Principles

1. **Bootstrapper Installation** - MUST be sudo-free, MUST use XDG structure
2. **XDG Compliance** - Follow XDG Base Directory Specification strictly
3. **Least Privilege** - Avoid sudo in tool installations where possible
4. **Document Deviations** - Any deviation must be documented with reason + future fix

---

## XDG Base Directory Compliance

The bootstrapper follows the [XDG Base Directory Specification](https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html).

### Environment Variables

| Variable | XDG Source | Default | Purpose |
|----------|------------|---------|---------|
| `SRK9_CONFIG_DIR` | `$XDG_CONFIG_HOME/srk9` | `~/.config/srk9` | Configuration files |
| `SRK9_CACHE_DIR` | `$XDG_CACHE_HOME/srk9` | `~/.cache/srk9` | Non-essential cached data |
| `SRK9_STATE_DIR` | `$XDG_STATE_HOME/srk9` | `~/.local/state/srk9` | Persistent state, logs |
| `SRK9_SHARE_DIR` | `$XDG_DATA_HOME/srk9` | `~/.local/share/srk9` | Application data |
| `SRK9_RUNTIME_DIR` | `$XDG_RUNTIME_DIR/srk9` | (none) | Runtime files (optional) |
| `SRK9_BIN_DIR` | N/A | `~/.local/bin` | User executables |
| `SRK9_OPT_DIR` | N/A | `$SRK9_SHARE_DIR/opt` | Third-party tool installations |

### Directory Structure

```
~/.config/srk9/           # SRK9_CONFIG_DIR
├── config.fish           # User configuration overrides
└── tools.conf            # Tool-specific settings

~/.cache/srk9/            # SRK9_CACHE_DIR
├── downloads/            # Downloaded installers
└── sync/                 # Sync service cache

~/.local/state/srk9/      # SRK9_STATE_DIR
├── install.log           # Installation history
└── migrations/           # Migration state

~/.local/share/srk9/      # SRK9_SHARE_DIR
├── dotfiles/             # Managed dotfiles
└── opt/                  # SRK9_OPT_DIR - Tool installations
    ├── bun/
    ├── volta/
    ├── cargo/
    ├── rustup/
    ├── pyenv/
    ├── go/
    └── homebrew/

~/.local/bin/             # SRK9_BIN_DIR
├── bun -> ../share/srk9/opt/bun/bin/bun
├── node -> ../share/srk9/opt/volta/bin/node
├── cargo -> ../share/srk9/opt/cargo/bin/cargo
└── ...                   # Symlinks to tool binaries
```

---

## Deviation Documentation

All deviations from XDG spec or least-privilege principles MUST be documented using this format:

```markdown
### DEVIATION: <name>
- **What**: Description of the deviation
- **Why**: Reason it's necessary
- **Impact**: What this affects
- **Future Fix**: How this could be made compliant (or "None needed" if acceptable)
```

### Current Deviations

#### DEVIATION: Extended directories (BIN_DIR, OPT_DIR)
- **What**: XDG spec doesn't define locations for executables or third-party software installations
- **Why**: Need somewhere to put tool binaries and installations
- **Impact**: Using `~/.local/bin` and `$XDG_DATA_HOME/srk9/opt`
- **Future Fix**: None needed - these follow established freedesktop.org conventions

#### DEVIATION: Docker installation requires sudo
- **What**: Docker daemon requires root privileges to run
- **Why**: Docker needs kernel access for containerization (cgroups, namespaces)
- **Impact**: Cannot install Docker daemon without elevated privileges
- **Future Fix**: Recommend rootless Docker mode or Podman as alternative

#### DEVIATION: Rosetta installation requires sudo
- **What**: Rosetta 2 installation requires admin privileges via `softwareupdate`
- **Why**: Apple system requirement for x86 emulation layer
- **Impact**: Cannot install Rosetta without elevated privileges on Apple Silicon
- **Future Fix**: Document as manual prerequisite; detect and prompt user

---

## Tool Installation

### Supported Tools (sudo-free)

| Tool | Install Path | Environment Variable |
|------|--------------|---------------------|
| Bun | `$SRK9_OPT_DIR/bun` | `BUN_INSTALL` |
| Volta | `$SRK9_OPT_DIR/volta` | `VOLTA_HOME` |
| Rust (Cargo) | `$SRK9_OPT_DIR/cargo` | `CARGO_HOME` |
| Rust (Rustup) | `$SRK9_OPT_DIR/rustup` | `RUSTUP_HOME` |
| Python (pyenv) | `$SRK9_OPT_DIR/pyenv` | `PYENV_ROOT` |
| Go | `$SRK9_OPT_DIR/go` | `GOROOT`, `GOPATH` |
| Homebrew (local) | `$SRK9_OPT_DIR/homebrew` | `HOMEBREW_PREFIX` |
| Claude CLI | via Bun global | N/A |

### Tools with Deviations (documented)

| Tool | Deviation | Alternative |
|------|-----------|-------------|
| Docker | Requires sudo | Use rootless mode or Podman |
| Rosetta | Requires sudo | Manual installation |

### Removed Tools

| Tool | Reason |
|------|--------|
| Homebrew (global) | Requires sudo for `/opt/homebrew` |

---

## Bootstrap Process

### Prerequisites

- Fish shell (user must install)
- curl (typically pre-installed)
- git (for some tool installers)

### Installation Flow

```
1. User installs Fish shell (their responsibility)
2. Run install.sh (no sudo required):
   a. Verify Fish is available
   b. Install Fisher plugin manager
   c. Install srk9-bootstrapper via Fisher
   d. Run srk9-init-dirs to create XDG structure
3. Bootstrapper ready - user can run srk9-* commands
```

### Post-Installation

```fish
# View available commands
srk9-help

# Check environment
srk9-env

# Install tools
srk9-install-bun
srk9-install-volta
srk9-install-rust
# etc.
```

---

## Migration

For users with existing installations at legacy paths:

| Legacy Path | New Path | Migration |
|-------------|----------|-----------|
| `~/.bun` | `$SRK9_OPT_DIR/bun` | `srk9-migrate` |
| `~/.volta` | `$SRK9_OPT_DIR/volta` | `srk9-migrate` |
| `~/.cargo` | `$SRK9_OPT_DIR/cargo` | `srk9-migrate` |
| `~/.rustup` | `$SRK9_OPT_DIR/rustup` | `srk9-migrate` |
| `~/.pyenv` | `$SRK9_OPT_DIR/pyenv` | `srk9-migrate` |
| `~/go` | `$SRK9_OPT_DIR/go` | `srk9-migrate` |

The `srk9-migrate` function will:
1. Detect existing installations at legacy paths
2. Move them to XDG-compliant locations
3. Update environment variables
4. Create symlinks in `$SRK9_BIN_DIR`
