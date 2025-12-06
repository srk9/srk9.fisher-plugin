function srk9-env --description "Display SRK9 environment variables and directory status"
    echo "========================================"
    echo "SRK9 Environment"
    echo "========================================"
    echo ""

    # XDG Base Variables
    echo "XDG Base Directories:"
    echo "  XDG_CONFIG_HOME:  "(set -q XDG_CONFIG_HOME; and echo $XDG_CONFIG_HOME; or echo "(unset, default: ~/.config)")
    echo "  XDG_CACHE_HOME:   "(set -q XDG_CACHE_HOME; and echo $XDG_CACHE_HOME; or echo "(unset, default: ~/.cache)")
    echo "  XDG_STATE_HOME:   "(set -q XDG_STATE_HOME; and echo $XDG_STATE_HOME; or echo "(unset, default: ~/.local/state)")
    echo "  XDG_DATA_HOME:    "(set -q XDG_DATA_HOME; and echo $XDG_DATA_HOME; or echo "(unset, default: ~/.local/share)")
    echo "  XDG_RUNTIME_DIR:  "(set -q XDG_RUNTIME_DIR; and echo $XDG_RUNTIME_DIR; or echo "(unset)")
    echo ""

    # SRK9 Variables
    echo "SRK9 Directories:"

    if set -q SRK9_CONFIG_DIR
        set -l status_icon (test -d $SRK9_CONFIG_DIR; and echo "✓"; or echo "✗")
        echo "  SRK9_CONFIG_DIR:  $SRK9_CONFIG_DIR [$status_icon]"
    else
        echo "  SRK9_CONFIG_DIR:  (not set)"
    end

    if set -q SRK9_CACHE_DIR
        set -l status_icon (test -d $SRK9_CACHE_DIR; and echo "✓"; or echo "✗")
        echo "  SRK9_CACHE_DIR:   $SRK9_CACHE_DIR [$status_icon]"
    else
        echo "  SRK9_CACHE_DIR:   (not set)"
    end

    if set -q SRK9_STATE_DIR
        set -l status_icon (test -d $SRK9_STATE_DIR; and echo "✓"; or echo "✗")
        echo "  SRK9_STATE_DIR:   $SRK9_STATE_DIR [$status_icon]"
    else
        echo "  SRK9_STATE_DIR:   (not set)"
    end

    if set -q SRK9_SHARE_DIR
        set -l status_icon (test -d $SRK9_SHARE_DIR; and echo "✓"; or echo "✗")
        echo "  SRK9_SHARE_DIR:   $SRK9_SHARE_DIR [$status_icon]"
    else
        echo "  SRK9_SHARE_DIR:   (not set)"
    end

    if set -q SRK9_OPT_DIR
        set -l status_icon (test -d $SRK9_OPT_DIR; and echo "✓"; or echo "✗")
        echo "  SRK9_OPT_DIR:     $SRK9_OPT_DIR [$status_icon]"
    else
        echo "  SRK9_OPT_DIR:     (not set)"
    end

    if set -q SRK9_BIN_DIR
        set -l status_icon (test -d $SRK9_BIN_DIR; and echo "✓"; or echo "✗")
        echo "  SRK9_BIN_DIR:     $SRK9_BIN_DIR [$status_icon]"
    else
        echo "  SRK9_BIN_DIR:     (not set)"
    end

    if set -q SRK9_RUNTIME_DIR
        set -l status_icon (test -d $SRK9_RUNTIME_DIR; and echo "✓"; or echo "✗")
        echo "  SRK9_RUNTIME_DIR: $SRK9_RUNTIME_DIR [$status_icon]"
    else
        echo "  SRK9_RUNTIME_DIR: (not set - optional)"
    end

    echo ""
    echo "Legend: [✓] exists  [✗] missing"
    echo ""

    # Check if not initialized
    if not set -q SRK9_CONFIG_DIR
        echo "Run 'srk9-init-dirs' to initialize the directory structure."
    end
end
