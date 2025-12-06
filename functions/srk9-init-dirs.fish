function srk9-init-dirs --description "Initialize XDG-compliant SRK9 directory structure"
    # Ensure XDG base directories have defaults
    set -q XDG_CONFIG_HOME; or set -l XDG_CONFIG_HOME $HOME/.config
    set -q XDG_CACHE_HOME; or set -l XDG_CACHE_HOME $HOME/.cache
    set -q XDG_STATE_HOME; or set -l XDG_STATE_HOME $HOME/.local/state
    set -q XDG_DATA_HOME; or set -l XDG_DATA_HOME $HOME/.local/share

    # Define SRK9 directories
    set -l config_dir $XDG_CONFIG_HOME/srk9
    set -l cache_dir $XDG_CACHE_HOME/srk9
    set -l state_dir $XDG_STATE_HOME/srk9
    set -l share_dir $XDG_DATA_HOME/srk9
    set -l bin_dir $HOME/.local/bin
    set -l opt_dir $share_dir/opt

    echo "========================================"
    echo "Initializing SRK9 XDG directory structure"
    echo "========================================"

    # Create directories
    echo "Creating directories..."

    mkdir -p $config_dir
    and echo "  ✓ SRK9_CONFIG_DIR: $config_dir"

    mkdir -p $cache_dir/downloads
    mkdir -p $cache_dir/sync
    and echo "  ✓ SRK9_CACHE_DIR:  $cache_dir"

    mkdir -p $state_dir/migrations
    and echo "  ✓ SRK9_STATE_DIR:  $state_dir"

    mkdir -p $share_dir
    and echo "  ✓ SRK9_SHARE_DIR:  $share_dir"

    mkdir -p $opt_dir
    and echo "  ✓ SRK9_OPT_DIR:    $opt_dir"

    mkdir -p $bin_dir
    and echo "  ✓ SRK9_BIN_DIR:    $bin_dir"

    # Set universal environment variables
    echo ""
    echo "Setting environment variables..."

    set -Ux SRK9_CONFIG_DIR $config_dir
    set -Ux SRK9_CACHE_DIR $cache_dir
    set -Ux SRK9_STATE_DIR $state_dir
    set -Ux SRK9_SHARE_DIR $share_dir
    set -Ux SRK9_BIN_DIR $bin_dir
    set -Ux SRK9_OPT_DIR $opt_dir

    # Handle optional runtime directory
    if set -q XDG_RUNTIME_DIR
        set -l runtime_dir $XDG_RUNTIME_DIR/srk9
        mkdir -p $runtime_dir
        set -Ux SRK9_RUNTIME_DIR $runtime_dir
        echo "  ✓ SRK9_RUNTIME_DIR: $runtime_dir"
    end

    # Ensure bin directory is in PATH
    if not contains $bin_dir $fish_user_paths
        fish_add_path $bin_dir
        echo "  ✓ Added $bin_dir to PATH"
    else
        echo "  ✓ $bin_dir already in PATH"
    end

    echo ""
    echo "========================================"
    echo "SRK9 directories initialized"
    echo "Run 'srk9-env' to view current settings"
    echo "========================================"
end
