#!/bin/bash
# local shell for development and a plugin fallback if fish is not avialable onf the env PATH
# DEV_FISH_BIN=$PWD/usr/local/bin
# echo $DEV_FISH_BIN
# export PATH=$DEV_FISH_BIN:$PATH
# echo "$PATH"
# which fish
# exec "$DEV_FISH_BIN"/fish
# fallback
exec _dev/usr/local/bin/fish
