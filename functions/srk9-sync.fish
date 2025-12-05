function srk9-sync --description "Sync assets from sync.srk9.io"
    set -l module $argv[1]
    set -l action $argv[2]
    
    if test -z "$module"
        echo "Usage: srk9-sync <module> [push|pull]"
        echo "Modules: fish, claude"
        echo ""
        echo "Examples:"
        echo "  srk9-sync fish pull    # Pull fish functions from cloud"
        echo "  srk9-sync fish push    # Push local functions to cloud"
        echo "  srk9-sync status       # Show sync status"
        return 1
    end
    
    set -l cache_dir ~/.local/cache/srk9/sync
    set -l api_url "https://sync.srk9.io/api/v1"
    
    # Status check
    if test "$module" = "status"
        echo "Checking sync.srk9.io..."
        curl -s "$api_url/modules" | jq -r '.modules[] | "\(.name): \(.count) assets"'
        return 0
    end
    
    # Ensure cache directory exists
    mkdir -p $cache_dir/$module
    
    switch $action
        case pull
            echo "Pulling $module assets..."
            set -l assets (curl -s "$api_url/modules/$module/assets" | jq -r '.assets[]')
            set -l count 0
            for asset in $assets
                set -l content (curl -s "$api_url/modules/$module/assets/$asset" | jq -r '.content')
                set -l target_dir (dirname "$cache_dir/$module/$asset")
                mkdir -p "$target_dir"
                echo "$content" > "$cache_dir/$module/$asset"
                set count (math $count + 1)
            end
            echo "Pulled $count assets to $cache_dir/$module/"
            
        case push
            echo "Push not yet implemented - use srk9-sync TUI"
            echo "  cd ~/.config/fish && bun run ~/path/to/srk9.sync/tui sync $module"
            
        case '*'
            echo "Unknown action: $action"
            echo "Use: pull or push"
            return 1
    end
end
