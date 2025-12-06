# SrK9 Initialization
# This file runs on every Fish shell startup

# ============================================
# XDG Environment Setup
# ============================================

# Set XDG defaults if not already set
set -q XDG_CONFIG_HOME; or set -gx XDG_CONFIG_HOME $HOME/.config
set -q XDG_CACHE_HOME; or set -gx XDG_CACHE_HOME $HOME/.cache
set -q XDG_STATE_HOME; or set -gx XDG_STATE_HOME $HOME/.local/state
set -q XDG_DATA_HOME; or set -gx XDG_DATA_HOME $HOME/.local/share

# Set SRK9 directories based on XDG (only if not already set as universal)
set -q SRK9_CONFIG_DIR; or set -gx SRK9_CONFIG_DIR $XDG_CONFIG_HOME/srk9
set -q SRK9_CACHE_DIR; or set -gx SRK9_CACHE_DIR $XDG_CACHE_HOME/srk9
set -q SRK9_STATE_DIR; or set -gx SRK9_STATE_DIR $XDG_STATE_HOME/srk9
set -q SRK9_SHARE_DIR; or set -gx SRK9_SHARE_DIR $XDG_DATA_HOME/srk9
set -q SRK9_BIN_DIR; or set -gx SRK9_BIN_DIR $HOME/.local/bin
set -q SRK9_OPT_DIR; or set -gx SRK9_OPT_DIR $SRK9_SHARE_DIR/opt

# Optional runtime directory
if set -q XDG_RUNTIME_DIR
    set -q SRK9_RUNTIME_DIR; or set -gx SRK9_RUNTIME_DIR $XDG_RUNTIME_DIR/srk9
end

# Ensure bin directory is in PATH
if test -d $SRK9_BIN_DIR
    contains $SRK9_BIN_DIR $fish_user_paths; or fish_add_path $SRK9_BIN_DIR
end

# ============================================
# Aliases
# ============================================

alias 9-install-fish 'brew install fish'
alias 9-install-fisher 'curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher'
alias 9-install-bootstrapper 'fisher install jellylabs-ltd/srk9-bootstrapper'

# ============================================
# Development Helpers
# ============================================

function dev-commit --description "Git add and commit with default message"
    echo 'fish executing "commit"'
    git add .
    git commit -m 'triggered fish.commit'
    echo '"commit" complete'
end

function dev-push --description "Push to origin master"
    echo 'fish executing "push"'
    git push origin master
    echo '"push" complete'
end

function dev-update --description "Update Fisher plugin"
    echo 'fish executing "update"'
    fisher update jellylabs-ltd/srk9-bootstrapper
    echo '"update" complete'
end

function dev-upgrade --description "Full pipeline: commit, push, update"
    echo 'fish executing "upgrade"'
    dev-commit
    dev-push
    dev-update
    echo '"upgrade" complete'
end

function dev-build --description "Show current directory"
    echo 'fish executing "build"'
    echo $PWD
    echo '"build" complete'
end

function dev-reset --description "Reset fish config directory"
    echo 'fish executing "reset"'
    rm -rvf ~/.config/fish
    echo '"reset" complete'
end
