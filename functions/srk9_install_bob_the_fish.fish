# https://github.com/powerline/fonts

function srk9_install_bob_the_fish --description "Install Bob the Fish theme for Oh My Fish"
    echo "Installing Bob the Fish theme..."

    # Check if Oh My Fish is installed
    if not command -q omf

        echo "Error: Oh My Fish (omf) is not installed."
        echo "Run 'srk9_install_omf' first, then try again."
        return 1
    end

    echo "Installing bobthefish theme via OMF..."
    omf install bobthefish

    if test $status -eq 0
        echo "✓ Bob the Fish theme installed successfully!"
        echo ""
        echo "Theme configuration tips:"
        echo "  - Set a Nerd Font in your terminal for best results"
        echo "  - Restart Fish or run 'exec fish' to see the new theme"
        echo "  - Configure with 'set -g theme_*' variables if needed"
    else
        echo "✗ Installation failed!"
        return 1
    end
end
