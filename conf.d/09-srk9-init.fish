# SrK9 Initialization

# aliases
alias 9-install-fish 'brew install fish'
alias 9-install-fisher 'curl -sL https://raw.githubusercontent.com/srk9/fisher/refs/heads/main/functions/fisher.fish | source && fisher install srk9/fisher'
alias 9-install-fisher-srk9 'fisher install srk9/srk9.fisher-plugin'


function dev-commit
    echo 'fish executing "commit"'
    git add .
    git commit -m 'triggered fish.commit'
    echo '"commit" complete'
end

function dev-push
    echo 'fish executing "push"'
    git push origin master
    echo '"push" complete'
end

function dev-update
    echo 'fish executing "update"'
    set srk9_plugin_dir ~/.config/fish/
    fisher update srk9/srk9.fisher-plugin
    echo '"update" complete'
end

function dev-upgrade
    echo 'fish executing "upgrade"'
    commit
    push
    update
    echo '"upgrade" complete'
end

function dev-build
    echo 'fish executing "build"'
    echo $PWD
    echo '"build" complete'
end

function dev-reset
    echo 'fish executing "reset"'
    rm -rvf ~/.config/fish
    echo '"reset" complete'
end
