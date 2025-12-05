function srk9-bootstrap --description "Bootstrap srk9 environment on a fresh system"
    echo "=== srk9 Bootstrap ==="
    echo ""
    
    # Check dependencies
    if not type -q curl
        echo "Error: curl required"
        return 1
    end
    
    if not type -q jq
        echo "Installing jq..."
        if type -q brew
            brew install jq
        else
            echo "Error: jq required (install via brew or package manager)"
            return 1
        end
    end
    
    set -l cache_dir ~/.local/cache/srk9/sync
    set -l fish_functions ~/.config/fish/functions
    
    echo "1. Creating cache directories..."
    mkdir -p $cache_dir/fish
    mkdir -p $cache_dir/claude
    mkdir -p $fish_functions
    
    echo "2. Pulling fish functions from sync.srk9.io..."
    srk9-sync fish pull
    
    echo "3. Linking functions to fish config..."
    for f in $cache_dir/fish/*
        set -l name (basename $f)
        if not test -e "$fish_functions/$name.fish"
            ln -sf $f "$fish_functions/$name.fish"
            echo "  Linked: $name"
        end
    end
    
    echo ""
    echo "=== Bootstrap Complete ==="
    echo "Run 'srk9-list-functions' to see available functions"
end
