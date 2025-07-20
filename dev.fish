#!/Users/dust/.local/opt/homebrew/bin/fish
#
#
echo '"sourceing" _dev.fish'

function commit
    echo 'fish executing "commit"'
    git add .
    git commit -m 'dev-upgrade'
    echo '"commit" complete'
end

function push
    echo 'fish executing "push"'
    git push origin master
    echo '"push" complete'
end

function update
    echo 'fish executing "update"'
    fisher update srk9/srk9.fisher-plugin
    echo '"update" complete'
end

function upgrade
    echo 'fish executing "upgrade"'
    commit
    push
    update
    echo '"upgrade" complete'
end

function build
    echo 'fish executing "build"'
    echo '"build" complete'
end

function reset
    echo 'fish executing "reset"'
    echo '"reset" complete'
end

echo '"sourcing" complete'
