SrK9 - Fish(er) Plugin (v0.0.1.alpha)
===========================
> A Systems Redundency & Recovery Agent

NOTE: This package is not POSIX-compatible as it was hand-crafted just for Fish

 - 100% pure Fish—so simple to contribute to or tweak
 - Tab-completable for seamless shell integration
 - XDG Base Directory compliant
 - No setup needed—it just works!

## Installation via Fisher which requires Fish
`fisher install srk9/srk9-fisher-plugin.fish`

## Update
`fisher update srk9/srk9.fisher-plugin`

## Uninstall


### Dependency Chain

- [ ] Fisher (Requires Fish `which fish`)
    > The following command must be executed inside of fish shell (type "fish")
    `curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher`

- [ ] Fish `which fish` (Requires Brew `which brew`) as the easiest way to install fish is via Homebrew
      `brew install fish` && `which fish`

- [ ] Brew `which brew`


## TIPS:
Whenever you install or remove a plugin from the command line, Fisher jots down all the installed plugins in $__fish_config_dir/fish_plugins. Add this file to your dotfiles or version control to easily share your configuration across different systems.
